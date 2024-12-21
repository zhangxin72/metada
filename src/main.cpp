#include <mpi.h>

#include <iostream>
#include <vector>

#include "ParallelBase.hpp"

auto main(int argc, char* argv[]) -> int {
    MPI_Init(&argc, &argv);

    ParallelBase parallel;
    int rank = 0;

    try {
        rank = parallel.getRank();
        const int size = parallel.getSize();

        if (rank == 0) {
            // Create test data divisible by number of processes
            std::vector<double> data(size * 2);  // 2 elements per process
            for (size_t i = 0; i < data.size(); ++i) {
                data[i] = static_cast<double>(i + 1);
            }
            parallel.distribute(data);
        } else {
            parallel.distribute({});
        }

        // Process local data...
        std::vector<double> result;
        parallel.gather(result);

        if (rank == 0) {
            std::cout << "Result: ";
            for (const auto& val : result) {
                std::cout << val << " ";
            }
            std::cout << '\n';
        }
    } catch (const std::exception& e) {
        std::cerr << "Error on rank " << rank << ": " << e.what() << '\n';
        MPI_Abort(MPI_COMM_WORLD, 1);
    }

    MPI_Finalize();
    return 0;
}