#-------------------------------------------------------------------------------
#   fips_googleunittests.cmake
#
#   Macros for generating google unit tests.
#-------------------------------------------------------------------------------

set(FIPS_GOOGLETESTDIR ${CMAKE_CURRENT_LIST_DIR})

#-------------------------------------------------------------------------------
#   gtest_begin(name)
#   Begin defining a unit test.
#
macro(gtest_begin name)
    set(options NO_TEMPLATE)
    set(oneValueArgs TEMPLATE)
    set(multiValueArgs)
    cmake_parse_arguments(_gt "${options}" "${oneValueArgs}" "" ${ARGN})

    if (_gt_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "gtest_begin(): called with invalid args '${_gt_UNPARSED_ARGUMENTS}'")
    endif()

    set(FipsAddFilesEnabled 1)
    fips_reset(${CurTargetName}Test)
    if (FIPS_OSX)
        set(CurAppType "windowed")
    else()
        set(CurAppType "cmdline")
    endif()
endmacro()

#-------------------------------------------------------------------------------
#   gtest_end()
#   End defining a unittest named 'name' from sources in 'dir'
#
macro(gtest_end)
    if (FIPS_CMAKE_VERBOSE)
        message("Unit Test: name=" ${CurTargetName})
    endif()

    # add googletest lib dependency
    fips_deps(googletest)

    if (NOT _gt_NO_TEMPLATE)
        set(main_path ${CMAKE_CURRENT_BINARY_DIR}/${CurTargetName}_main.cpp)
        if (_gt_TEMPLATE)
            configure_file(${_gt_TEMPLATE} ${main_path})
        else()
            configure_file(${FIPS_GOOGLETESTDIR}/main.cpp.in ${main_path})
        endif()
        list(APPEND CurSources ${main_path})
    endif()

    # generate a command line app
    fips_end_app()
    set_target_properties(${CurTargetName} PROPERTIES FOLDER "tests")

    # add as cmake unit test
    add_test(NAME ${CurTargetName} COMMAND ${CurTargetName})

    # if configured, start the app as post-build-step
    if (FIPS_UNITTESTS_RUN_AFTER_BUILD)
        add_custom_command (TARGET ${CurTargetName} POST_BUILD COMMAND ${CurTargetName})
    endif()
    set(FipsAddFilesEnabled 1)
endmacro()

#-------------------------------------------------------------------------------
#   gtest_suite_begin(name)
#   Begin defining a unit test suite.
#
macro(gtest_suite_begin name)
    set(options NO_TEMPLATE)
    set(oneValueArgs TEMPLATE)
    set(multiValueArgs)
    cmake_parse_arguments(${name} "${options}" "${oneValueArgs}" "" ${ARGN})

    if (${name}_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "gtest_suite_begin(): called with invalid args '${${name}_UNPARSED_ARGUMENTS}'")
    endif()
    if (FIPS_OSX)
        set(${name}_CurAppType "windowed")
    else()
        set(${name}_CurAppType "cmdline")
    endif()
    set_property(GLOBAL PROPERTY ${name}_Sources "")
    set_property(GLOBAL PROPERTY ${name}_Deps "")
endmacro()

#-------------------------------------------------------------------------------
#   gtest_suite_files(files)
#   Adds files to a test suite
#
macro(gtest_suite_files name)
    set(ARG_LIST ${ARGV})
    list(REMOVE_AT ARG_LIST 0)
    get_property(list GLOBAL PROPERTY ${name}_Sources)
    foreach(entry ${ARG_LIST})
        list(APPEND list ${CMAKE_CURRENT_SOURCE_DIR}/${entry})
    endforeach()
    set_property(GLOBAL PROPERTY ${name}_Sources ${list})
endmacro()

#-------------------------------------------------------------------------------
#   gtest_suite_deps(files)
#   Adds files to a test suite
#
macro(gtest_suite_deps name)
    set(ARG_LIST ${ARGV})
    list(REMOVE_AT ARG_LIST 0)
    get_property(list GLOBAL PROPERTY ${name}_Deps)
    list(APPEND list ${ARG_LIST})
    set_property(GLOBAL PROPERTY ${name}_Deps ${list})
endmacro()

#-------------------------------------------------------------------------------
#   gtest_suite_end()
#   End defining a unittest suite
#
macro(gtest_suite_end name)
    if (FIPS_CMAKE_VERBOSE)
        message("Unit Test: name=" ${name})
    endif()

    fips_begin_app(${name} ${${name}_CurAppType})
    get_property(srcs GLOBAL PROPERTY ${name}_Sources)
    get_property(deps GLOBAL PROPERTY ${name}_Deps)

    if (NOT ${name}_NO_TEMPLATE)
        set(main_path ${CMAKE_CURRENT_BINARY_DIR}/${name}_main.cpp)
        if (${name}_TEMPLATE)
            configure_file(${${name}_TEMPLATE} ${main_path})
        else()
            configure_file(${FIPS_GOOGLETESTDIR}/main.cpp.in ${main_path})
        endif()
        list(APPEND srcs ${main_path})
    endif()

    fips_files(${srcs})
    # add googletest lib dependency
    fips_deps(googletest ${deps})
    # generate a command line app
    fips_end_app()
    set_target_properties(${name} PROPERTIES FOLDER "tests")
    # silence some warnings
    if(FIPS_LINUX)
        set_target_properties(${name} PROPERTIES COMPILE_FLAGS "-Wno-sign-compare")
    endif()

    # add as cmake unit test
    add_test(NAME ${name} COMMAND ${name})

    # if configured, start the app as post-build-step
    if (FIPS_UNITTESTS_RUN_AFTER_BUILD)
        add_custom_command (TARGET ${name} POST_BUILD COMMAND ${name})
    endif()
    set(FipsAddFilesEnabled 1)
endmacro()
