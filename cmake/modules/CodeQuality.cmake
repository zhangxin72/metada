function(add_code_quality_targets)
    # Find and register tools first
    find_package(ClangTidy)
    find_package(ClangFormat)

    # Collect source files
    file(GLOB_RECURSE ALL_SOURCE_FILES 
        ${PROJECT_SOURCE_DIR}/src/*.cpp
        ${PROJECT_SOURCE_DIR}/include/*.hpp
        ${PROJECT_SOURCE_DIR}/tests/*.cpp
    )

    # Add format target
    if(CLANG_FORMAT_EXECUTABLE)
        add_custom_target(format
            COMMAND ${CLANG_FORMAT_EXECUTABLE} -i ${ALL_SOURCE_FILES}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMENT "Formatting source code..."
        )
    endif()

    # Add lint and fix targets
    if(CLANG_TIDY_EXECUTABLE)
        set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_EXECUTABLE})
        
        set(CLANG_TIDY_COMMAND
            ${CLANG_TIDY_EXECUTABLE}
            --config-file=${PROJECT_SOURCE_DIR}/.clang-tidy
            --header-filter='${PROJECT_SOURCE_DIR}/include/*'
            --system-headers=0
            ${PROJECT_SOURCE_DIR}/src/*.cpp
            ${PROJECT_SOURCE_DIR}/include/*.hpp
            ${PROJECT_SOURCE_DIR}/tests/*.cpp
            -p=${CMAKE_BINARY_DIR}
            --
            -I${PROJECT_SOURCE_DIR}/include
        )

        add_custom_target(lint
            COMMAND ${CLANG_TIDY_COMMAND}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMENT "Running clang-tidy..."
        )

        add_custom_target(fix
            COMMAND ${CLANG_TIDY_COMMAND} --fix
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMENT "Running clang-tidy with fixes..."
        )
    endif()
endfunction() 