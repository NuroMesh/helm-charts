#!/bin/bash

# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

set -e

# Function to display usage
usage() {
    echo "Usage: $0 [OPTIONS] [CHART_PATH]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -v, --verbose  Enable verbose output"
    echo ""
    echo "Arguments:"
    echo "  CHART_PATH     Specific chart path to test (e.g., charts/nurops-event-manager)"
    echo "                 If not provided, tests all charts in nurops/*/"
    echo ""
    echo "Examples:"
    echo "  $0                                  # Test all charts"
    echo "  $0 charts/nurops-event-manager      # Test specific chart"
    echo "  $0 -v charts/nurops-event-manager   # Test with verbose output"
}

# Function to test a single chart
test_chart() {
    local chart_path="$1"
    local verbose="$2"
    
    if [ ! -d "$chart_path" ]; then
        echo "Error: Chart directory '$chart_path' does not exist"
        return 1
    fi
    
    if [ ! -f "$chart_path/Chart.yaml" ]; then
        echo "Error: No Chart.yaml found in '$chart_path'"
        return 1
    fi
    
    echo "Testing $chart_path"
    
    if [ "$verbose" = "true" ]; then
        helm template test --debug "$chart_path"
    else
        helm template test "$chart_path" > /dev/null
    fi
    
    echo "✅ $chart_path - PASSED"
}

# Function to test all charts
test_all_charts() {
    local verbose="$1"
    local found_charts=false
    
    echo "Testing all charts in charts/*/"
    echo "=================================="
    
    for chart in charts/*/; do
        if [ -f "$chart/Chart.yaml" ]; then
            found_charts=true
            test_chart "$chart" "$verbose"
        fi
    done
    
    if [ "$found_charts" = "false" ]; then
        echo "No charts found in charts/*/"
        return 1
    fi
}

# Parse command line arguments
VERBOSE=false
CHART_PATH=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -*)
            echo "Error: Unknown option $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "$CHART_PATH" ]; then
                CHART_PATH="$1"
            else
                echo "Error: Multiple chart paths specified"
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Main execution
echo "Helm Chart Validation Script"
echo "============================"

if [ -n "$CHART_PATH" ]; then
    # Test specific chart
    test_chart "$CHART_PATH" "$VERBOSE"
else
    # Test all charts
    test_all_charts "$VERBOSE"
fi

echo ""
echo "✅ All tests completed successfully!"
