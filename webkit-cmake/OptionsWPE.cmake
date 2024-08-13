include(GNUInstallDirs)
include(VersioningUtils)

set_project_version(2 45 3)

set(USER_AGENT_BRANDING
    ""
    CACHE STRING "Branding to add to user agent string")

find_package(HarfBuzz 1.4.2 REQUIRED COMPONENTS ICU)
find_package(ICU 61.2 REQUIRED COMPONENTS data i18n uc)
find_package(JPEG REQUIRED)
find_package(Epoxy 1.5.4 REQUIRED)
find_package(LibGcrypt 1.7.0 REQUIRED)
find_package(Libtasn1 REQUIRED)
find_package(Libxkbcommon 0.4.0 REQUIRED)
find_package(LibXml2 2.8.0 REQUIRED)
find_package(PNG REQUIRED)
find_package(SQLite3 REQUIRED)
find_package(Threads REQUIRED)
find_package(Unifdef REQUIRED)
find_package(WebP REQUIRED COMPONENTS demux)
find_package(WPE REQUIRED)
find_package(ZLIB REQUIRED)

webkit_option_begin()

set_and_expose_to_build(ENABLE_DEVELOPER_MODE ${DEVELOPER_MODE})

include(GStreamerDefinitions)
include(FindGLibCompileResources)

# Public options shared with other WebKit ports. Do not add any options here
# without approval from a WPE reviewer. There must be strong reason to support
# changing the value of the option.
webkit_option_default_port_value(ENABLE_ENCRYPTED_MEDIA PUBLIC
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_PDFJS PUBLIC ON)
webkit_option_default_port_value(ENABLE_WEBDRIVER PUBLIC ON)
webkit_option_default_port_value(ENABLE_XSLT PUBLIC ON)

webkit_option_default_port_value(USE_AVIF PUBLIC ON)
webkit_option_default_port_value(USE_LCMS PUBLIC ON)
webkit_option_default_port_value(USE_JPEGXL PUBLIC ON)
webkit_option_default_port_value(USE_WOFF2 PUBLIC ON)

# Private options shared with other WebKit ports. Add options here only if we
# need a value different from the default defined in WebKitFeatures.cmake.
# Changing these options is completely unsupported.
webkit_option_default_port_value(ENABLE_ASYNC_SCROLLING PRIVATE ON)
webkit_option_default_port_value(ENABLE_AUTOCAPITALIZE PRIVATE ON)
webkit_option_default_port_value(ENABLE_CONTENT_EXTENSIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_CURSOR_VISIBILITY PRIVATE ON)
webkit_option_default_port_value(ENABLE_DARK_MODE_CSS PRIVATE ON)
webkit_option_default_port_value(ENABLE_FTPDIR PRIVATE OFF)
webkit_option_default_port_value(ENABLE_GPU_PROCESS PRIVATE OFF)
webkit_option_default_port_value(ENABLE_MEDIA_CONTROLS_CONTEXT_MENUS PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_RECORDER PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_SESSION PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_SESSION_PLAYLIST PRIVATE OFF)
webkit_option_default_port_value(ENABLE_MEDIA_STREAM PRIVATE ON)
webkit_option_default_port_value(ENABLE_MOUSE_CURSOR_SCALE PRIVATE ON)
webkit_option_default_port_value(ENABLE_MHTML PRIVATE ON)
webkit_option_default_port_value(ENABLE_MODERN_MEDIA_CONTROLS PRIVATE ON)
webkit_option_default_port_value(ENABLE_NOTIFICATIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_NETWORK_CACHE_STALE_WHILE_REVALIDATE
                                 PRIVATE ON)
webkit_option_default_port_value(ENABLE_OFFSCREEN_CANVAS PRIVATE ON)
webkit_option_default_port_value(ENABLE_OFFSCREEN_CANVAS_IN_WORKERS PRIVATE ON)
webkit_option_default_port_value(ENABLE_PERIODIC_MEMORY_MONITOR PRIVATE ON)
webkit_option_default_port_value(ENABLE_SHAREABLE_RESOURCE PRIVATE ON)
webkit_option_default_port_value(ENABLE_SPEECH_SYNTHESIS PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_THUNDER PRIVATE
                                 ${ENABLE_DEVELOPER_MODE})
