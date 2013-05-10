cmake_minimum_required (VERSION 2.8)

project( UtilCPP )

# Dependencies:
if( WIN32 ) 
	# On Windows: check that the right boost binaries are set before continuing
	if( NOT DEFINED BOOST_LIBRARYDIR OR BOOST_LIBRARYDIR STREQUAL "BOOST_LIBRARYDIR-NOT-SET" )
		set( BOOST_LIBRARYDIR "BOOST_LIBRARYDIR-NOT-SET" CACHE PATH "Location of the Boost library binaries" FORCE )
		message( FATAL_ERROR "BOOST_LIBRARYDIR is not set. Before continuing, please set it to the correct binary path (depending on if you want to link with 32 or 64bit version)." )
	endif()
	
endif()

# Boost
set( Boost_USE_STATIC_LIBS        ON )
set( Boost_USE_MULTITHREADED      ON )
set( Boost_USE_STATIC_RUNTIME    OFF )
find_package( Boost REQUIRED COMPONENTS 
	date_time 
	filesystem 
	system
	chrono
	thread
	program_options
)
if( NOT Boost_FOUND )
	message( SEND_ERROR "AOS Designer requires Boost libraries, NOT FOUND!" )
endif()

include_directories( ${Boost_INCLUDE_DIR} )

# Important directories :
set( UTILCPP_ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR} )
set( UTILCPP_INCLUDE_DIR ${UTILCPP_ROOT_DIR}/include )

set( UTILCPP_HEADERS_DIR ${UTILCPP_INCLUDE_DIR}/utilcpp )
set( UTILCPP_SOURCE_DIR ${UTILCPP_ROOT_DIR}/sources )

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
	CACHE STRING "Directories to include in projects using UtilCPP" FORCE
)

include_directories( ${UTILCPP_INCLUDE_DIR} )


# Generate the library
add_library( utilcpp STATIC ${UTILCPP_ALL_FILES} )
