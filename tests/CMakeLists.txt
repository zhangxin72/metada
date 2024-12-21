add_executable(unit_tests
    test_parallel.cpp
)

target_link_libraries(unit_tests PRIVATE
    metada_lib
    GTest::GTest
    GTest::Main
    MPI::MPI_CXX
)

target_compile_definitions(unit_tests PRIVATE USE_MPI)

include(GoogleTest)
gtest_discover_tests(unit_tests) 