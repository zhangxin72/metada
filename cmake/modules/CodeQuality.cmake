function(add_code_quality_targets)
    # Find tools
    find_package(ClangTidy)
    find_program(CLANG_FORMAT "clang-format" REQUIRED)

    # Collect source files
    file(GLOB_RECURSE ALL_SOURCE_FILES 
        ${PROJECT_SOURCE_DIR}/src/*.cpp
        ${PROJECT_SOURCE_DIR}/include/*.hpp
        ${PROJECT_SOURCE_DIR}/tests/*.cpp
    )

    # Add format target
    if(CLANG_FORMAT)
        add_custom_target(format
            COMMAND ${CLANG_FORMAT} -i ${ALL_SOURCE_FILES}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            COMMENT "Formatting source code..."
        )
    endif()

    # Add lint and fix targets
    if(ClangTidy_FOUND)
        set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY_EXECUTABLE})
        
        set(CLANG_TIDY_COMMAND
            ${CLANG_TIDY_EXECUTABLE}
            ${PROJECT_SOURCE_DIR}/src/*.cpp
            ${PROJECT_SOURCE_DIR}/include/*.hpp
            ${PROJECT_SOURCE_DIR}/tests/*.cpp
            --config-file=${PROJECT_SOURCE_DIR}/.clang-tidy
            --checks=*
            -p=${CMAKE_BINARY_DIR}
            --header-filter=.*
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