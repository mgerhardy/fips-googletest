fips_begin_lib(googletest)
    fips_dir(src)
    fips_files(
        gtest.cc
        gtest-death-test.cc
        gtest-filepath.cc
        gtest-internal-inl.h
        gtest-port.cc
        gtest-printers.cc
        gtest-test-part.cc
        gtest-typed-test.cc
    )
fips_end_lib()

if (NOT FIPS_EXCEPTIONS)
    set(GOOGLETEST_NO_EXCEPTIONS "-fno-exceptions")
endif()

if (NOT FIPS_RTTI)
    add_definitions(-DGTEST_HAS_RTTI=0)
    set(GOOGLETEST_NO_RTTI "-fno-rtti")
else()
    add_definitions(-DGTEST_HAS_RTTI=1)
endif()

if (FIPS_CLANG)
    set_target_properties(googletest PROPERTIES COMPILE_FLAGS "${GOOGLETEST_NO_EXCEPTIONS} ${GOOGLETEST_NO_RTTI}")
elseif(FIPS_GCC)
    set_target_properties(googletest PROPERTIES COMPILE_FLAGS "${GOOGLETEST_NO_EXCEPTIONS} ${GOOGLETEST_NO_RTTI}")
elseif(FIPS_MSVC)
    if (NOT FIPS_EXCEPTIONS)
        string(REPLACE "/EHsc" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}) # -fno-exceptions
    endif()

    if (NOT TB_ENABLE_RTTI)
        string(REPLACE "/GR" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}) # -fno-rtti
    endif()
endif()
