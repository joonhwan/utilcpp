
include( cmakeconfig )
include( cmakeutils )

if( MSVC ) # VS2012 doesn't support correctly the tuples yet
	add_definitions( /D _VARIADIC_MAX=10 )
endif()

macro( UTILCPP_USE_BOOST )
	
	if( WIN32 ) 
		# On Windows: check that the right boost binaries are set before continuing
		if( NOT DEFINED BOOST_LIBRARYDIR OR BOOST_LIBRARYDIR STREQUAL "BOOST_LIBRARYDIR-NOT-SET" )
			set( BOOST_LIBRARYDIR "BOOST_LIBRARYDIR-NOT-SET" CACHE PATH "Location of the Boost library binaries" FORCE )
			message( FATAL_ERROR "BOOST_LIBRARYDIR is not set. Before continuing, please set it to the correct binary path (depending on if you want to link with 32 or 64bit version)." )
		endif()
		
	endif()

	set( Boost_USE_STATIC_LIBS        ON )
	set( Boost_USE_MULTITHREADED      ON )
	set( Boost_USE_STATIC_RUNTIME    OFF )
	find_package( Boost 1.53.0 REQUIRED COMPONENTS ${ARGV} )
	
	if( NOT Boost_FOUND )
		message( SEND_ERROR "AOS Designer requires Boost libraries, NOT FOUND!" )
	endif()

	include_directories( ${Boost_INCLUDE_DIR} )

endmacro()

macro( UTILCPP_MAKE_EXE project_name )
	PARSE_ARGUMENTS( ARG "SOURCES;LINK_TARGETS;DEPENDENCIES;INCLUDE_DIRS;PROJECT_MACRO_PREFIX" "CONSOLE" ${ARGV} )
	# ARG_SOURCES		: list of source files
	# ARG_LINK_TARGETS	: list of projects to link to
	# ARG_DEPENDENCIES	: list of our projects that this project rely on 
	# ARG_INCLUDE_DIRS	: list of directories with headers used by this project
	# ARG_CONSOLE 		: if set, the executable can show a console.
	
	message( STATUS "-- Executable : " ${project_name} " --" )
	DebugLog(
		"\n    Target Name : ${project_name}"
		"\n    SOURCES : ${ARG_SOURCES}" 
		"\n    LINK TARGETS : ${ARG_LINK_TARGETS}" 
		"\n    DEPENDENCIES : ${ARG_DEPENDENCIES}" 
		"\n    INCLUDE DIRECTORIES : ${ARG_INCLUDE_DIRS}" 
	)
	
		
	list( LENGTH ARG_LINK_TARGETS link_targets_count )
	list( LENGTH ARG_DEPENDENCIES dependencies_count )
	list( LENGTH ARG_INCLUDE_DIRS includ_dirs_count )
	
	# In case we want to edit the project alone.
	project( ${project_name} )
		
	if( includ_dirs_count GREATER 0 )
		include_directories( ${ARG_INCLUDE_DIRS} )
	else()
		DebugLog( "No additional include directories!" )
	endif()
	
	# Make sure we can edit the CMakeLists.txt file from the editor.
	set( ARG_SOURCES ${ARG_SOURCES} CMakeLists.txt )
	source_group( "\\_cmake" FILES CMakeLists.txt )
	# TODO: if not all editors works with that, just make sure it is not inserted.
	
	# Special instruction to not display the console and automatically link with the 
	# os libraries that allow GUI display.
	if( NOT ARG_CONSOLE )
		if( WIN32 )
			set( GUI_TYPE WIN32 )
		else()
			set( GUI_TYPE MACOSX_BUNDLE )
		endif()
	else()
		set( GUI_TYPE )
	endif()
	
	# UTILCPP_DETECT_MEMORY_LEAK()
	
	source_group( "\\" FILES ${ARG_SOURCES} )
	
	# Now we are ready for generating the project:
	add_executable( ${project_name} ${GUI_TYPE}
		# provided source files
		${ARG_SOURCES} 
	)
	
	# Link with boost libraries if they are declared.
	if( Boost_LIBRARIES )
		set( ARG_LINK_TARGETS ${ARG_LINK_TARGETS} ${Boost_LIBRARIES} )
	endif()
		
	if( link_targets_count EQUAL 0 )
		DebugLog( "No additional external libraries linked to this one!" )
	else()
		DebugLog( "Adding " ${ARG_LINK_TARGETS} " as link targets." )
		target_link_libraries( ${project_name} ${ARG_LINK_TARGETS} )
	endif()
	
	if( dependencies_count EQUAL 0 )
		DebugLog( "No additional dependencies to this one!" )
	else()
		DebugLog( "Adding " ${ARG_DEPENDENCIES} " as dependencies." )
		add_dependencies( ${project_name} ${ARG_DEPENDENCIES} )
	endif()
		
	message( STATUS "-- Executable : " ${project_name} " - DONE --\n" )
	
endmacro()

macro( UTILCPP_MAKE_TEST_FOR project_name )
	PARSE_ARGUMENTS( ARG "SOURCES;LINK_TARGETS;DEPENDENCIES;INCLUDE_DIRS;PROJECT_MACRO_PREFIX" "" ${ARGV} )
	
	set( test_name test-${project_name} )
	
	source_group( "\\" FILES ${ARG_SOURCES} )
	
	UTILCPP_MAKE_EXE( ${test_name}
		SOURCES
			${ARG_SOURCES}
		INCLUDE_DIRS 
			${ARG_INCLUDE_DIRS}
			${GTEST_INCLUDE_DIR}
		LINK_TARGETS 
			${ARG_LINK_TARGETS}
			gtest
			gtest_main
			${project_name}
		DEPENDENCIES
			${ARG_DEPENDENCIES}
		PROJECT_MACRO_PREFIX
			${PROJECT_MACRO_PREFIX}
	)
	
	add_test( NAME ${test_name}
		WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
		COMMAND ${test_name}
	)
	
	ProjectGroup( ${AOS_TEST_PROJECTS_GROUP_PATH} PROJECTS ${test_name} )
	
endmacro()

