find_program(ZIP_COMMAND zip)

function(add_openra_map MAP_NAME)
	file(GLOB MAP_FILES *)
	list(REMOVE_ITEM MAP_FILES "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt")

	add_custom_command(
		OUTPUT ${MAP_NAME}.oramap
		COMMAND ${ZIP_COMMAND} -r ${MAP_NAME}.oramap ${MAP_FILES}
		WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
		DEPENDS ${MAP_FILES}
		COMMENT "Packing OpenRA map ${MAP_NAME}"
	)

	add_custom_target(
		openra-map-${MAP_NAME}
		DEPENDS ${MAP_NAME}.oramap
	)

	add_dependencies(openra-maps openra-map-${MAP_NAME})
endfunction()

add_custom_target(openra-maps)

add_subdirectory(ra)
