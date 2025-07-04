# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **CPDBENCH** (Change Point Detection Benchmark), a modern implementation of the Turing Change Point Detection Benchmark. This comprehensive benchmark evaluates change point detection algorithms on real-world time series data, featuring modern Python tooling with uv for dependency management and a streamlined development experience.

## Key Commands

### Building Results and Analysis
```bash
# Generate all results (tables, figures, constants)
make results

# Generate specific components
make tables
make figures
make cd_diagrams
make constants

# Clean and rebuild
make clean && make results
```

### Virtual Environments
```bash
# Set up all virtual environments (Python with uv and R)
make venvs

# Python environment using uv
uv sync --all-extras   # Direct uv command for Python dependencies

# Individual environments (legacy compatibility)
make venv_bocpdms      # Now uses uv workspace
make venv_rbocpdms     # Now uses uv workspace  
make R_venv            # R virtual environment

# Clean environments
make clean_venvs
```

### Running Experiments
```bash
# Initialize experiment tasks (requires abed)
abed reload_tasks

# Check experiment status
abed status

# Run experiments in parallel
mpiexec -np 4 abed local
```

### Analysis Dependencies

#### Python Dependencies
```bash
# Install Python dependencies using uv (recommended)
uv sync --all-extras

# Alternative: Install Python analysis dependencies with pip
pip install -r analysis/requirements.txt
```

#### R Dependencies
```bash
# Install R and Rscript first:
# macOS: brew install r
# Linux: sudo apt install r-base r-base-dev
# Windows: Download from https://cran.r-project.org/

# Install required R packages
Rscript -e "install.packages(c('argparse', 'exactRankTests'))"
```

#### LaTeX Dependencies (for figure generation)
```bash
# macOS: brew install --cask mactex
# Linux: sudo apt install texlive-full
# Windows: Install MiKTeX or TeX Live
```

## Architecture Overview

### Experiment Management
- **abed_conf.py**: Central configuration defining all datasets, methods, hyperparameters, and experiment commands
- Experiments managed via the `abed` framework, which coordinates parallel execution across methods and datasets
- Two experiment types: `oracle` (full hyperparameter grid search) and `default` (default parameters only)

### Method Implementations
- **execs/R/**: R-based change point detection methods (PELT, AMOC, BinSeg, SegNeigh, WBS, ECP, etc.)
  - Common utilities in `utils.R` for dataset loading, parameter handling, and result formatting
- **execs/python/**: Python-based methods (BOCPD variants, Zero baseline)
  - Shared utilities in `cpdbench_utils.py`
  - Uses uv workspaces for dependency management with individual `pyproject.toml` files

### Analysis Pipeline
- **analysis/scripts/**: Data analysis and visualization scripts
  - `summarize.py`: Aggregates raw experiment results into summary files
  - `make_table.py`: Generates LaTeX tables for paper
  - `critical_difference_diagram.py`: Statistical comparison diagrams
  - `common.py`: Shared analysis functionality and data structures
- Results flow: Raw JSON → Summaries → Tables/Figures/Constants

### Data Flow
1. **Input**: JSON datasets from TCPD (in `datasets/` directory)
2. **Execution**: Methods run via abed, output JSON results to `abed_results/`
3. **Summarization**: Scripts aggregate results into `analysis/output/summaries/`
4. **Analysis**: Generate final outputs in `analysis/output/{tables,figures,constants}/`

## Method Development

### Adding New Methods
1. Create executable script in `execs/R/` or `execs/python/`
2. Follow existing patterns for parameter handling and output formatting
3. For Python methods, create `execs/python/yourmethod/pyproject.toml` with dependencies
4. Update `abed_conf.py`:
   - Add method to `METHODS` list (both `oracle_` and `default_` variants)
   - Define parameters in `PARAMS` dictionary
   - Add execution commands in `COMMANDS` dictionary using `uv run --project` for Python methods
5. Set up dependencies in `Rpackages.txt` (R) or method-specific `pyproject.toml` (Python)

### Result Format
All methods output standardized JSON with:
- Command used, script hash, hostname
- Dataset name and hash
- Status: SUCCESS/FAIL/TIMEOUT/SKIP
- Parameters used
- Change point locations (0-based indexing)
- Runtime

## Important Notes

- **Change point locations**: Always 0-based indexing (consistent across R and Python)
- **Data normalization**: Datasets are automatically normalized to prevent numerical issues
- **Missing data handling**: Methods must handle missing values or declare incompatibility
- **Multidimensional support**: Only specific methods (BOCPD variants, ECP, KCPA, Zero) support multidimensional data
- **Python dependency management**: Uses uv for fast, reliable Python package management
- **R library management**: Uses RSimpleVenv for reproducible R package versions  
- **LaTeX requirement**: Figure generation requires working LaTeX installation with `latexmk`

## Validation
```bash
# Validate experiment results against schema
python utils/validate_schema.py -s schema.json -r abed_results/
```