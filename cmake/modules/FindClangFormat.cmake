include(PackageRegistry)

find_program(CLANG_FORMAT_EXECUTABLE 
    NAMES clang-format clang-format.exe
    DOC "Path to clang-format executable"
    REQUIRED
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ClangFormat
    FOUND_VAR ClangFormat_FOUND
    REQUIRED_VARS CLANG_FORMAT_EXECUTABLE
)

if(ClangFormat_FOUND)
    # Register package after it's found
    register_package(
        NAME "ClangFormat"
        FOUND_VAR CLANG_FORMAT_EXECUTABLE
        REQUIRED TRUE
    )
endif() 