fips-googletest
===============

fipsified googletest

see https://github.com/mgerhardy/fips-googletest.git and https://github.com/floooh/fips

Add unit tests to your modules like this:
```
begin_googleunittest(core)
    fips_dir(tests)
    fips_files(
        MyTest.cpp
    )
    fips_deps(core)
end_googleunittest()
```

Add this to your root CMakeLists.txt to get the above mentioned macros

```
get_filename_component(GOOGLETESTS_ROOT_DIR "../fips-googletest" ABSOLUTE)
include("${GOOGLETESTS_ROOT_DIR}/cmake/googleunittests.cmake")
```
