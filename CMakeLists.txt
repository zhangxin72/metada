cmake_minimum_required(VERSION 3.15)
project(metada VERSION 1.0 LANGUAGES CXX Fortran)

# Disable In-source build
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "In-source build is not allowed.")
endif()

# Set module path
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

# Basic settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Include required modules
include(CodeQuality)

# Build options
option(BUILD_DOCS "Build documentation" OFF)
option(BUILD_TESTS "Build tests" OFF)

# Find required packages
find_package(MPI REQUIRED)
find_package(glog REQUIRED)

# Optional packages based on build options
if(BUILD_TESTS)
    find_package(GTest REQUIRED)
    include(CTest)
    enable_testing()
endif()

# Add code quality targets
add_code_quality_targets()

# Add subdirectories
add_subdirectory(src)
add_subdirectory(include)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()

if(BUILD_DOCS)
    add_subdirectory(docs)
endif()