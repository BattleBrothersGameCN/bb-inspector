# Use Release DLL CRT even for Debug build
set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreadedDLL)

if(MSVC)
  include(OptionsMSVC)
endif()

# Define minimum supported Windows version
# https://msdn.microsoft.com/en-us/library/6sehtctf.aspx
#
# Windows 10 1809 "Redstone 5" NTDDI_WIN10_RS5 (0x0A000006)
# https://learn.microsoft.com/en-us/windows/win32/winprog/using-the-windows-headers?redirectedfrom=MSDN#macros-for-conditional-declarations
#
# Supported versions of Windows client
# https://learn.microsoft.com/en-us/windows/release-health/supported-versions-windows-client
add_definitions(-D_WINDOWS -DNTDDI_VERSION=0x0A000006 -D_WIN32_WINNT=0x0A00)

add_definitions(-DNOMINMAX)
add_definitions(-DUNICODE -D_UNICODE)
add_definitions(-DNOCRYPT)

# If <winsock2.h> is not included before <windows.h> redefinition errors occur
# unless _WINSOCKAPI_ is defined before <windows.h> is included
add_definitions(-D_WINSOCKAPI_=)

set(ENABLE_WEBKIT ON)
set(ENABLE_WEBKIT_LEGACY OFF)

if(NOT WEBKIT_LIBRARIES_DIR)
  if(DEFINED ENV{WEBKIT_LIBRARIES})
    file(TO_CMAKE_PATH "$ENV{WEBKIT_LIBRARIES}" WEBKIT_LIBRARIES_DIR)
  else()
    file(TO_CMAKE_PATH "${CMAKE_SOURCE_DIR}/WebKitLibraries/win"
         WEBKIT_LIBRARIES_DIR)
  endif()
endif()

if(DEFINED ENV{WEBKIT_IGNORE_PATH})
  set(CMAKE_IGNORE_PATH $ENV{WEBKIT_IGNORE_PATH})
endif()

set(CMAKE_PREFIX_PATH ${WEBKIT_LIBRARIES_DIR})

set(WEBKIT_LIBRARIES_INCLUDE_DIR "${WEBKIT_LIBRARIES_DIR}/include")
include_directories(${WEBKIT_LIBRARIES_INCLUDE_DIR})

set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB32_PATHS OFF)
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS ON)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")

set(CMAKE_DISABLE_PRECOMPILE_HEADERS OFF)

find_package(Cairo 1.18.0 REQUIRED)
find_package(CURL 7.87.0 REQUIRED)
find_package(ICU 61.2 REQUIRED COMPONENTS data i18n uc)
find_package(JPEG 1.5.2 REQUIRED)
find_package(LibXml2 2.9.7 REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(PNG 1.6.34 REQUIRED)
find_package(SQLite3 3.23.1 REQUIRED)
find_package(ZLIB 1.2.11 REQUIRED)
find_package(LibPSL 0.20.2 REQUIRED)
find_package(WebP REQUIRED COMPONENTS demux)

webkit_option_begin()

# FIXME: Most of these options should not be public. TODO: Audit the features
# list
webkit_option_default_port_value(ENABLE_OVERFLOW_SCROLLING_TOUCH PUBLIC OFF)
webkit_option_default_port_value(ENABLE_API_TESTS PUBLIC ON)
webkit_option_default_port_value(ENABLE_ATTACHMENT_ELEMENT PUBLIC ON)
webkit_option_default_port_value(ENABLE_CURSOR_VISIBILITY PUBLIC ON)
webkit_option_default_port_value(ENABLE_DATALIST_ELEMENT PUBLIC OFF)
webkit_option_default_port_value(ENABLE_DEVICE_ORIENTATION PUBLIC OFF)
webkit_option_default_port_value(ENABLE_DRAG_SUPPORT PUBLIC ON)
webkit_option_default_port_value(ENABLE_FTL_JIT PUBLIC ON)
webkit_option_default_port_value(ENABLE_FULLSCREEN_API PUBLIC ON)
webkit_option_default_port_value(ENABLE_GAMEPAD PUBLIC OFF)
webkit_option_default_port_value(ENABLE_GEOLOCATION PUBLIC ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_COLOR PUBLIC OFF)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_DATE PUBLIC OFF)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_DATETIMELOCAL PUBLIC OFF)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_MONTH PUBLIC OFF)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_TIME PUBLIC OFF)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_WEEK PUBLIC OFF)
webkit_option_default_port_value(ENABLE_LAYOUT_TESTS PUBLIC ON)
webkit_option_default_port_value(ENABLE_MATHML PUBLIC ON)
webkit_option_default_port_value(ENABLE_MEDIA_SOURCE PUBLIC OFF)
webkit_option_default_port_value(ENABLE_MEDIA_STATISTICS PUBLIC ON)
webkit_option_default_port_value(ENABLE_MINIBROWSER PUBLIC ON)
webkit_option_default_port_value(ENABLE_MOUSE_CURSOR_SCALE PUBLIC ON)
webkit_option_default_port_value(ENABLE_NOTIFICATIONS PUBLIC OFF)
webkit_option_default_port_value(ENABLE_VIDEO PUBLIC ON)
webkit_option_default_port_value(ENABLE_WEBASSEMBLY PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEBASSEMBLY_BBQJIT PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEBASSEMBLY_OMGJIT PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_AUDIO PUBLIC OFF)
webkit_option_default_port_value(ENABLE_XSLT PUBLIC ON)

