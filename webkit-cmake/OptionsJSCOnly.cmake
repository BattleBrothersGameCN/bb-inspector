find_package(Threads REQUIRED)

if(MSVC)
  include(OptionsMSVC)
else()
  set(CMAKE_C_VISIBILITY_PRESET hidden)
  set(CMAKE_CXX_VISIBILITY_PRESET hidden)
  set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
endif()

add_definitions(-DBUILDING_JSCONLY__)

set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_VERSION_MINOR 0)
set(PROJECT_VERSION_MICRO 0)
set(PROJECT_VERSION
    ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_MICRO})

webkit_option_begin()
webkit_option_define(
  ENABLE_STATIC_JSC "Whether to build JavaScriptCore as a static library."
  PUBLIC OFF)
webkit_option_define(USE_LIBBACKTRACE
                     "Whether to enable usage of libbacktrace." PUBLIC OFF)
webkit_option_default_port_value(ENABLE_REMOTE_INSPECTOR PRIVATE OFF)
if(WIN32)
  webkit_option_default_port_value(ENABLE_FTL_JIT PRIVATE ON)
  # FIXME: Port bmalloc to Windows.
  # https://bugs.webkit.org/show_bug.cgi?id=143310
  webkit_option_default_port_value(USE_SYSTEM_MALLOC PRIVATE ON)
endif()

webkit_option_end()

set(ALL_EVENT_LOOP_TYPES GLib Generic)

set(DEFAULT_EVENT_LOOP_TYPE "Generic")

set(EVENT_LOOP_TYPE
    ${DEFAULT_EVENT_LOOP_TYPE}
    CACHE
      STRING
      "Implementation of event loop to be used in JavaScriptCore (one of ${ALL_EVENT_LOOP_TYPES})"
)

set(ENABLE_WEBCORE OFF)
set(ENABLE_WEBKIT_LEGACY OFF)
set(ENABLE_WEBKIT OFF)
set(ENABLE_WEBINSPECTORUI OFF)
set(ENABLE_WEBGL OFF)

if(WIN32)
  set(ENABLE_API_TESTS OFF)
else()
  set(ENABLE_API_TESTS ON)
endif()

if(WTF_CPU_ARM OR WTF_CPU_MIPS)
  set_and_expose_to_build(USE_CAPSTONE TRUE)
endif()

if(NOT ENABLE_STATIC_JSC)
  set(JavaScriptCore_LIBRARY_TYPE SHARED)
  set(bmalloc_LIBRARY_TYPE OBJECT)
  set(WTF_LIBRARY_TYPE OBJECT)
endif()

if(WIN32)
  add_definitions(-DNOMINMAX)
  add_definitions(-D_WINDOWS -DWINVER=0x601 -D_WIN32_WINNT=0x601)
  add_definitions(-DUNICODE -D_UNICODE)

  if(NOT WEBKIT_LIBRARIES_DIR)
    if(DEFINED ENV{WEBKIT_LIBRARIES})
      set(WEBKIT_LIBRARIES_DIR "$ENV{WEBKIT_LIBRARIES}")
    else()
      set(WEBKIT_LIBRARIES_DIR "${CMAKE_SOURCE_DIR}/WebKitLibraries/win")
    endif()
  endif()

  set(CMAKE_PREFIX_PATH ${WEBKIT_LIBRARIES_DIR})

  if(WTF_CPU_X86_64)
    set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB32_PATHS OFF)
    set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS ON)
  endif()

  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE
      "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE
      "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE
      "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
endif()

string(TOLOWER ${EVENT_LOOP_TYPE} LOWERCASE_EVENT_LOOP_TYPE)
if(LOWERCASE_EVENT_LOOP_TYPE STREQUAL "glib")
  find_package(GLIB 2.36 REQUIRED COMPONENTS gio gio-unix gobject)
  set_and_expose_to_build(USE_GLIB 1)
  set_and_expose_to_build(USE_GLIB_EVENT_LOOP 1)
  set_and_expose_to_build(WTF_DEFAULT_EVENT_LOOP 0)
else()
  set_and_expose_to_build(USE_GENERIC_EVENT_LOOP 1)
  set_and_expose_to_build(WTF_DEFAULT_EVENT_LOOP 0)
endif()

find_package(ICU 61.2 REQUIRED COMPONENTS data i18n uc)
if(APPLE)
  add_definitions(-DU_DISABLE_RENAMING=1)
endif()

if(USE_LIBBACKTRACE)
  find_package(LibBacktrace)
  if(NOT LIBBACKTRACE_FOUND)
    message(FATAL_ERROR "libbacktrace is required for USE_LIBBACKTRACE")
  endif()
endif()
