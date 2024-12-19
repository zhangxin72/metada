Installation Guide
==================

Prerequisites
-------------

* C++ compiler (MinGW-w64)
* CMake (version 3.15 or higher)
* Python 3.x with pip
* Sphinx and extensions
* Doxygen

Steps
-----

1. Clone the repository::

    git clone <repository-url>
    cd metada

2. Build the project::

    cmake -B build -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug
    cmake --build build

3. Build documentation::

    cmake --build build --target docs