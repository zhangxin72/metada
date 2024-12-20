cmake_minimum_required(VERSION 3.15)
project(metada VERSION 1.0)

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
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
)

# Compiler warnings
if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Wpedantic)
endif()

# Find required tools
find_package(Doxygen REQUIRED)
find_package(Sphinx)
find_package(ClangTidy)

# Clang Format
find_program(CLANG_FORMAT "clang-format" 
    PATHS
        "C:/Program Files/LLVM/bin"
        "C:/LLVM/bin"
        "C:/msys64/mingw64/bin"
)

if(CLANG_FORMAT)
    add_custom_target(format
        COMMAND ${CLANG_FORMAT} -i ${ALL_SOURCE_FILES}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Formatting source code..."
    )
endif()

# Clang Tidy
if(ClangTidy_FOUND)
    set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_EXECUTABLE})
    
    add_custom_target(lint
        COMMAND ${CLANG_TIDY_EXECUTABLE}
        ${CMAKE_SOURCE_DIR}/src/*.cpp
        ${CMAKE_SOURCE_DIR}/include/*.hpp
        --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy
        --checks=*
        -p=${CMAKE_BINARY_DIR}
        --header-filter=.*
        --
        -I${CMAKE_SOURCE_DIR}/include
        -IC:/msys64/mingw64/include/c++/14.2.0
        -IC:/msys64/mingw64/include/c++/14.2.0/x86_64-w64-mingw32
        -IC:/msys64/mingw64/include/c++/14.2.0/backward
        -IC:/msys64/mingw64/include
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running clang-tidy..."
    )

    add_custom_target(fix
        COMMAND ${CLANG_TIDY_EXECUTABLE}
        ${CMAKE_SOURCE_DIR}/src/*.cpp
        ${CMAKE_SOURCE_DIR}/include/*.hpp
        --config-file=${CMAKE_SOURCE_DIR}/.clang-tidy
        --checks=*
        -p=${CMAKE_BINARY_DIR}
        --header-filter=.*
        --fix
        --
        -I${CMAKE_SOURCE_DIR}/include
        -IC:/msys64/mingw64/include/c++/14.2.0
        -IC:/msys64/mingw64/include/c++/14.2.0/x86_64-w64-mingw32
        -IC:/msys64/mingw64/include/c++/14.2.0/backward
        -IC:/msys64/mingw64/include
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Running clang-tidy with fixes..."
    )
endif()

# Documentation
if(DOXYGEN_FOUND)
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/docs/doxygen)
    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/docs/xml)
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
endif()

if(SPHINX_FOUND)
    set(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/docs/source)
    set(SPHINX_BUILD ${CMAKE_CURRENT_SOURCE_DIR}/docs/build)
    set(SPHINX_INDEX_FILE ${SPHINX_BUILD}/html/index.html)

    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/conf.py.in
        ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/conf.py
        @ONLY
    )

    add_custom_command(OUTPUT ${SPHINX_INDEX_FILE}
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
        COMMAND ${SPHINX_EXECUTABLE} -b html
            ${SPHINX_SOURCE} ${SPHINX_BUILD}/html
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS
            ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/conf.py
            ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/api.rst
            ${DOXYGEN_OUT}
        MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/docs/source/index.rst
        COMMENT "Generating documentation with Doxygen and Sphinx"
    )

    add_custom_target(docs ALL DEPENDS ${SPHINX_INDEX_FILE})
endif() 