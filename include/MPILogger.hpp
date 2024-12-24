#ifndef MPI_LOGGER_HPP
#define MPI_LOGGER_HPP

#include <glog/logging.h>
#include <mpi.h>

#include <iomanip>
#include <string>

class MPILogger {
public:
    static void prefixFormatter(
        std::ostream& stream,
        const google::LogMessage& message, void* /*data*/) {
        stream << "[Rank " << rank_ << "] "
               << google::GetLogSeverityName(
                      message.severity())[0]
               << std::setw(2) << std::setfill('0')
               << message.time().month() << std::setw(2)
               << message.time().day() << ' ' << std::setw(2)
               << message.time().hour() << ':' << std::setw(2)
               << message.time().min() << ':' << std::setw(2)
               << message.time().sec() << "." << std::setw(6)
               << message.time().usec() << ' '
               << message.basename() << ':' << message.line()
               << "] ";
    }

    static void init(const char* argv0,
                     MPI_Comm comm = MPI_COMM_WORLD) {
        int rank;
        MPI_Comm_rank(comm, &rank);

        // Store rank for logging
        rank_ = rank;

        // Initialize glog
        google::InitGoogleLogging(argv0);

        // Configure logging
        FLAGS_logtostderr = true;
        FLAGS_log_prefix = true;

        // Install custom prefix formatter
        google::InstallPrefixFormatter(&prefixFormatter);
    }

    static void shutdown() {
        google::ShutdownGoogleLogging();
    }

    [[nodiscard]] static auto getRank() -> int {
        return rank_;
    }

private:
    static int rank_;
};

// Define static member
int MPILogger::rank_ = 0;

#endif