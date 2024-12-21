if(DOXYGEN_FOUND)
    # Set Doxygen input and output paths
    set(DOXYGEN_INPUT_DIR ${CMAKE_SOURCE_DIR})
    set(DOXYGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/docs/doxygen)
    set(DOXYGEN_INDEX_FILE ${DOXYGEN_OUTPUT_DIR}/xml/index.xml)
    
    # Create output directories
    file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR})
    file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR}/xml)

    # Configure Doxygen
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)

    # Add Doxygen command
    add_custom_command(OUTPUT ${DOXYGEN_INDEX_FILE}
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        MAIN_DEPENDENCY ${DOXYGEN_OUT} ${DOXYGEN_IN}
        COMMENT "Generating Doxygen documentation"
        VERBATIM)
endif()

if(SPHINX_FOUND)
    set(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/source)
    set(SPHINX_BUILD ${CMAKE_BINARY_DIR}/docs/sphinx)
    set(SPHINX_INDEX_FILE ${SPHINX_BUILD}/html/index.html)

    # Create Sphinx build directory
    file(MAKE_DIRECTORY ${SPHINX_BUILD})
    
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/source/conf.py.in
        ${SPHINX_SOURCE}/conf.py
        @ONLY
    )

    # Add Sphinx command
    add_custom_command(OUTPUT ${SPHINX_INDEX_FILE}
        DEPENDS ${DOXYGEN_INDEX_FILE}
        COMMAND ${SPHINX_EXECUTABLE} -b html
            ${SPHINX_SOURCE} ${SPHINX_BUILD}/html
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating Sphinx documentation"
        VERBATIM)

    # Add documentation target
    add_custom_target(docs ALL DEPENDS ${SPHINX_INDEX_FILE})
endif() 