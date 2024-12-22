# Find clang-tidy
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
)

mark_as_advanced(CLANG_TIDY_EXECUTABLE) 