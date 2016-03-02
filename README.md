fips-googletest
===============

fipsified googletest

see https://github.com/mgerhardy/fips-googletest.git and https://github.com/floooh/fips

Add unit tests to your modules like this:

In your `fips.yml`:
```cmake
imports:
     fips-googletest:
         git: https://github.com/mgerhardy/fips-googletest.git
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

You may set FIPS_GTEST_DISABLE_MAIN to 1 to disable the automatic generation of
a main() that will run the tests.
