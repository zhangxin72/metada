# My Project

A C++ project using CMake build system.

## Prerequisites

- C++ compiler (MinGW-w64)
- CMake (version 3.15 or higher)
- Git
- Visual Studio Code
  - C/C++ Extension
  - CMake Tools Extension

## Building the Project

1. Clone the repository:   ```bash
   git clone <your-repository-url>
   cd my_project   ```

2. Build the project:   ```bash
   cmake -B build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug
   cmake --build build   ```

3. Run the executable:   ```bash
   ./build/bin/my_project   ```

## Development

- Use `Ctrl+Shift+B` to build in VSCode
- Press `F5` to debug 