webkit_option_default_port_value(ENABLE_TOUCH_EVENTS PRIVATE ON)
webkit_option_default_port_value(ENABLE_VARIATION_FONTS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_CODECS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_RTC PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_WEBXR PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})

webkit_option_default_port_value(USE_SYSPROF_CAPTURE PRIVATE ON)

if(CMAKE_CXX_BYTE_ORDER STREQUAL "LITTLE_ENDIAN")
  webkit_option_default_port_value(USE_SKIA PRIVATE ON)
else()
  webkit_option_default_port_value(USE_SKIA PRIVATE OFF)
endif()

if(WPE_VERSION VERSION_GREATER_EQUAL 1.13.90)
  webkit_option_default_port_value(ENABLE_GAMEPAD PUBLIC ON)
endif()

# Public options specific to the WPE port. Do not add any options here unless
# there is a strong reason we should support changing the value of the option,
# and the option is not relevant to other WebKit ports.
webkit_option_define(ENABLE_DOCUMENTATION "Whether to generate documentation."
                     PUBLIC ON)
webkit_option_define(ENABLE_INTROSPECTION
                     "Whether to enable GObject introspection." PUBLIC ON)
webkit_option_define(ENABLE_JOURNALD_LOG "Whether to enable journald logging"
                     PUBLIC ON)
webkit_option_define(ENABLE_WPE_PLATFORM_DRM
                     "Whether to enable support for DRM platform" PUBLIC ON)
webkit_option_define(
  ENABLE_WPE_PLATFORM_HEADLESS
  "Whether to enable support for headless platform" PUBLIC ON)
webkit_option_define(ENABLE_WPE_PLATFORM_WAYLAND
                     "Whether to enable support for Wayland platform" PUBLIC ON)
webkit_option_define(
  ENABLE_WPE_QT_API "Whether to enable support for the Qt/QML plugin" PUBLIC
  ${ENABLE_DEVELOPER_MODE})
webkit_option_define(ENABLE_WPE_1_1_API
                     "Whether to build WPE 1.1 instead of WPE 2.0" PUBLIC OFF)
webkit_option_define(USE_ATK "Whether to enable usage of ATK." PUBLIC ON)
webkit_option_define(USE_GBM "Whether to enable usage of GBM." PUBLIC ON)
webkit_option_define(USE_LIBBACKTRACE
                     "Whether to enable usage of libbacktrace." PUBLIC ON)
webkit_option_define(USE_LIBDRM "Whether to enable usage of libdrm." PUBLIC ON)
webkit_option_define(USE_QT6 "Whether to use Qt6 instead of Qt5" PUBLIC OFF)

# Private options specific to the WPE port.
webkit_option_define(USE_EXTERNAL_HOLEPUNCH
                     "Whether to enable external holepunch" PRIVATE OFF)
webkit_option_define(
  USE_ANGLE_GBM "Whether to enable ANGLE implementation with GBM" PRIVATE OFF)

webkit_option_depend(ENABLE_DOCUMENTATION ENABLE_INTROSPECTION)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
  webkit_option_default_port_value(ENABLE_BUBBLEWRAP_SANDBOX PUBLIC ON)
  webkit_option_default_port_value(ENABLE_MEMORY_SAMPLER PRIVATE ON)
  webkit_option_default_port_value(ENABLE_RESOURCE_USAGE PRIVATE ON)
else()
  webkit_option_default_port_value(ENABLE_BUBBLEWRAP_SANDBOX PUBLIC OFF)
  webkit_option_default_port_value(ENABLE_MEMORY_SAMPLER PRIVATE OFF)
  webkit_option_default_port_value(ENABLE_RESOURCE_USAGE PRIVATE OFF)
endif()

if(ENABLE_DEVELOPER_MODE)
  webkit_option_default_port_value(ENABLE_API_TESTS PRIVATE ON)
  webkit_option_default_port_value(ENABLE_LAYOUT_TESTS PRIVATE ON)
  webkit_option_default_port_value(ENABLE_MINIBROWSER PUBLIC ON)
  webkit_option_default_port_value(ENABLE_COG PRIVATE ON)
endif()

webkit_option_depend(ENABLE_WPE_PLATFORM_DRM USE_GBM)
webkit_option_depend(USE_GBM USE_LIBDRM)
webkit_option_depend(USE_EXTERNAL_HOLEPUNCH ENABLE_VIDEO)

