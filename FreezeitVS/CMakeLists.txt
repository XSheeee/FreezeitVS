if (NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
    message(WARNING "This project is only supported on Android. Are you forgetting to set the CMAKE_TOOLCHAIN_FILE?")
endif()


file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
add_executable(${PROJECT_NAME} ${sources})

# set compile flags.
#
# original: -std=c++20 -static -s -Ofast -Wall -Wextra -Wshadow -fno-exceptions -fno-rtti -DNDEBUG -fPIE
#
# -s is not a valid option for clang; it is removed.
#
# -static is removed because it is covered by default STL linking type (CMAKE_ANDROID_STL_TYPE = gnustl_static), see https://cmake.org/cmake/help/latest/variable/CMAKE_ANDROID_STL_TYPE.html,
# note: if any other library is used, it should be added to the target_link_libraries with STATIC flag!
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 20) # -std=c++20
target_compile_definitions(${PROJECT_NAME} PRIVATE NDEBUG) # -DNDEBUG
set_target_properties(${PROJECT_NAME} PROPERTIES POSITION_INDEPENDENT_CODE ON) # -fPIE
target_compile_options(${PROJECT_NAME} PRIVATE -Ofast -Wall -Wextra -Wshadow -fno-exceptions -fno-rtti) # the rest of the flags



