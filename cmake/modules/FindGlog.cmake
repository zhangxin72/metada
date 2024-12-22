include(PackageRegistry)

find_package(glog CONFIG)

if(NOT glog_FOUND)
    find_path(GLOG_INCLUDE_DIR glog/logging.h)
    find_library(GLOG_LIBRARY glog)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(Glog
        FOUND_VAR Glog_FOUND
        REQUIRED_VARS 
            GLOG_LIBRARY
            GLOG_INCLUDE_DIR
    )

    if(Glog_FOUND AND NOT TARGET glog::glog)
        add_library(glog::glog UNKNOWN IMPORTED)
        set_target_properties(glog::glog PROPERTIES
            IMPORTED_LOCATION "${GLOG_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${GLOG_INCLUDE_DIR}"
        )
    endif()
endif()

if(Glog_FOUND)
    register_package(
        NAME "Glog"
        FOUND_VAR Glog_FOUND
        REQUIRED TRUE
    )
endif() 