include(GStreamerDependencies)

webkit_option_end()

find_package(GI)
if(ENABLE_INTROSPECTION AND NOT GI_FOUND)
  message(
    FATAL_ERROR "GObjectIntrospection is needed for ENABLE_INTROSPECTION.")
endif()

find_package(GIDocgen)
if(ENABLE_DOCUMENTATION AND NOT GIDocgen_FOUND)
  message(FATAL_ERROR "ENABLE_INTROSPECTION is needed for gi-docgen.")
endif()

if(ENABLE_WPE_1_1_API)
  set(SOUP_MINIMUM_VERSION 3.0.0)
  set(SOUP_API_VERSION 3.0)
  set(WPE_API_VERSION 1.1)
  set(WPE_API_MAJOR_VERSION 1)
  set(ENABLE_SERVER_PRECONNECT ON)
  set_and_expose_to_build(ENABLE_2022_GLIB_API OFF)
else()
  set(SOUP_MINIMUM_VERSION 3.0.0)
  set(SOUP_API_VERSION 3.0)
  set(WPE_API_VERSION 2.0)
  set(WPE_API_MAJOR_VERSION 2)
  set(ENABLE_SERVER_PRECONNECT ON)
  set_and_expose_to_build(ENABLE_2022_GLIB_API ON)
endif()
find_package(LibSoup ${SOUP_MINIMUM_VERSION} REQUIRED)

if(NOT LibSoup_FOUND)
  message(FATAL_ERROR "libsoup 3 is required.")
endif()

expose_string_variable_to_build(WPE_API_VERSION)

if(ENABLE_2022_GLIB_API)
  set(GLIB_MINIMUM_VERSION 2.70.0)
else()
  set(GLIB_MINIMUM_VERSION 2.56.4)
endif()
find_package(GLIB ${GLIB_MINIMUM_VERSION} REQUIRED
             COMPONENTS gio gio-unix gobject gthread gmodule)

set_and_expose_to_build(ENABLE_WPE_PLATFORM ${ENABLE_2022_GLIB_API})

if(WPE_API_VERSION VERSION_EQUAL "1.1")
  calculate_library_versions_from_libtool_triple(WEBKIT 8 2 8)
else()
  calculate_library_versions_from_libtool_triple(WEBKIT 5 2 4)
endif()

if(ENABLE_WPE_PLATFORM)
  calculate_library_versions_from_libtool_triple(WPE_PLATFORM 0 0 0)
endif()

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)
set(bmalloc_LIBRARY_TYPE OBJECT)
set(WTF_LIBRARY_TYPE OBJECT)
set(JavaScriptCore_LIBRARY_TYPE OBJECT)
set(WebCore_LIBRARY_TYPE OBJECT)

# These are shared variables, but we special case their definition so that we
# can use the CMAKE_INSTALL_* variables that are populated by the GNUInstallDirs
# macro.
set(LIB_INSTALL_DIR
    "${CMAKE_INSTALL_FULL_LIBDIR}"
    CACHE PATH "Absolute path to library installation directory")
set(EXEC_INSTALL_DIR
    "${CMAKE_INSTALL_FULL_BINDIR}"
    CACHE PATH "Absolute path to executable installation directory")
set(LIBEXEC_INSTALL_DIR
    "${CMAKE_INSTALL_FULL_LIBEXECDIR}/wpe-webkit-${WPE_API_VERSION}"
    CACHE PATH "Absolute path to install executables executed by the library")

if(USE_ATK)
  find_package(ATK 2.16.0)
  if(NOT ATK_FOUND)
    message(FATAL_ERROR "atk is required for USE_ATK")
  endif()
  find_package(ATKBridge)
  if(NOT ATKBridge_FOUND)
    message(FATAL_ERROR "atk-bridge is required for USE_ATK")
  endif()
endif()

if(ENABLE_GAMEPAD AND (NOT (WPE_VERSION VERSION_GREATER_EQUAL 1.13.90)))
  message(FATAL_ERROR "libwpe>=1.13.90 is required for ENABLE_GAMEPAD")
endif()

if(ENABLE_SPEECH_SYNTHESIS)
  find_package(Flite 2.2)
  if(NOT Flite_FOUND)
    message(FATAL_ERROR "Flite is needed for ENABLE_SPEECH_SYNTHESIS")
  endif()
