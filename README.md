# metada

A C++ project using CMake build system with comprehensive documentation support through Sphinx and Doxygen, along with code quality tools.

## Prerequisites

### Required Tools
- MSYS2 with MinGW-w64 (GCC 14.2.0)
  - Install from: https://www.msys2.org/
  - Run: `pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-make`
- CMake (version 3.15 or higher)
- Git
- Visual Studio Code with extensions:
  - C/C++ Extension
  - CMake Tools Extension

### Documentation Tools
- Python 3.x with pip
- Sphinx and extensions:
  ```bash
  pip install sphinx sphinx-rtd-theme breathe
  ```
- Doxygen
  - Download from: https://www.doxygen.nl/download.html

### Code Quality Tools
- LLVM/Clang tools (for formatting and static analysis):
  ```bash
  # Using MSYS2:
  pacman -S mingw-w64-x86_64-clang-tools-extra
  ```

## Building the Project

1. Clone the repository:
   ```bash
   git clone <your-repository-url>
   cd metada
   ```

2. Configure and build:
   ```bash
   cmake -B build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug
   cmake --build build
   ```

3. Run the executable:
   ```bash
   ./build/bin/metada
   ```

## Development

### VSCode Integration
- Use `Ctrl+Shift+B` to build
- Press `F5` to debug
- Tasks are configured for:
  - Building (`cmake build`)
  - Code formatting (`format`)
  - Static analysis (`lint`)

### Available CMake Targets
- `build`: Builds the project
- `docs`: Generates documentation using Doxygen and Sphinx
- `format`: Formats code using clang-format (fixes style issues)
- `lint`: Runs clang-tidy static analyzer (shows warnings)
- `fix`: Runs clang-tidy with --fix flag (attempts to fix warnings)

### Documentation
Documentation is automatically generated using:
- Doxygen for C++ API documentation
- Sphinx for overall project documentation
- Output is available in `build/docs/html`

### Code Style
The project uses:
- Google C++ style guide (via .clang-format)
- Comprehensive static analysis rules (via .clang-tidy)
- C++17 standard

