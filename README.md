# metada

A C++ project using CMake build system with Sphinx documentation.

## Prerequisites

- C++ compiler (MinGW-w64)
- CMake (version 3.15 or higher)
- Git
- Visual Studio Code
  - C/C++ Extension
  - CMake Tools Extension
- Python 3.x with pip
- Sphinx (`pip install sphinx sphinx-rtd-theme breathe`)
- Doxygen

## Building the Project

1. Clone the repository:   ```bash
   git clone <your-repository-url>
   cd metada   ```

2. Build the project:   ```bash
   cmake -B build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug
   cmake --build build   ```

3. Run the executable:   ```bash
   ./build/bin/metada   ```

## Development

- Use `Ctrl+Shift+B` to build in VSCode
- Press `F5` to debug 