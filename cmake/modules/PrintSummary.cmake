function(print_build_summary)
    # Helper functions
    function(format_yes_no VAR)
        if(${VAR})
            set(${VAR} "YES" PARENT_SCOPE)
        else()
            set(${VAR} "NO" PARENT_SCOPE)
        endif()
    endfunction()

    function(format_enabled_disabled VAR)
        if(${VAR})
            set(${VAR} "Enabled" PARENT_SCOPE)
        else()
            set(${VAR} "Disabled" PARENT_SCOPE)
        endif()
    endfunction()

    # Function to print package status
    function(print_package_status PKG)
        if(NOT PKG)
            return()
        endif()
        
        string(REPLACE ";" " " PKG_LIST "${PKG}")
        list(LENGTH PKG_LIST LIST_LENGTH)
        if(LIST_LENGTH LESS 4)
            return()
        endif()
        
        list(GET PKG_LIST 0 PKG_NAME)
        list(GET PKG_LIST 1 FOUND_VAR)
        list(GET PKG_LIST 3 BUILD_OPT)
        
        format_yes_no(${FOUND_VAR})
        if(NOT ${BUILD_OPT} STREQUAL "NO_BUILD")
            format_enabled_disabled(${BUILD_OPT})
            message(STATUS "│   ${PKG_NAME}:       Found: ${${FOUND_VAR}}  Build: ${${BUILD_OPT}}")
        else()
            message(STATUS "│   ${PKG_NAME}:       Found: ${${FOUND_VAR}}")
        endif()
    endfunction()

    # Get registered packages
    get_property(REQUIRED_PACKAGES GLOBAL PROPERTY REQUIRED_PACKAGES)
    get_property(OPTIONAL_PACKAGES GLOBAL PROPERTY OPTIONAL_PACKAGES)

    # Get language info
    get_property(ENABLED_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)
    
    # Function to print language settings
    function(print_language_settings LANG)
        if(CMAKE_${LANG}_COMPILER)
            message(STATUS "│   ${LANG} Compiler: ${CMAKE_${LANG}_COMPILER}")
            message(STATUS "│   ${LANG} Standard: ${CMAKE_${LANG}_STANDARD}")
            
            if(CMAKE_BUILD_TYPE STREQUAL "Debug")
                set(LANG_FLAGS "${CMAKE_${LANG}_FLAGS} ${CMAKE_${LANG}_FLAGS_DEBUG}")
            else()
                set(LANG_FLAGS "${CMAKE_${LANG}_FLAGS} ${CMAKE_${LANG}_FLAGS_RELEASE}")
            endif()
            message(STATUS "│   ${LANG} Flags: ${LANG_FLAGS}")
        endif()
    endfunction()

    # Print header
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
    foreach(LANG ${ENABLED_LANGUAGES})
        print_language_settings(${LANG})
    endforeach()
    message(STATUS "├──────────────────────────────────────────────────┤")

    # Print required packages
    message(STATUS "│ Required Packages:")
    foreach(PKG IN LISTS REQUIRED_PACKAGES)
        print_package_status("${PKG}")
    endforeach()
    message(STATUS "├──────────────────────────────────────────────────┤")

    # Print optional packages
    message(STATUS "│ Optional Packages:")
    foreach(PKG IN LISTS OPTIONAL_PACKAGES)
        print_package_status("${PKG}")
    endforeach()
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