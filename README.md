# Warehouse Simulator

## Overview

This is a training environment designed for users to clone this repository and set up basic DBT projects. Providing hands-on experience in an environment that simulates a project instance with limited functionality.

## Purpose

The Warehouse Simulator allows users to:
- Gain practical experience with DBT (Data Build Tool)
- Practice in a realistic environment
- Learn data warehouse modeling concepts
- Experiment with dimension and fact table structures

## Training Overview

### Pre-Warehouse Setup & Preparation
- Source system setup
- Future state diagraming

### Data Extraction
- Workspace setup
- Pipeline configuration

### Warehouse Implementation
- Model creation
- Querying data

### Reporting & Insight
- Central semantic model
- Report creation

## Prerequisites

- Completion of the data literacy training material
- Basic understanding of SQL & relational databases
- Familiarity with data visualization tools
- General awareness of purpose and value of a data warehouse
- Microsoft Tenant with a Fabric Capacity or account with Fabric Trial Capacity
- Service principal client and secret ID
- Ability to install the requirement tools/software

## Required Installations

Ensure you have the below software installed to ensure things work smoothly in later sessions:

- **Visual Studio Code** - [Download](https://code.visualstudio.com/download)
- **Python 3.12.0** - [Download](https://www.python.org/downloads/)
  - If this is your first time installing python you may have to add it to your PATH
- **Git/Git Bash** - [Download](https://git-scm.com/downloads)
- **ODBC Driver for Windows** - [Download Microsoft ODBC Driver 18 for SQL Server (x64)](https://learn.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server)
- **Power BI** - [Download](https://www.microsoft.com/en-us/download/details.aspx?id=58494)

> **Note:** If at any point you get stuck or blocked within this training or have feedback on how to improve this training, please reach out to your project consultant.

## Helpful Links

- [Starting Repository](https://github.com/billjirik/wh_simulation)
- [DBT Documentation](https://docs.getdbt.com/docs/introduction)
- [Service Principal Documentation](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-service-principal-portal)
- [Power BI Documentation](https://learn.microsoft.com/en-us/power-bi/)
- [Draw IO/Diagramming Tool](https://app.diagrams.net/)
- [Airtable](https://airtable.com/) & [Airtable Create Token](https://airtable.com/create/tokens)
- [Airtable API Documentation](https://airtable.com/developers/web/api/list-records)
- [Python Virtual Environment Documentation](https://docs.python.org/3/library/venv.html)

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

# Check the working tree status
git status
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

# Build a specific model and its downstream dependencies
dbt build -s {{model path or name}}

# Build a specific model and all its upstream dependencies
dbt build -s +{{model path or name}}

# Generate DBT documentation
dbt docs generate

# Serve DBT documentation in a local web server
dbt docs serve
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
