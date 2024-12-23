add_executable(unit_tests
    test_parallel.cpp
)

target_link_libraries(unit_tests PRIVATE
    metada_lib
    GTest::GTest
    GTest::Main
    MPI::MPI_CXX
    glog::glog
)

target_compile_definitions(unit_tests PRIVATE USE_MPI)

# Add a custom test that runs with MPI
add_test(
    NAME parallel_ests
    COMMAND ${MPIEXEC_EXECUTABLE} 
            ${MPIEXEC_NUMPROC_FLAG} 4 
            ${MPIEXEC_PREFLAGS}
            $<TARGET_FILE:unit_tests>
            ${MPIEXEC_POSTFLAGS}
) 