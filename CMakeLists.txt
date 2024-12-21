cmake_minimum_required(VERSION 3.15)
project(metada VERSION 1.0)

# Find required packages first
find_package(MPI REQUIRED)
find_package(GTest REQUIRED)

# Add testing support
include(CTest)
enable_testing()

# Basic settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

# Collect source files
file(GLOB_RECURSE SOURCES "src/*.cpp")
file(GLOB_RECURSE ALL_SOURCE_FILES 
    ${PROJECT_SOURCE_DIR}/src/*.cpp
    ${PROJECT_SOURCE_DIR}/include/*.hpp
)

# Main target
add_executable(${PROJECT_NAME} ${SOURCES})
target_include_directories(${PROJECT_NAME} PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)
target_link_libraries(${PROJECT_NAME} PRIVATE MPI::MPI_CXX)
target_compile_definitions(${PROJECT_NAME} PRIVATE USE_MPI)

# Tests
add_executable(unit_tests
    tests/test_parallel.cpp
    src/ParallelBase.cpp
)

target_include_directories(unit_tests PRIVATE
    ${CMAKE_SOURCE_DIR}/include
    ${MPI_CXX_INCLUDE_DIRS}
)

target_link_libraries(unit_tests PRIVATE
    GTest::GTest
    GTest::Main
    MPI::MPI_CXX
)

target_compile_definitions(unit_tests PRIVATE USE_MPI)

include(GoogleTest)
gtest_discover_tests(unit_tests) 