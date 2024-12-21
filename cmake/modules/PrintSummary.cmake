function(print_build_summary)
    # Helper function to format yes/no
    function(format_yes_no VAR)
        if(${VAR})
            set(${VAR} "YES" PARENT_SCOPE)
        else()
            set(${VAR} "NO" PARENT_SCOPE)
        endif()
    endfunction()

    # Helper function to format enabled/disabled
    function(format_enabled_disabled VAR)
        if(${VAR})
            set(${VAR} "Enabled" PARENT_SCOPE)
        else()
            set(${VAR} "Disabled" PARENT_SCOPE)
        endif()
    endfunction()

    # Format boolean values
    format_yes_no(MPI_CXX_FOUND)
    format_yes_no(GTest_FOUND)
    format_yes_no(DOXYGEN_FOUND)
    format_yes_no(Sphinx_FOUND)
    
    # Handle ClangTidy status
    if(CLANG_TIDY_EXECUTABLE)
        set(CLANG_TIDY_STATUS "YES")
    else()
        set(CLANG_TIDY_STATUS "NO")
    endif()

    # Handle ClangFormat status
    if(CLANG_FORMAT)
        set(FORMAT_STATUS "YES")
    else()
        set(FORMAT_STATUS "NO")
    endif()

    format_enabled_disabled(BUILD_TESTS)
    format_enabled_disabled(BUILD_DOCS)
    if(BUILD_DOCS)
        format_enabled_disabled(BUILD_SPHINX)
    endif()

    message(STATUS "\n")
    message(STATUS "┌──────────────────────────────────────────────────┐")
    message(STATUS "│               Build Summary                      │")
    message(STATUS "├──────────────────────────────────────────────────┤")
    
    # Project info
    message(STATUS "│ Project: ${PROJECT_NAME} v${PROJECT_VERSION}")
    message(STATUS "├──────────────────────────────────────────────────┤")

    # Build info
    message(STATUS "│ Build Configuration:")
    message(STATUS "│   Type: ${CMAKE_BUILD_TYPE}")
    message(STATUS "│   Directory: ${CMAKE_BINARY_DIR}")
    message(STATUS "├──────────────────────────────────────────────────┤")

    # Compiler info
    message(STATUS "│ Compiler Configuration:")
    message(STATUS "│   C++ Compiler: ${CMAKE_CXX_COMPILER}")
    message(STATUS "│   C++ Standard: ${CMAKE_CXX_STANDARD}")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(COMPILER_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
    else()
        set(COMPILER_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
    endif()
    message(STATUS "│   Flags: ${COMPILER_FLAGS}")
    message(STATUS "├───�������──────────────────────────────────────────────┤")

    # Required packages
    message(STATUS "│ Required Packages:")
    message(STATUS "│   MPI:         Found: ${MPI_CXX_FOUND}")
    message(STATUS "│   ClangTidy:   Found: ${CLANG_TIDY_STATUS}")
    message(STATUS "│   ClangFormat: Found: ${FORMAT_STATUS}")
    message(STATUS "├──────────────────────────────────────────────────┤")

    # Optional packages
    message(STATUS "│ Optional Packages:")
    message(STATUS "│   GTest:       Found: ${GTest_FOUND}  Build: ${BUILD_TESTS}")
    message(STATUS "│   Doxygen:     Found: ${DOXYGEN_FOUND}  Build: ${BUILD_DOCS}")
    message(STATUS "│   Sphinx:      Found: ${Sphinx_FOUND}  Build: ${BUILD_DOCS}")
    message(STATUS "├──────────────────────────────────────────────────┤")

    # Build options
    message(STATUS "│ Build Options:")
    message(STATUS "│   BUILD_TESTS: ${BUILD_TESTS}")
    message(STATUS "│   BUILD_DOCS:  ${BUILD_DOCS}")
    if(BUILD_DOCS)
        message(STATUS "│   BUILD_SPHINX: ${BUILD_SPHINX}")
    endif()
    message(STATUS "└──────────────────────────────────────────────────┘")
    message(STATUS "\n")
endfunction() 