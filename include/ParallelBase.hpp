#ifndef PARALLEL_BASE_HPP
#define PARALLEL_BASE_HPP

#include <mpi.h>

#include <vector>

class ParallelBase {
public:
    ParallelBase(MPI_Comm comm = MPI_COMM_WORLD);
    virtual ~ParallelBase() = default;

    virtual void distribute(const std::vector<double>& global_data);
    virtual void gather(std::vector<double>& global_result);

    auto getRank() const -> int {
        return m_rank;
    }
    auto getSize() const -> int {
        return m_size;
    }
    auto getComm() const -> MPI_Comm {
        return m_comm;
    }

private:
    MPI_Comm m_comm;
    int m_rank{0};
    int m_size{1};
    std::vector<double> m_local_data;
};

#endif