webkit_option_default_port_value(ENABLE_SMOOTH_SCROLLING PRIVATE OFF)
webkit_option_default_port_value(ENABLE_WEBGL PRIVATE OFF)
webkit_option_default_port_value(USE_AVIF PRIVATE OFF)
webkit_option_default_port_value(USE_WOFF2 PRIVATE ON)

# FIXME: Port bmalloc to Windows. https://bugs.webkit.org/show_bug.cgi?id=143310
webkit_option_default_port_value(USE_SYSTEM_MALLOC PRIVATE ON)

# Enabled features
webkit_option_default_port_value(ENABLE_DARK_MODE_CSS PRIVATE ON)
webkit_option_default_port_value(ENABLE_LEGACY_ENCRYPTED_MEDIA PUBLIC OFF)
webkit_option_default_port_value(ENABLE_MODERN_MEDIA_CONTROLS PRIVATE ON)
webkit_option_default_port_value(ENABLE_SHAREABLE_RESOURCE PRIVATE ON)
webkit_option_default_port_value(ENABLE_USER_MESSAGE_HANDLERS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEBGL PUBLIC ON)

# Experimental features
webkit_option_default_port_value(ENABLE_APPLICATION_MANIFEST PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_GPU_PROCESS PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_REMOTE_INSPECTOR PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_RESOURCE_USAGE PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_VARIATION_FONTS PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_WEBDRIVER PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})

# No support planned
webkit_option_default_port_value(ENABLE_FTPDIR PRIVATE OFF)

# WebDriver options
set_and_expose_to_build(ENABLE_WEBDRIVER_KEYBOARD_INTERACTIONS ON)
set_and_expose_to_build(ENABLE_WEBDRIVER_MOUSE_INTERACTIONS ON)

webkit_option_end()

set(USE_ANGLE_EGL ON)

set_and_expose_to_build(USE_ANGLE ON)
set_and_expose_to_build(USE_CAIRO ON)
set_and_expose_to_build(USE_CURL ON)
set_and_expose_to_build(USE_GRAPHICS_LAYER_TEXTURE_MAPPER ON)
set_and_expose_to_build(USE_GRAPHICS_LAYER_WC ON)
set_and_expose_to_build(USE_OPENSSL ON)
set_and_expose_to_build(USE_TEXTURE_MAPPER ON)
set_and_expose_to_build(USE_THEME_ADWAITA ON)
set_and_expose_to_build(USE_MEDIA_FOUNDATION ${ENABLE_VIDEO})
set_and_expose_to_build(USE_INSPECTOR_SOCKET_SERVER ${ENABLE_REMOTE_INSPECTOR})

set_and_expose_to_build(ENABLE_DEVELOPER_MODE ${DEVELOPER_MODE})

set_and_expose_to_build(HAVE_OS_DARK_MODE_SUPPORT 1)

# See if OpenSSL implementation is BoringSSL
cmake_push_check_state()
set(CMAKE_REQUIRED_INCLUDES "${OPENSSL_INCLUDE_DIR}")
set(CMAKE_REQUIRED_LIBRARIES "${OPENSSL_LIBRARIES}")
webkit_check_have_symbol(USE_BORINGSSL OPENSSL_IS_BORINGSSL openssl/ssl.h)
cmake_pop_check_state()

if(ENABLE_XSLT)
  find_package(LibXslt 1.1.32 REQUIRED)
endif()

if(USE_AVIF)
  find_package(AVIF 0.9.0)
  if(NOT AVIF_FOUND)
    message(FATAL_ERROR "libavif 0.9.0 is required for USE_AVIF.")
  endif()
endif()

if(USE_LCMS)
  find_package(LCMS2)
  if(NOT LCMS2_FOUND)
    message(FATAL_ERROR "libcms2 is required for USE_LCMS.")
  endif()
endif()

if(USE_JPEGXL)
  find_package(JPEGXL 0.7.0)
  if(NOT JPEGXL_FOUND)
    message(FATAL_ERROR "libjxl is required for USE_JPEGXL")
  endif()
endif()

if(USE_WOFF2)
  find_package(WOFF2 1.0.2 COMPONENTS dec)
  if(NOT WOFF2_FOUND)
    message(FATAL_ERROR "libwoff2dec is required for USE_WOFF2")
  endif()
  find_package(Brotli REQUIRED COMPONENTS dec)
endif()

set(bmalloc_LIBRARY_TYPE OBJECT)
set(WTF_LIBRARY_TYPE SHARED)
set(JavaScriptCore_LIBRARY_TYPE SHARED)
set(PAL_LIBRARY_TYPE OBJECT)
set(WebCore_LIBRARY_TYPE SHARED)
set(WebCoreTestSupport_LIBRARY_TYPE OBJECT)
