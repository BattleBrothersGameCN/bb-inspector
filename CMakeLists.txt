cmake_minimum_required(VERSION 3.10)

set(webkit_headers_dir ${CMAKE_CURRENT_LIST_DIR}/webkit-includes)
set(webkit_libs_dir ${CMAKE_CURRENT_LIST_DIR}/webkit-libs)
set(external_headers_dir ${CMAKE_CURRENT_LIST_DIR}/WebKitLibraries/win/include)
set(external_libs_dir ${CMAKE_CURRENT_LIST_DIR}/WebKitLibraries/win/lib64)

project(battle-brothers-inspector)
# -----------------------------------------------------------------------------
# Common configuration
# ------------------------------------------------------------------------------
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/webkit-cmake")
include(WebKitCommon)

add_subdirectory(src/BattleBrothersInspector)
