#!/bin/bash

# Syedco Custom Setup Script
# This script helps set up the custom workflow environment

set -e

echo "🚀 Syedco Custom Workflow Setup"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
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

print_success "Running from project root"

# Check if syedco_main folder exists
if [ ! -d "syedco_main" ]; then
    print_error "syedco_main folder not found!"
    exit 1
fi

print_success "Found syedco_main folder"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
if npm ci; then
    print_success "Dependencies installed"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Generate Prisma client
echo ""
echo "🗄️  Generating Prisma client..."
if npm run db:generate; then
    print_success "Prisma client generated"
else
    print_warning "Prisma client generation failed (may need DATABASE_PROVIDER set)"
fi

# Check environment file
echo ""
echo "⚙️  Checking environment configuration..."
if [ -f ".env" ]; then
    print_success "Environment file (.env) exists"
else
    print_warning "No .env file found"
    echo "   Creating .env from .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env file from .env.example"
        print_warning "Please edit .env file with your configuration"
    else
        print_error "No .env.example file found"
    fi
fi

# Copy workflow files
echo ""
echo "📋 Would you like to copy custom workflows to .github/workflows/? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    mkdir -p .github/workflows
    
    for workflow in syedco_main/workflows/*.yml; do
        filename=$(basename "$workflow")
        if [ -f ".github/workflows/$filename" ]; then
            print_warning ".github/workflows/$filename already exists, skipping..."
        else
            cp "$workflow" ".github/workflows/$filename"
            print_success "Copied $filename to .github/workflows/"
        fi
    done
else
    print_warning "Skipped copying workflows. You can manually copy them later from syedco_main/workflows/"
fi

# Run linting
echo ""
echo "🔍 Running code quality checks..."
if npm run lint:check; then
    print_success "Linting passed"
else
    print_warning "Linting found some issues"
fi

# Build the project
echo ""
echo "🏗️  Building project..."
if npm run build; then
    print_success "Build completed successfully"
else
    print_error "Build failed"
    exit 1
fi

# Summary
echo ""
echo "================================"
echo "✨ Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Review and edit .env file with your configuration"
echo "2. Configure GitHub Secrets if using workflows:"
echo "   - DATABASE_PROVIDER"
echo "   - DATABASE_URL"
echo "   - DOCKER_USERNAME (for deploy)"
echo "   - DOCKER_PASSWORD (for deploy)"
echo "3. Review workflow files in .github/workflows/"
echo "4. Start the development server: npm run dev:server"
echo ""
echo "For more information, see syedco_main/README.md"
echo "================================"
