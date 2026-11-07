#!/bin/bash

# Mock CI/CD Pipeline Script
# Demonstrates how to integrate OpenTelemetry validation as a quality gate

DEPLOYMENT_NAME="sample-app-v1.2.3"
ENVIRONMENT="staging"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_step() {
    echo -e "${BLUE}[PIPELINE]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

simulate_build() {
    log_step "Step 1: Building application..."
    sleep 2
    log_success "Application built successfully"
}

simulate_unit_tests() {
    log_step "Step 2: Running unit tests..."
    sleep 1
    log_success "All unit tests passed"
}

simulate_deploy_to_staging() {
    log_step "Step 3: Deploying to staging environment..."
    sleep 2
    log_success "Deployment to staging completed"
}

run_observability_validation() {
    log_step "Step 4: Running observability validation (Quality Gate)..."

    if ./scripts/otel_check.sh; then
        log_success "Observability validation passed - deployment can proceed"
        return 0
    else
        log_error "Observability validation failed - blocking deployment"
        return 1
    fi
}

simulate_production_deployment() {
    log_step "Step 5: Deploying to production..."
    sleep 3
    log_success "Production deployment completed successfully"
}

main() {
    echo "=========================================="
    echo "CI/CD Pipeline: $DEPLOYMENT_NAME"
    echo "Environment: $ENVIRONMENT"
    echo "=========================================="

    simulate_build
    simulate_unit_tests
    simulate_deploy_to_staging

    if run_observability_validation; then
        simulate_production_deployment
        log_success "Pipeline completed successfully!"
        return 0
    else
        log_error "Pipeline failed at observability validation gate"
        log_warning "Production deployment blocked due to observability issues"
        return 1
    fi
}

main "$@"
