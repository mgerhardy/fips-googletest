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

    if (FIPS_UNITTESTS)
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
    else()
        set(FipsAddFilesEnabled)
    endif()
endmacro()

#-------------------------------------------------------------------------------
#   gtest_end()
#   End defining a unittest named 'name' from sources in 'dir'
#
macro(gtest_end)
    if (FIPS_UNITTESTS)
        if (FIPS_CMAKE_VERBOSE)
            message("Unit Test: name=" ${CurTargetName})
        endif()

        # add unittestpp lib dependency
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
    endif()
    set(FipsAddFilesEnabled 1)
endmacro()
