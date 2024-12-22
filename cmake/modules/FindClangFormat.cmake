# Find clang-format
find_program(CLANG_FORMAT_EXECUTABLE 
    NAMES clang-format clang-format.exe
    DOC "Path to clang-format executable"
    REQUIRED
)

# Handle REQUIRED and QUIET arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ClangFormat
    FOUND_VAR ClangFormat_FOUND
    REQUIRED_VARS CLANG_FORMAT_EXECUTABLE
)

mark_as_advanced(CLANG_FORMAT_EXECUTABLE)