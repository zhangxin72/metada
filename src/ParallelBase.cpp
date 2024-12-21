#include "ParallelBase.hpp"

#include <stdexcept>

ParallelBase::ParallelBase(MPI_Comm comm) : m_comm(comm) {
    MPI_Comm_rank(comm, &m_rank);
    MPI_Comm_size(comm, &m_size);
}

void ParallelBase::distribute(const std::vector<double>& global_data) {
    int global_size;
    if (m_rank == 0) {
        global_size = global_data.size();
    }
    // Broadcast the size first
    MPI_Bcast(&global_size, 1, MPI_INT, 0, m_comm);

    // Calculate local size and resize buffer
    const int local_size = global_size / m_size;
    if (global_size % m_size != 0) {
        throw std::runtime_error("Data size must be divisible by number of processes");
    }

    m_local_data.resize(local_size);

    MPI_Scatter(m_rank == 0 ? global_data.data() : nullptr, local_size, MPI_DOUBLE, m_local_data.data(), local_size,
                MPI_DOUBLE, 0, m_comm);
}

void ParallelBase::gather(std::vector<double>& global_result) {
    const int local_size = m_local_data.size();

    if (m_rank == 0) {
        global_result.resize(local_size * m_size);
    }

    MPI_Gather(m_local_data.data(), local_size, MPI_DOUBLE, m_rank == 0 ? global_result.data() : nullptr, local_size,
               MPI_DOUBLE, 0, m_comm);
}