# Initialize global package registry
set_property(GLOBAL PROPERTY REQUIRED_PACKAGES "")
set_property(GLOBAL PROPERTY OPTIONAL_PACKAGES "")

# Function to register a package
function(register_package)
    cmake_parse_arguments(PKG
        ""  # No options
        "NAME;FOUND_VAR;BUILD_OPT;REQUIRED"  # Single-value args
        ""  # No multi-value args
        ${ARGN}
    )

    # Validate required arguments
    if(NOT PKG_NAME OR NOT PKG_FOUND_VAR)
        message(FATAL_ERROR "register_package requires NAME and FOUND_VAR")
    endif()

    # Set default values
    if(NOT PKG_BUILD_OPT)
        set(PKG_BUILD_OPT "NO_BUILD")
    endif()
    if(NOT DEFINED PKG_REQUIRED)
        set(PKG_REQUIRED FALSE)
    endif()

    # Create package info
    set(PKG_INFO "${PKG_NAME}\;${PKG_FOUND_VAR}\;${${PKG_FOUND_VAR}}\;${PKG_BUILD_OPT}")

    # Add to appropriate list
    if(PKG_REQUIRED)
        get_property(REQ_PKGS GLOBAL PROPERTY REQUIRED_PACKAGES)
        list(APPEND REQ_PKGS "${PKG_INFO}")
        set_property(GLOBAL PROPERTY REQUIRED_PACKAGES "${REQ_PKGS}")
    else()
        get_property(OPT_PKGS GLOBAL PROPERTY OPTIONAL_PACKAGES)
        list(APPEND OPT_PKGS "${PKG_INFO}")
        set_property(GLOBAL PROPERTY OPTIONAL_PACKAGES "${OPT_PKGS}")
    endif()
endfunction() 