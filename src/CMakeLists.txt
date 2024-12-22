add_library(metada_lib
    ParallelBase.cpp
)

target_include_directories(metada_lib PUBLIC
    ${CMAKE_SOURCE_DIR}/include
)

target_link_libraries(metada_lib PUBLIC
    MPI::MPI_CXX
    glog::glog
)

add_executable(${PROJECT_NAME}
    main.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    metada_lib
)

target_compile_definitions(${PROJECT_NAME} PRIVATE USE_MPI) 