#!/bin/bash

# Check if HOME is set
if [ -z "$HOME" ]; then
    echo "HOME environment variable is not set. Exiting."
    exit 1
fi

# Navigate to the terraform directory
cd terraform/ || { echo "Failed to change directory to terraform."; exit 1; }

# Generate the configuration file
terraform output > ../airflow/tasks/configuration.env
cat "$HOME/.aws/credentials" >> ../airflow/tasks/configuration.env

# Check if output directory exists
if [ ! -d "../airflow/tasks" ]; then
    echo "Output directory ../airflow/tasks does not exist. Exiting."
    exit 1
fi

# Navigate to the project root to install dependencies
cd ..

# Install dependencies using Poetry
if ! command -v poetry &> /dev/null; then
    echo "Poetry is not installed. Please install it before running this script."
    exit 1
fi

# Activate Poetry environment and install dependencies
poetry install || { echo "Poetry installation failed."; exit 1; }
