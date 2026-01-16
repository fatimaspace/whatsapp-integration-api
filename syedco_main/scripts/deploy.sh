#!/bin/bash

# Syedco Custom Deploy Script
# This script helps deploy the application

set -e

echo "🚀 Syedco Custom Deploy"
echo "======================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if running from correct directory
if [ ! -f "package.json" ]; then
    print_error "This script must be run from the project root directory"
    exit 1
fi

# Parse command line arguments
ENVIRONMENT=${1:-production}
VERSION=${2:-latest}

print_info "Environment: $ENVIRONMENT"
print_info "Version: $VERSION"
echo ""

# Load configuration
CONFIG_FILE="syedco_main/config/environment-config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

print_success "Configuration loaded"

# Pre-deploy checks
echo ""
echo "🔍 Running pre-deploy checks..."

# Check if Docker is installed
if command -v docker &> /dev/null; then
    print_success "Docker is installed"
else
    print_error "Docker is not installed"
    exit 1
fi

# Check if Docker daemon is running
if docker info &> /dev/null; then
    print_success "Docker daemon is running"
else
    print_error "Docker daemon is not running"
    exit 1
fi

# Build Docker image
echo ""
echo "🏗️  Building Docker image..."
IMAGE_NAME="evolution-api-syedco"
IMAGE_TAG="${IMAGE_NAME}:${VERSION}"

if docker build -t "$IMAGE_TAG" .; then
    print_success "Docker image built: $IMAGE_TAG"
else
    print_error "Docker build failed"
    exit 1
fi

# Tag image
echo ""
echo "🏷️  Tagging image..."
docker tag "$IMAGE_TAG" "${IMAGE_NAME}:latest"
print_success "Image tagged as latest"

# Push to registry (if configured)
echo ""
echo "📤 Would you like to push to Docker registry? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Enter Docker registry (default: docker.io):"
    read -r registry
    registry=${registry:-docker.io}
    
    echo "Enter Docker username:"
    read -r username
    
    if [ -n "$username" ]; then
        FULL_IMAGE_NAME="${registry}/${username}/${IMAGE_NAME}:${VERSION}"
        docker tag "$IMAGE_TAG" "$FULL_IMAGE_NAME"
        
        print_info "Pushing $FULL_IMAGE_NAME..."
        if docker push "$FULL_IMAGE_NAME"; then
            print_success "Image pushed successfully"
            
            # Also push latest tag
            LATEST_IMAGE_NAME="${registry}/${username}/${IMAGE_NAME}:latest"
            docker tag "$IMAGE_TAG" "$LATEST_IMAGE_NAME"
            docker push "$LATEST_IMAGE_NAME"
            print_success "Latest tag pushed"
        else
            print_error "Failed to push image"
            exit 1
        fi
    fi
else
    print_warning "Skipped pushing to registry"
fi

# Deploy using docker-compose (local)
echo ""
echo "🐳 Would you like to deploy locally using docker-compose? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if [ -f "docker-compose.yaml" ]; then
        print_info "Stopping existing containers..."
        docker-compose down
        
        print_info "Starting containers..."
        if docker-compose up -d; then
            print_success "Containers started"
            
            echo ""
            print_info "Waiting for services to be ready..."
            sleep 5
            
            docker-compose ps
        else
            print_error "Failed to start containers"
            exit 1
        fi
    else
        print_warning "docker-compose.yaml not found, skipping local deployment"
    fi
fi

# Summary
echo ""
echo "======================="
echo "✨ Deploy Summary"
echo ""
echo "Environment: $ENVIRONMENT"
echo "Image: $IMAGE_TAG"
echo "Status: ✅ Deployed"
echo ""
echo "To check logs: docker-compose logs -f"
echo "To stop: docker-compose down"
echo "======================="
