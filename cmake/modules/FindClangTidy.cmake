# Find clang-tidy
find_program(CLANG_TIDY_EXECUTABLE 
    NAMES 
        clang-tidy
        "clang-tidy.exe"
    PATHS
        "C:/Program Files/LLVM/bin"
        "C:/LLVM/bin"
        "C:/msys64/mingw64/bin"
    DOC "Path to clang-tidy executable"
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
endif() 