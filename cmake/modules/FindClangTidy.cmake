# Find clang-tidy
include(PackageRegistry)

find_program(CLANG_TIDY_EXECUTABLE 
    NAMES clang-tidy clang-tidy.exe
    DOC "Path to clang-tidy executable"
    REQUIRED
)

# Handle REQUIRED and QUIET arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ClangTidy
    FOUND_VAR ClangTidy_FOUND
    REQUIRED_VARS CLANG_TIDY_EXECUTABLE
    FAIL_MESSAGE "Could NOT find clang-tidy executable"
)

mark_as_advanced(CLANG_TIDY_EXECUTABLE)

if(ClangTidy_FOUND)
    # Create imported target
    if(NOT TARGET ClangTidy::ClangTidy)
        add_executable(ClangTidy::ClangTidy IMPORTED)
        set_target_properties(ClangTidy::ClangTidy PROPERTIES
            IMPORTED_LOCATION "${CLANG_TIDY_EXECUTABLE}"
        )
    endif()

    # Register package after it's found
    register_package(
        NAME "ClangTidy"
        FOUND_VAR CLANG_TIDY_EXECUTABLE
        REQUIRED TRUE
    )
endif()
 