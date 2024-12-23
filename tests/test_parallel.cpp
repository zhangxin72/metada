#include <gtest/gtest.h>
#include <mpi.h>
#include <array>
#include <vector>

#include "ParallelBase.hpp"

namespace {
constexpr std::array<double, 4> TEST_DATA = {1.0, 2.0, 3.0, 4.0};
constexpr int DATA_SIZE = TEST_DATA.size();

class ParallelTest : public ::testing::Test {
private:
    int rank_{0};
    int size_{1};
    ParallelBase parallel_;

protected:
    void SetUp() override {
        MPI_Comm_rank(MPI_COMM_WORLD, &rank_);
        MPI_Comm_size(MPI_COMM_WORLD, &size_);
    }

    auto verify_distribution() -> void {
        std::vector<double> data;
        if (rank_ == 0) {
            data.assign(TEST_DATA.begin(), TEST_DATA.end());
        }
        parallel_.distribute(data);
    }

    auto verify_gathering() -> void {
        std::vector<double> result;
        parallel_.gather(result);
        verify_gathered_data(result);
    }

    auto verify_gathered_data(const std::vector<double>& result) const -> void {
        if (rank_ == 0) {
            ASSERT_EQ(result.size(), DATA_SIZE);
            for (size_t i = 0; i < DATA_SIZE; ++i) {
                EXPECT_DOUBLE_EQ(result[i], TEST_DATA[i]);
            }
        }
    }

    auto test_distribute_and_gather() -> void {
        verify_distribution();
        verify_gathering();
    }

    auto test_invalid_data_size() -> void {
        std::vector<double> invalid_data;
        if (rank_ == 0) {
            invalid_data = {TEST_DATA[0], TEST_DATA[1], TEST_DATA[2]};
        }
        EXPECT_THROW(parallel_.distribute(invalid_data), std::runtime_error);
    }
};

TEST_F(ParallelTest, DistributeAndGather) {
    test_distribute_and_gather();
}

TEST_F(ParallelTest, InvalidDataSize) {
    test_invalid_data_size();
}

}  // namespace

auto main(int argc, char** argv) -> int {
    MPI_Init(&argc, &argv);
    ::testing::InitGoogleTest(&argc, argv);
    const int result = RUN_ALL_TESTS();
    MPI_Finalize();
    return result;
}