endif()

if(USE_SKIA)
  set_and_expose_to_build(USE_CAIRO FALSE)
else()
  find_package(Cairo 1.16.0 REQUIRED)
  find_package(Fontconfig 2.13.0 REQUIRED)
  find_package(Freetype 2.9.0 REQUIRED)
  set_and_expose_to_build(USE_CAIRO TRUE)
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
endif()

if(ENABLE_WEBDRIVER)
  set_and_expose_to_build(ENABLE_WEBDRIVER_KEYBOARD_INTERACTIONS ON)
  set_and_expose_to_build(ENABLE_WEBDRIVER_MOUSE_INTERACTIONS ON)
  if(ENABLE_WPE_PLATFORM)
    set_and_expose_to_build(ENABLE_WEBDRIVER_TOUCH_INTERACTIONS ON)
  else()
    set_and_expose_to_build(ENABLE_WEBDRIVER_TOUCH_INTERACTIONS OFF)
  endif()
  set_and_expose_to_build(ENABLE_WEBDRIVER_WHEEL_INTERACTIONS ON)
endif()

if(ENABLE_XSLT)
  find_package(LibXslt 1.1.7 REQUIRED)
endif()

if(ENABLE_WPE_PLATFORM)
  if(ENABLE_WPE_PLATFORM_DRM)
    find_package(LibInput 1.19.0 REQUIRED)
    find_package(Udev REQUIRED)
    set_and_expose_to_build(ENABLE_WPE_PLATFORM_DRM ON)
    set(WPE_PLATFORM_DRM ON)
  endif()

  if(ENABLE_WPE_PLATFORM_HEADLESS)
    set_and_expose_to_build(ENABLE_WPE_PLATFORM_HEADLESS ON)
    set(WPE_PLATFORM_HEADLESS ON)
  endif()

  if(ENABLE_WPE_PLATFORM_WAYLAND)
    find_package(Wayland 1.20 REQUIRED)
    find_package(WaylandProtocols 1.24 REQUIRED)
    set_and_expose_to_build(ENABLE_WPE_PLATFORM_WAYLAND ON)
    set(WPE_PLATFORM_WAYLAND ON)
  endif()
endif()

if(ENABLE_WPE_QT_API)
  if(USE_QT6)
    set(WPE_MAJOR_QT_VERSION 6)
    if(NOT TARGET WrapOpenGL::WrapOpenGL)
      add_library(WrapOpenGL::WrapOpenGL INTERFACE IMPORTED)
      target_link_libraries(WrapOpenGL::WrapOpenGL INTERFACE Epoxy::Epoxy)
    endif()
  else()
    set(WPE_MAJOR_QT_VERSION 5)
    find_package(WPEBackendFDO 1.5.0 REQUIRED)
  endif()
  find_package(Qt${WPE_MAJOR_QT_VERSION} REQUIRED COMPONENTS Core Quick Gui)
  find_package(Qt${WPE_MAJOR_QT_VERSION}Test REQUIRED)
endif()

if(ENABLE_WEBXR)
  if(NOT ENABLE_GAMEPAD)
    message(FATAL_ERROR "Gamepad is required to be enabled for WebXR support.")
  endif()
  find_package(OpenXR 1.0.9)
  if(NOT OPENXR_FOUND)
    message(FATAL_ERROR "OpenXR is required to enable WebXR support.")
  endif()
  set_and_expose_to_build(USE_OPENXR ${OpenXR_FOUND})
  set_and_expose_to_build(XR_USE_PLATFORM_EGL TRUE)
  set_and_expose_to_build(XR_USE_GRAPHICS_API_OPENGL TRUE)
endif()

if(USE_AVIF)
  find_package(AVIF 0.9.0)
  if(NOT AVIF_FOUND)
    message(FATAL_ERROR "libavif 0.9.0 is required for USE_AVIF.")
  endif()
endif()

if(ENABLE_JOURNALD_LOG)
  find_package(Journald)
  if(NOT Journald_FOUND)
    message(
      FATAL_ERROR "libsystemd or libelogind are needed for ENABLE_JOURNALD_LOG")
  endif()
endif()

if(ENABLE_ENCRYPTED_MEDIA AND ENABLE_THUNDER)
  find_package(Thunder REQUIRED)
endif()

