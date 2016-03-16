#
# project: fips-googletest
#

if (NOT FIPS_IMPORT)
	cmake_minimum_required(VERSION 2.8)
	# include the fips main cmake file
	get_filename_component(FIPS_ROOT_DIR "../fips" ABSOLUTE)
	include("${FIPS_ROOT_DIR}/cmake/fips.cmake")
	fips_setup()
	fips_project(fips-googletest)
endif()

fips_add_subdirectory(gtest)

if (NOT FIPS_IMPORT)
	fips_finish()
endif()
