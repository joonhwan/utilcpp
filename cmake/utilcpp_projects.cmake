include( cmakeutils )

if( MSVC ) # VS2012 doesn't support correctly the tuples yet
	add_definitions( /D _VARIADIC_MAX=10 )
endif()


macro( UTILCPP_MAKE_TEST_FOR project_name )
	
	PARSE_ARGUMENTS( ARG "SOURCES" "" ${ARGV} )
	
	set( aos_test_name test-${project_name} )
	
	source_group( "\\" FILES ${ARG_SOURCES} )
	
	include_directories( ${GTEST_INCLUDE_DIR} )
	
	add_executable( ${aos_test_name} ${ARG_SOURCES} )
	target_link_libraries( ${aos_test_name} 
		gtest 
		gtest_main
		${project_name}
	)
	set_property( TARGET ${aos_test_name} PROPERTY FOLDER ${AOS_TEST_PROJECTS_GROUP_PATH} )
	
	add_test( NAME ${aos_test_name}
		WORKING_DIRECTORY ${EXECUTABLE_OUTPUT_PATH}
		COMMAND ${aos_test_name}
	)
	
endmacro()

