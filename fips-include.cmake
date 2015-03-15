#-------------------------------------------------------------------------------
#   fips_googleunittests.cmake
#
#   Macros for generating google unit tests.
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#   fips_begin_googleunittest(name)
#   Begin defining a unit test.
#
macro(begin_googleunittest name)
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
#   end_googleunittest()
#   End defining a unittest named 'name' from sources in 'dir'
#
macro(end_googleunittest)
    if (FIPS_UNITTESTS)
        if (FIPS_CMAKE_VERBOSE)
            message("Unit Test: name=" ${CurTargetName})
        endif()

        # add unittestpp lib dependency
        fips_deps(googletest)

        # FIXME: generate a scratch main-source-file
        set(main_path ${CMAKE_CURRENT_BINARY_DIR}/${CurTargetName}_main.cpp)
        file(WRITE ${main_path}
            "// machine generated, do not edit\n"
            "#include \"gtest/gtest.h\"\n"
            "\n"
            "class LocalEnv: public ::testing::Environment {\n"
            "public:\n"
                "virtual ~LocalEnv() {\n"
                "}\n"
                "virtual void SetUp() override {\n"
                "}\n"
                "virtual void TearDown() override {\n"
                "}\n"
            "};\n"
            "\n"
            "extern \"C\" int main (int argc, char **argv) {\n"
            "    ::testing::AddGlobalTestEnvironment(new LocalEnv);\n"
            "    ::testing::InitGoogleTest(&argc, argv);\n"
            "    try {\n"
            "        return RUN_ALL_TESTS();\n"
            "    } catch (const std::exception& e) {\n"
            "        std::cerr << e.what() << std::endl;\n"
            "        return EXIT_FAILURE;\n"
            "    }\n"
            "}\n"
        )

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
