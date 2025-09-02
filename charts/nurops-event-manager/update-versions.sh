#!/bin/bash
# Copyright (c) 2025 Nurol, Inc. (nurol.ai)
# This file is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).
# For commercial use, please contact info@nurol.ai

# Script to programmatically update Helm chart versions

set -e

CHART_DIR="$(dirname "$0")"
CHART_YAML="${CHART_DIR}/Chart.yaml"

# Function to update chart version
update_chart_version() {
    local new_version="$1"
    echo "Updating chart version to: $new_version"
    sed -i "s/^version: .*/version: $new_version/" "$CHART_YAML"
}

# Function to update app version
update_app_version() {
    local new_version="$1"
    echo "Updating app version to: $new_version"
    sed -i "s/^appVersion: .*/appVersion: \"$new_version\"/" "$CHART_YAML"
}

# Function to bump semantic version
bump_version() {
    local version="$1"
    local part="${2:-patch}"  # major, minor, or patch

    IFS='.' read -ra VERSION_PARTS <<< "$version"
    local major="${VERSION_PARTS[0]}"
    local minor="${VERSION_PARTS[1]}"
    local patch="${VERSION_PARTS[2]}"

    case $part in
        major)
            echo "$((major + 1)).0.0"
            ;;
        minor)
            echo "$major.$((minor + 1)).0"
            ;;
        patch)
            echo "$major.$minor.$((patch + 1))"
            ;;
        *)
            echo "Invalid bump type: $part" >&2
            exit 1
            ;;
    esac
}

# Function to get current versions
get_current_chart_version() {
    grep "^version:" "$CHART_YAML" | cut -d' ' -f2
}

get_current_app_version() {
    grep "^appVersion:" "$CHART_YAML" | cut -d' ' -f2 | tr -d '"'
}

# Main command handling
case "${1:-help}" in
    "chart")
        if [ -z "$2" ]; then
            echo "Current chart version: $(get_current_chart_version)"
        else
            update_chart_version "$2"
            echo "Chart version updated to: $(get_current_chart_version)"
        fi
        ;;
    "app")
        if [ -z "$2" ]; then
            echo "Current app version: $(get_current_app_version)"
        else
            update_app_version "$2"
            echo "App version updated to: $(get_current_app_version)"
        fi
        ;;
    "bump")
        current_version=$(get_current_chart_version)
        bump_type="${2:-patch}"
        new_version=$(bump_version "$current_version" "$bump_type")
        update_chart_version "$new_version"
        echo "Chart version bumped from $current_version to $new_version"
        ;;
    "show"|"status")
        echo "Chart version: $(get_current_chart_version)"
        echo "App version: $(get_current_app_version)"
        ;;
    *)
        echo "Usage: $0 {chart|app|bump|show} [version]"
        echo ""
        echo "Commands:"
        echo "  chart [VERSION]     - Show or set chart version"
        echo "  app [VERSION]       - Show or set app version"  
        echo "  bump [TYPE]         - Bump chart version (major|minor|patch, default: patch)"
        echo "  show                - Show current versions"
        echo ""
        echo "Examples:"
        echo "  $0 chart 0.4.0      - Set chart version to 0.4.0"
        echo "  $0 app 1.2.0        - Set app version to 1.2.0"
        echo "  $0 bump minor       - Bump minor version (0.3.0 -> 0.4.0)"
        echo "  $0 show             - Show current versions"
        ;;
esac
