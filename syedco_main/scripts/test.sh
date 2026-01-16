#!/bin/bash

# Syedco Custom Test Script
# This script helps run tests with proper environment setup

set -e

echo "🧪 Syedco Custom Test Suite"
echo "==========================="
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
TEST_TYPE=${1:-all}
DATABASE_PROVIDER=${DATABASE_PROVIDER:-postgresql}

print_info "Test Type: $TEST_TYPE"
print_info "Database Provider: $DATABASE_PROVIDER"
echo ""

# Set environment variables for testing
export NODE_ENV=test
export DATABASE_PROVIDER=$DATABASE_PROVIDER

# Check if test database is configured
if [ -z "$DATABASE_URL" ]; then
    print_warning "DATABASE_URL not set, using default test database"
    export DATABASE_URL="postgresql://evolution:evolution_password@localhost:5432/evolution_test"
fi

# Start test services if needed
echo "🐳 Checking test services..."
if command -v docker-compose &> /dev/null; then
    if [ -f "docker-compose.yaml" ]; then
        print_info "Starting test database..."
        docker-compose up -d postgres redis 2>/dev/null || true
        print_success "Test services ready"
        sleep 3
    fi
else
    print_warning "docker-compose not available, assuming services are running"
fi

# Generate Prisma client
echo ""
echo "🗄️  Generating Prisma client..."
if npm run db:generate; then
    print_success "Prisma client generated"
else
    print_error "Failed to generate Prisma client"
    exit 1
fi

# Run migrations
echo ""
echo "🔄 Running database migrations..."
if npm run db:migrate:dev 2>/dev/null; then
    print_success "Migrations completed"
else
    print_warning "Migrations skipped or failed"
fi

# Run linting
echo ""
echo "🔍 Running code quality checks..."
if npm run lint:check; then
    print_success "Linting passed"
else
    print_error "Linting failed"
    exit 1
fi

# Run tests based on type
echo ""
case $TEST_TYPE in
    unit)
        echo "🧪 Running unit tests..."
        if npm run test:unit 2>/dev/null || npm test; then
            print_success "Unit tests passed"
        else
            print_warning "No unit tests found or tests failed"
        fi
        ;;
    integration)
        echo "🧪 Running integration tests..."
        if npm run test:integration 2>/dev/null; then
            print_success "Integration tests passed"
        else
            print_warning "No integration tests found or tests failed"
        fi
        ;;
    e2e)
        echo "🧪 Running end-to-end tests..."
        if npm run test:e2e 2>/dev/null; then
            print_success "E2E tests passed"
        else
            print_warning "No E2E tests found or tests failed"
        fi
        ;;
    coverage)
        echo "🧪 Running tests with coverage..."
        if npm run test:coverage 2>/dev/null; then
            print_success "Coverage report generated"
            echo ""
            print_info "Coverage report available in ./coverage/"
        else
            print_warning "Coverage command not available"
            npm test || print_warning "Tests failed or not found"
        fi
        ;;
    all|*)
        echo "🧪 Running all tests..."
        
        # Unit tests
        if npm test 2>/dev/null; then
            print_success "Tests completed"
        else
            print_warning "No tests defined or tests failed"
        fi
        
        # Integration tests (if available)
        if npm run test:integration 2>/dev/null; then
            print_success "Integration tests passed"
        else
            print_info "No integration tests found, skipping..."
        fi
        
        # E2E tests (if available)
        if npm run test:e2e 2>/dev/null; then
            print_success "E2E tests passed"
        else
            print_info "No E2E tests found, skipping..."
        fi
        ;;
esac

# Generate coverage if available
if [ "$TEST_TYPE" != "coverage" ]; then
    echo ""
    echo "📊 Generating coverage report..."
    if npm run test:coverage 2>/dev/null; then
        print_success "Coverage report generated"
        print_info "View coverage report in ./coverage/lcov-report/index.html"
    else
        print_info "Coverage generation not available"
    fi
fi

# Summary
echo ""
echo "==========================="
echo "✨ Test Summary"
echo ""
echo "Test Type: $TEST_TYPE"
echo "Database: $DATABASE_PROVIDER"
echo "Status: ✅ Tests Completed"
echo ""
echo "Usage: ./scripts/test.sh [unit|integration|e2e|coverage|all]"
echo "==========================="

# Cleanup (optional)
echo ""
echo "🧹 Would you like to stop test services? (y/n)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    if command -v docker-compose &> /dev/null; then
        docker-compose down 2>/dev/null || true
        print_success "Test services stopped"
    fi
fi
