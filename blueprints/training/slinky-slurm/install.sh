#!/bin/bash

# Parse arguments for setup
RUN_SETUP=true
SETUP_ARGS=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --skip-setup)
      RUN_SETUP=false
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo "      --skip-setup    Use previously generated slurm-values.yaml with image_repository, image_tag, and ssh_key values set."
      echo "Bubbling up help from setup.sh..."
      ./setup.sh --help
      exit 0
      ;;
    --repo-name|--tag|--region)
      SETUP_ARGS="$SETUP_ARGS $1 $2"
      shift 2
      ;;
    --skip-build)
      SETUP_ARGS="$SETUP_ARGS $1"
      shift
      ;;
    *)
      break
      ;;
  esac
done

if [[ "$RUN_SETUP" == "true" ]]; then
  echo "Running setup..."
  ./setup.sh $SETUP_ARGS
else
  echo "Skipping setup..."
  # Check if slurm-values.yaml exists (generated from template)
  if [[ ! -f slurm-values.yaml ]]; then
    echo "Error: slurm-values.yaml not found."
    echo "Run without --skip-setup flag, add --help for help"
    exit 1
  fi
fi

# Save current working directory to jump back later
BLUEPRINT_DIR=$(pwd)

# Jump into infra directory
cd ../../../infra/slinky-slurm

# Kick-off Terraform deployment
source install.sh

# Executed from within the ai-on-eks/infra/slinky-slurm/terraform/_LOCAL directory
REGION="$(echo "var.region" | terraform console -var-file=../blueprint.tfvars | tr -d '"')"

# Get the S3 bucket name
S3_BUCKET_NAME=$(terraform output -raw fsx_s3_bucket_name)

# Jump back to the ai-on-eks/blueprints/training/slinky-slurm directory
cd "$BLUEPRINT_DIR"

# Copy sbatch to S3 bucket for DRA sync
aws s3 cp llama2_7b-training.sbatch s3://${S3_BUCKET_NAME}/ --region $REGION

# update local kubeconfig
aws eks update-kubeconfig --name slurm-on-eks

# Install Slurm Cluster
helm install slurm oci://ghcr.io/slinkyproject/charts/slurm \
 --values=slurm-values.yaml --version=0.4.0 --namespace=slurm --create-namespace --set global.kubeVersionOverride="1.33.4"

# Wait for the slurm-login service to exist
until kubectl get service slurm-login -n slurm >/dev/null 2>&1; do
  echo "Waiting for slurm-login service..."
  sleep 5
done

# Get the IP address
IP_ADDRESS="$(curl -s https://checkip.amazonaws.com)"
echo "Using IP address $IP_ADDRESS to secure NLB source range"

# Generate service patch from template
sed "s|\${ip_address}|${IP_ADDRESS}|g" \
  slurm-login-service-patch.yaml.template > slurm-login-service-patch.yaml

# Apply the service patch
kubectl patch service slurm-login -n slurm --patch-file slurm-login-service-patch.yaml