if(USE_LCMS)
  find_package(LCMS2)
  if(NOT LCMS2_FOUND)
    message(FATAL_ERROR "libcms2 is required for USE_LCMS.")
  endif()
endif()

if(ENABLE_BREAKPAD)
  find_package(Breakpad REQUIRED)
  if(NOT Breakpad_FOUND)
    message(FATAL_ERROR "breakpad enabled but not found.")
  endif()
  if(BREAKPAD_MINIDUMP_DIR)
    add_definitions(-DBREAKPAD_MINIDUMP_DIR="${BREAKPAD_MINIDUMP_DIR}")
  else()
    message(STATUS "BREAKPAD_MINIDUMP_DIR is not set")
  endif()
endif()

add_definitions(-DBUILDING_WPE__=1)
add_definitions(-DGETTEXT_PACKAGE="WPE")
add_definitions(-DJSC_GLIB_API_ENABLED)

if(USER_AGENT_BRANDING)
  add_definitions(-DUSER_AGENT_BRANDING=${USER_AGENT_BRANDING})
endif()

if(NOT EXISTS "${TOOLS_DIR}/glib/apply-build-revision-to-files.py")
  set(BUILD_REVISION "tarball")
endif()

set_and_expose_to_build(USE_ATSPI TRUE)
set_and_expose_to_build(USE_GCRYPT TRUE)
set_and_expose_to_build(USE_LIBEPOXY TRUE)
set_and_expose_to_build(USE_LIBWPE TRUE)
set_and_expose_to_build(USE_WPE_RENDERER TRUE)
set_and_expose_to_build(USE_XDGMIME TRUE)

if(WTF_CPU_ARM OR WTF_CPU_MIPS)
  set_and_expose_to_build(USE_CAPSTONE ${ENABLE_DEVELOPER_MODE})
endif()

set_and_expose_to_build(USE_TEXTURE_MAPPER TRUE)
set_and_expose_to_build(USE_COORDINATED_GRAPHICS TRUE)
set_and_expose_to_build(USE_NICOSIA TRUE)
set_and_expose_to_build(USE_ANGLE ${ENABLE_WEBGL})
set_and_expose_to_build(USE_THEME_ADWAITA TRUE)
set_and_expose_to_build(HAVE_OS_DARK_MODE_SUPPORT 1)

if(USE_LIBDRM)
  find_package(LibDRM)
  if(NOT LibDRM_FOUND)
    message(FATAL_ERROR "libdrm is required for USE_LIBDRM")
  endif()

  set(CMAKE_REQUIRED_LIBRARIES LibDRM::LibDRM)
  webkit_check_have_function(HAVE_DRM_GET_FORMAT_MODIFIER_VENDOR
                             drmGetFormatModifierVendor xf86drm.h)
  webkit_check_have_function(HAVE_DRM_GET_FORMAT_MODIFIER_NAME
                             drmGetFormatModifierName xf86drm.h)
  unset(CMAKE_REQUIRED_LIBRARIES)
endif()

if(USE_GBM)
  find_package(GBM)
  if(NOT GBM_FOUND)
    message(FATAL_ERROR "GBM is required for USE_GBM")
  endif()

  set(CMAKE_REQUIRED_LIBRARIES GBM::GBM)
  webkit_check_have_function(HAVE_GBM_BO_GET_FD_FOR_PLANE
                             gbm_bo_get_fd_for_plane gbm.h)
  webkit_check_have_function(HAVE_GBM_BO_CREATE_WITH_MODIFIERS2
                             gbm_bo_create_with_modifiers2 gbm.h)
  unset(CMAKE_REQUIRED_LIBRARIES)
  set_and_expose_to_build(USE_TEXTURE_MAPPER_DMABUF TRUE)
endif()

if(USE_LIBBACKTRACE)
  find_package(LibBacktrace)
  if(NOT LIBBACKTRACE_FOUND)
    message(FATAL_ERROR "libbacktrace is required for USE_LIBBACKTRACE")
  endif()
endif()

# GUri is available in GLib since version 2.66, but we only want to use it if
# version is >= 2.67.1.
if(PC_GLIB_VERSION VERSION_GREATER "2.67.1" OR PC_GLIB_VERSION STREQUAL
                                               "2.67.1")
  set_and_expose_to_build(HAVE_GURI 1)
endif()

