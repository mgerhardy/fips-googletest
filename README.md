fips-googletest
===============

fipsified googletest

see https://github.com/mgerhardy/fips-googletest.git and https://github.com/floooh/fips

Add unit tests to your modules like this:
```
fips_begin_module(attrib)
	fips_files(
		Attributes.h Attributes.cpp
		Types.h
		Container.h Container.cpp
		ContainerProvider.h ContainerProvider.cpp
	)
	fips_deps(core commonlua)
fips_end_module()

gtest_begin(attrib)
	fips_dir(tests)
	fips_files(
		AttributesTest.cpp
	)
	fips_deps(attrib)
gtest_end()
```

Add this to your root CMakeLists.txt to get the above mentioned macros

```
get_filename_component(GOOGLETESTS_ROOT_DIR "../fips-googletest" ABSOLUTE)
include("${GOOGLETESTS_ROOT_DIR}/cmake/googleunittests.cmake")
```
