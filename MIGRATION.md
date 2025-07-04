# Migration from TCPDBench to CPDBENCH

This document outlines the key changes made in transitioning from the original TCPDBench to the modern CPDBENCH implementation.

## Major Changes

### 🚀 Python Dependency Management
- **Before**: Manual virtual environments with pip
- **After**: Modern `uv` for fast, reliable dependency management
- **Migration**: `pip install -r requirements.txt` → `uv sync --all-extras`

### 🐳 Docker Removal
- **Before**: Docker-based development and CI
- **After**: Native development with comprehensive installation guides
- **Benefits**: Faster development, simpler setup, better performance

### 📦 Package Structure
- **Before**: `tcpdbench` package name
- **After**: `cpdbench` package name with updated scripts
- **Scripts**: `tcpd-*` → `cpd-*` (e.g., `cpd-summarize`, `cpd-validate`)

### 🔧 Development Tools
- **Added**: Modern development dependencies (pytest, black, ruff)
- **Improved**: Better error handling and validation
- **Enhanced**: More comprehensive installation documentation

## Breaking Changes

### Repository URLs
```bash
# Old
git clone https://github.com/alan-turing-institute/TCPDBench

# New  
git clone https://github.com/Tripudium/CPDBENCH
```

### Installation Commands
```bash
# Old workflow
pip install -r analysis/requirements.txt
make venv_bocpdms
make venv_rbocpdms

# New workflow
uv sync --all-extras
make venvs  # Now uses uv internally
```

### Package Names
```python
# Old
pip install tcpdbench

# New
pip install cpdbench
```

## Compatibility

### What's Preserved
- ✅ All analysis scripts and functionality
- ✅ R integration and workflows  
- ✅ Makefile-based pipeline orchestration
- ✅ Experiment configuration (abed_conf.py)
- ✅ Dataset formats and schemas
- ✅ Output formats (tables, figures, constants)

### What's Improved
- 🚀 Faster dependency installation with uv
- 📚 Better documentation with platform-specific instructions
- 🧹 Cleaner codebase without Docker complexity
- 🔧 Modern Python tooling integration
- 🌍 Cross-platform installation guides

## Migration Steps for Users

1. **Update repository reference**:
   ```bash
   git remote set-url origin https://github.com/Tripudium/CPDBENCH
   ```

2. **Install uv** (if not already installed):
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

3. **Update dependencies**:
   ```bash
   uv sync --all-extras
   ```

4. **Continue with normal workflow**:
   ```bash
   make results  # Everything else works the same!
   ```

## For Contributors

### Development Setup
```bash
# Clone the new repository
git clone https://github.com/Tripudium/CPDBENCH
cd CPDBENCH

# Install all dependencies including dev tools
uv sync --all-extras

# Run analysis pipeline
make results
```

### Adding New Methods
The process is largely the same, but now uses uv workspaces:

1. Create `execs/python/yourmethod/pyproject.toml`
2. Update `abed_conf.py` with `uv run --project` commands
3. Run `make venvs` to set up environments

## Version History

- **TCPDBench 1.x**: Original implementation with Docker + pip
- **CPDBENCH 2.0**: Modern implementation with uv + native development

## Questions?

For questions about the migration, please [open an issue](https://github.com/Tripudium/CPDBENCH/issues) in the new repository.