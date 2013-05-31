
option( UTILCPP_DEBUG_CMAKE_MACRO
	"Turn this ON display more messages from CMake scripts of project files." 
	OFF
)

option( UTILCPP_VLD_ENABLED
	"Enable Visual Leak Detector if MSVC and assume it is installed."
	ON
)


# Allow virtual directories for grouping projects in IDEs.
set_property( GLOBAL PROPERTY USE_FOLDERS ON )


