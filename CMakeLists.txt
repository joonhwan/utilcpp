cmake_minimum_required( VERSION 2.8 )

project( UtilCPP )

# Important directories :
set( UTILCPP_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} )
set( UTILCPP_INCLUDE_DIR ${UTILCPP_ROOT_DIR}/include )

set( UTILCPP_HEADERS_DIR ${UTILCPP_INCLUDE_DIR}/utilcpp )
set( UTILCPP_SOURCE_DIR ${UTILCPP_ROOT_DIR}/sources )

set( UTILCPP_CMAKE_DIR ${UTILCPP_ROOT_DIR}/cmake )

# CMake utilities for C++
set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${UTILCPP_CMAKE_DIR} )

set( UTILCPP_CMAKE_DIR ${UTILCPP_CMAKE_DIR}
	CACHE PATH "Directories containing CMake utilisies." FORCE )

include( utilcpp_projects )
UTILCPP_USE_BOOST()

#--------------------------------------------
# UTILCPP source files

# headers
set( UTILCPP_HEADERS
	${UTILCPP_HEADERS_DIR}/hardconfig.hpp
	${UTILCPP_HEADERS_DIR}/assert.hpp
	${UTILCPP_HEADERS_DIR}/log.hpp
	${UTILCPP_HEADERS_DIR}/singleton.hpp
	${UTILCPP_HEADERS_DIR}/platforminfo.hpp
	${UTILCPP_HEADERS_DIR}/moduleapi.hpp
)

# sources
set( UTILCPP_SOURCES
	${UTILCPP_SOURCE_DIR}/log.cpp
)

# all source files
set( UTILCPP_ALL_FILES
	${UTILCPP_HEADERS}
	${UTILCPP_SOURCES}
)

# Grouping
source_group( utilcpp FILES ${UTILCPP_ALL_FILES} )

# Make sure required include directories will be available for compilation
set( UTILCPP_INCLUDE_DIR ${UTILCPP_INCLUDE_DIR}
	CACHE PATH "Directories to include in projects using UtilCPP" FORCE
)

include_directories( ${UTILCPP_INCLUDE_DIR} )


# Generate the library
add_library( utilcpp STATIC ${UTILCPP_ALL_FILES} )
