cmake_minimum_required(VERSION 3.15)
project(metada VERSION 1.0)

# Add module path
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set build directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Find required packages
find_package(Doxygen REQUIRED)
find_package(Sphinx)

# Add source files
file(GLOB_RECURSE SOURCES "src/*.cpp")

# Add executable
add_executable(${PROJECT_NAME} ${SOURCES})

# Include directories
target_include_directories(${PROJECT_NAME} 
    PRIVATE 
        ${PROJECT_SOURCE_DIR}/include
)

# Configure Doxygen
if(DOXYGEN_FOUND)
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    
    # Create output directories
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/docs/doxygen)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/docs/xml)
    
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
endif()

# Configure Sphinx
if(SPHINX_FOUND)
    set(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/docs/source)
    set(SPHINX_BUILD ${CMAKE_CURRENT_SOURCE_DIR}/docs/build)
    set(SPHINX_INDEX_FILE ${SPHINX_BUILD}/html/index.html)

    # Configure conf.py from template
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/conf.py.in
        ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/conf.py
        @ONLY
    )

    # Add documentation targets
    add_custom_command(OUTPUT ${SPHINX_INDEX_FILE}
        COMMAND 
            ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
        COMMAND 
            ${SPHINX_EXECUTABLE} -b html
            ${SPHINX_SOURCE} ${SPHINX_BUILD}/html
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS
            ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/conf.py
            ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/api.rst
            ${DOXYGEN_OUT}
        MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/index.rst
        COMMENT "Generating documentation with Doxygen and Sphinx")

    add_custom_target(docs ALL DEPENDS ${SPHINX_INDEX_FILE})
endif()

# Development warnings
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
endif() 