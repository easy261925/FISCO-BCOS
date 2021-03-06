include(ExternalProject)
include(GNUInstallDirs)

set(BOOST_CXXFLAGS "")
if (WIN32)
    set(BOOST_BOOTSTRAP_COMMAND bootstrap.bat)
    set(BOOST_BUILD_TOOL b2.exe)
    set(BOOST_LIBRARY_SUFFIX -vc140-mt-1_63.lib)
else()
    set(BOOST_BOOTSTRAP_COMMAND ./bootstrap.sh)
    set(BOOST_BUILD_TOOL ./b2)
    set(BOOST_LIBRARY_SUFFIX .a)
    if (${BUILD_SHARED_LIBS})
        set(BOOST_CXXFLAGS "cxxflags=-fPIC")
    endif()
endif()

set(BOOST_CXXFLAGS "cxxflags=-Wa,-march=generic64")

set(CMAKE_ARGS -DOPENSSL_INCLUDE_DIRS=${OPENSSL_INCLUDE_DIRS})
ExternalProject_Add(boost
    PREFIX ${CMAKE_SOURCE_DIR}/deps
    DOWNLOAD_NO_PROGRESS 1
    URL https://github.com/FISCO-BCOS/FISCO-BCOS/raw/master/deps/src/boost_1_63_0.tar.gz
    URL_HASH SHA256=eb4c6f7e4e11905e1a98619f8a664dc4dca2d477bc985cfaf94463eef83a1aaa
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ${BOOST_BOOTSTRAP_COMMAND}
    LOG_CONFIGURE 1
    BUILD_COMMAND ${BOOST_BUILD_TOOL} stage
        ${BOOST_CXXFLAGS}
        threading=multi
        link=static
        variant=release
        address-model=64
        --with-chrono
        --with-date_time
        --with-filesystem
        --with-random
        --with-regex
        --with-test
        --with-thread
    LOG_BUILD 1
    INSTALL_COMMAND ""
)

if (ENCRYPTTYPE)
	add_dependencies(boost tassl)
endif()

ExternalProject_Get_Property(boost SOURCE_DIR)
set(BOOST_INCLUDE_DIR ${SOURCE_DIR})
set(BOOST_LIB_DIR ${SOURCE_DIR}/stage/lib)
unset(BUILD_DIR)

add_library(Boost::Chrono STATIC IMPORTED)
set_property(TARGET Boost::Chrono PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_chrono${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Chrono boost)

add_library(Boost::DataTime STATIC IMPORTED)
set_property(TARGET Boost::DataTime PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_date_time${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::DataTime boost)

add_library(Boost::Regex STATIC IMPORTED)
set_property(TARGET Boost::Regex PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_regex${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Regex boost)

add_library(Boost::System STATIC IMPORTED)
set_property(TARGET Boost::System PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_system${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::System boost)

add_library(Boost::Filesystem STATIC IMPORTED)
set_property(TARGET Boost::Filesystem PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_filesystem${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Filesystem PROPERTY INTERFACE_LINK_LIBRARIES Boost::System)
add_dependencies(Boost::Filesystem boost)

add_library(Boost::Random STATIC IMPORTED)
set_property(TARGET Boost::Random PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_random${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::Random boost)

add_library(Boost::UnitTestFramework STATIC IMPORTED)
set_property(TARGET Boost::UnitTestFramework PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_unit_test_framework${BOOST_LIBRARY_SUFFIX})
add_dependencies(Boost::UnitTestFramework boost)

add_library(Boost::Thread STATIC IMPORTED)
set_property(TARGET Boost::Thread PROPERTY IMPORTED_LOCATION ${BOOST_LIB_DIR}/libboost_thread${BOOST_LIBRARY_SUFFIX})
set_property(TARGET Boost::Thread PROPERTY INTERFACE_LINK_LIBRARIES Boost::Chrono Boost::DataTime Boost::Regex)
add_dependencies(Boost::Thread boost)
