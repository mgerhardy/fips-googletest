# fips-googletest

see https://github.com/mgerhardy/fips-googletest and https://github.com/floooh/fips

## Add unit tests to your modules like this:

In your `fips.yml`:
```
imports:
    fips-googletest:
        git: https://github.com/mgerhardy/fips-googletest.git
```

### To create single binaries for each module:
```cmake
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

You may call gtest_begin with NO_TEMPLATE to disable the automatic generation of
a main() that will run the tests. You can also override the template c++ code that
is used to generate the main() by defining TEMPLATE path_to_template.cpp.in

### To create one global test binary:
Call
```cmake
gtest_suite_begin(tests)
fips_add_subdirectory(mySrcFolder)
gtest_suite_end(tests)
```
in your main CMakeLists.txt and make sure to wrap each of your modules with:
```cmake
gtest_suite_files(tests tests/SomeTest.cpp)
gtest_suite_deps(tests dep1 dep2 dep3)
```
