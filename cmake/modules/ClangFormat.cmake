find_program(CLANG_FORMAT_EXECUTABLE NAMES clang-format REQUIRED)

function(add_clang_format TARGET_NAME)
    if(CLANG_FORMAT_EXECUTABLE)
        add_custom_target(
            ${TARGET_NAME}
            COMMAND ${CLANG_FORMAT_EXECUTABLE}
            -i
            ${CMAKE_SOURCE_DIR}/src/*.cpp
            ${CMAKE_SOURCE_DIR}/include/*.hpp
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Running clang-format on source files..."
        )
    endif()
endfunction()