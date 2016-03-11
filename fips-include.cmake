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
    if (FIPS_UNITTESTS)
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

        set(main_path ${CMAKE_CURRENT_BINARY_DIR}/${CurTargetName}_main.cpp)
        # FIXME: allow the project to override this
        configure_file(${FIPS_GOOGLETESTDIR}/main.cpp.in ${main_path})

        # generate a command line app
        list(APPEND CurSources ${main_path})
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
