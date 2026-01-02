# Warehouse Simulator

## Overview

This is a training environment designed for users to clone this repository and set up basic DBT projects. Providing hands-on experience in an environment that simulates a project instance with limited functionality.

## Purpose

The Warehouse Simulator allows users to:
- Gain practical experience with DBT (Data Build Tool)
- Practice in a realistic environment
- Learn data warehouse modeling concepts
- Experiment with dimension and fact table structures

## Helpful Tips/Code Snippets

### File Associations

Add this to your VS Code settings to configure SQL file associations:

```json
{
   "files.associations": {
    "**/analyses/**/*.sql": "jinja-sql",
    "**/models/**/*.sql": "jinja-sql",
    "**/macros/**/*.sql": "jinja-sql",
    "**/snapshots/**/*.sql": "jinja-sql",
    "**/tests/**/*.sql": "jinja-sql",
    "**/*target/**/*.sql": "sql",
    "**/playground/**/*.sql": "sql",
    "**/scratch/**/*.sql": "sql",
    "**/sandbox/**/*.sql": "sql",
    "**/working/**/*.sql": "sql",
    "*.sql": "jinja-sql"
   }
}
```

### Git Setup

```bash
# Remove existing git repository
rm -rf .git

# Initialize a new git repository
git init

# Stage all files for commit
git stage .

# Create initial commit
git commit -m "init"

# Push to remote repository and set upstream
git push --set-upstream origin main
```

### Useful Git Commands

```bash
# Display remote repository URLs
git remote -v

# Navigate into the dbt directory
cd dbt

# Navigate back to parent directory
cd ..
```

### Python Environment Setup

```bash
# Check installed Python version
python --version

# Create a virtual environment named 'venv'
python -m venv venv

# Install packages from requirements file
pip install requirements.txt
```

### DBT Commands

```bash
# Install DBT package dependencies
dbt deps

# Test DBT connection and configuration
dbt debug
```

### Branch Management

```bash
# Create and checkout new branch from origin/main
git checkout -b feature/dbt_models origin/main

# Push new branch to remote and set upstream tracking
git push -u origin feature/dbt_models
```

### Environment Variables

Add this to the very bottom of `venv/scripts/activate` to automatically load environment variables:

```bash
# Load environment variables from .env file
set -a  # Enable allexport to export all variables
source .env
set +a  # Disable allexport
```
