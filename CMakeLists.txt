cmake_minimum_required(VERSION 3.15)
project(metada VERSION 1.0)

# Move this before any find_package calls
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules" ${CMAKE_MODULE_PATH})

# Add options near the top after project()
option(BUILD_DOCS "Build documentation" OFF)
option(BUILD_TESTS "Build tests" OFF)

# Find required packages first
find_package(MPI REQUIRED)

# Only find GTest if tests are enabled
if(BUILD_TESTS)
    find_package(GTest REQUIRED)
endif()

# Only find documentation tools if docs are enabled
if(BUILD_DOCS)
    find_package(Doxygen REQUIRED)
    find_package(Sphinx)
endif()

# Add testing support only if tests are enabled
if(BUILD_TESTS)
    include(CTest)
    enable_testing()
endif()

# Basic settings
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Code quality tools
find_package(ClangTidy)
find_program(CLANG_FORMAT "clang-format" 
    PATHS "C:/msys64/mingw64/bin"
)

# Add subdirectories
add_subdirectory(src)
add_subdirectory(include)

# Add tests conditionally
if(BUILD_TESTS)
    add_subdirectory(tests)
endif()

# Add docs conditionally
if(BUILD_DOCS)
    add_subdirectory(docs)
endif()

# Add after subdirectories
if(CLANG_FORMAT)
    file(GLOB_RECURSE ALL_SOURCE_FILES 
        ${PROJECT_SOURCE_DIR}/src/*.cpp
        ${PROJECT_SOURCE_DIR}/include/*.hpp
        ${PROJECT_SOURCE_DIR}/tests/*.cpp
    )

    add_custom_target(format
        COMMAND ${CLANG_FORMAT} -i ${ALL_SOURCE_FILES}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMENT "Formatting source code..."
    )
endif()

if(ClangTidy_FOUND)
    set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_EXECUTABLE})
    
    add_custom_target(lint
        COMMAND ${CLANG_TIDY_EXECUTABLE}
        ${CMAKE_SOURCE_DIR}/src/*.cpp
        ${CMAKE_SOURCE_DIR}/include/*.hpp
        ${CMAKE_SOURCE_DIR}/tests/*.cpp
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
        ${CMAKE_SOURCE_DIR}/tests/*.cpp
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