# Using DERIVED_SOURCES_DIR is deprecated
set(DERIVED_SOURCES_DIR "${CMAKE_BINARY_DIR}/DerivedSources")
set(DERIVED_SOURCES_WEBKIT_DIR ${DERIVED_SOURCES_DIR}/WebKit)
set(DERIVED_SOURCES_WPE_API_DIR ${DERIVED_SOURCES_WEBKIT_DIR}/wpe)
set(DERIVED_SOURCES_WPETOOLINGBACKENDS_DIR
    "${CMAKE_BINARY_DIR}/DerivedSources/WPEToolingBackends")

# Using FORWARDING_HEADERS_DIR is deprecated
set(FORWARDING_HEADERS_DIR ${DERIVED_SOURCES_DIR}/ForwardingHeaders)
set(FORWARDING_HEADERS_WPE_DIR ${FORWARDING_HEADERS_DIR}/wpe)
set(FORWARDING_HEADERS_WPE_EXTENSION_DIR
    ${FORWARDING_HEADERS_DIR}/wpe-web-process-extension)
set(FORWARDING_HEADERS_WPE_DOM_DIR ${FORWARDING_HEADERS_DIR}/wpe-dom)
set(FORWARDING_HEADERS_WPE_JSC_DIR ${FORWARDING_HEADERS_DIR}/wpe-jsc)

# FIXME: Remove in https://bugs.webkit.org/show_bug.cgi?id=210891
set(WebKit_FRAMEWORK_HEADERS_DIR ${FORWARDING_HEADERS_DIR})
set(WebKit_PRIVATE_FRAMEWORK_HEADERS_DIR ${FORWARDING_HEADERS_DIR})
set(WebKit_DERIVED_SOURCES_DIR "${CMAKE_BINARY_DIR}/DerivedSources/WebKit")
set(PAL_DERIVED_SOURCES_DIR "${CMAKE_BINARY_DIR}/DerivedSources/PAL")
set(PAL_FRAMEWORK_HEADERS_DIR "${CMAKE_BINARY_DIR}/PAL/Headers")
set(JavaScriptCore_FRAMEWORK_HEADERS_DIR
    "${CMAKE_BINARY_DIR}/JavaScriptCore/Headers")
set(JavaScriptCore_PRIVATE_FRAMEWORK_HEADERS_DIR
    "${CMAKE_BINARY_DIR}/JavaScriptCore/PrivateHeaders")
set(WTF_FRAMEWORK_HEADERS_DIR "${CMAKE_BINARY_DIR}/WTF/Headers")
set(WPEPlatform_DERIVED_SOURCES_DIR
    "${CMAKE_BINARY_DIR}/DerivedSources/WPEPlatform")

set(JavaScriptCoreGLib_FRAMEWORK_HEADERS_DIR
    "${CMAKE_BINARY_DIR}/JavaScriptCoreGLib/Headers")
set(JavaScriptCoreGLib_DERIVED_SOURCES_DIR
    "${CMAKE_BINARY_DIR}/JavaScriptCoreGLib/DerivedSources")

set(WPE_PKGCONFIG_FILE ${CMAKE_BINARY_DIR}/wpe-webkit-${WPE_API_VERSION}.pc)
set(WPE_Uninstalled_PKGCONFIG_FILE
    ${CMAKE_BINARY_DIR}/wpe-webkit-${WPE_API_VERSION}-uninstalled.pc)

if(ENABLE_2022_GLIB_API)
  set(WPE_WEB_PROCESS_EXTENSION_PC_MODULE
      "wpe-web-process-extension-${WPE_API_VERSION}")
else()
  set(WPE_WEB_PROCESS_EXTENSION_PC_MODULE
      "wpe-web-extension-${WPE_API_VERSION}")
endif()
expose_string_variable_to_build(WPE_WEB_PROCESS_EXTENSION_PC_MODULE)

set(WPEWebProcessExtension_PKGCONFIG_FILE
    ${CMAKE_BINARY_DIR}/${WPE_WEB_PROCESS_EXTENSION_PC_MODULE}.pc)
set(WPEWebProcessExtension_Uninstalled_PKGCONFIG_FILE
    ${CMAKE_BINARY_DIR}/${WPE_WEB_PROCESS_EXTENSION_PC_MODULE}-uninstalled.pc)

include(BubblewrapSandboxChecks)
include(GStreamerChecks)
