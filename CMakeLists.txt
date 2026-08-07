cmake_minimum_required(VERSION 3.16)

# Build and install one Abseil LTS as a shared Windows DLL (abseil_dll) + cmake package.
# Usage:
#   cmake -S . -B build -G Ninja -DABSL_PIN_ID=20240116.0 -DCMAKE_INSTALL_PREFIX=prefix/20240116.0
#   cmake --build build --config Release
#   cmake --install build --config Release

project(AbseilPin LANGUAGES CXX VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
  add_compile_options(/MP)
endif()

set(ABSL_PIN_ID "20260107.1" CACHE STRING "Pin id under pins/ (abseil-cpp git tag)")
set_property(CACHE ABSL_PIN_ID PROPERTY STRINGS "20260107.1" "20240116.0")

include(FetchContent)

set(ABSL_PROPAGATE_CXX_STD ON CACHE BOOL "" FORCE)
set(ABSL_MSVC_STATIC_RUNTIME OFF CACHE BOOL "" FORCE)
set(ABSL_BUILD_TESTING OFF CACHE BOOL "" FORCE)
set(ABSL_ENABLE_INSTALL ON CACHE BOOL "" FORCE)
set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)

FetchContent_Declare(
  abseil_pin
  GIT_REPOSITORY https://github.com/abseil/abseil-cpp.git
  GIT_TAG        ${ABSL_PIN_ID}
  GIT_SHALLOW    TRUE
)

FetchContent_MakeAvailable(abseil_pin)

message(STATUS "AbseilPin: ABSL_PIN_ID=${ABSL_PIN_ID}")
message(STATUS "AbseilPin: install prefix=${CMAKE_INSTALL_PREFIX}")
