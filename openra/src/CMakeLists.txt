add_subdirectory(maps)

add_custom_command(
	OUTPUT juch-openra.deb
	COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/make_deb"
	WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
	COMMENT "Creating OpenRA deb package"
	DEPENDS openra-maps
)

add_custom_target(
	openra-deb
	DEPENDS juch-openra.deb
)


