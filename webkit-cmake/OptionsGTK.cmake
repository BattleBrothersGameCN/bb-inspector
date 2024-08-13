include(GNUInstallDirs)
include(VersioningUtils)

webkit_option_begin()

set_project_version(2 45 5)

set(USER_AGENT_BRANDING
    ""
    CACHE STRING "Branding to add to user agent string")

find_package(Cairo 1.16.0 REQUIRED)
find_package(LibGcrypt 1.7.0 REQUIRED)
find_package(Libtasn1 REQUIRED)
find_package(HarfBuzz 1.4.2 REQUIRED COMPONENTS ICU)
find_package(ICU 61.2 REQUIRED COMPONENTS data i18n uc)
find_package(JPEG REQUIRED)
find_package(Epoxy 1.5.4 REQUIRED)
find_package(LibXml2 2.8.0 REQUIRED)
find_package(PNG REQUIRED)
find_package(SQLite3 REQUIRED)
find_package(Threads REQUIRED)
find_package(Unifdef REQUIRED)
find_package(ZLIB REQUIRED)
find_package(WebP REQUIRED COMPONENTS demux)
find_package(ATSPI 2.5.3)

include(GStreamerDefinitions)
include(FindGLibCompileResources)

set_and_expose_to_build(USE_GCRYPT TRUE)
set_and_expose_to_build(USE_LIBEPOXY TRUE)
set_and_expose_to_build(USE_THEME_ADWAITA TRUE)
set_and_expose_to_build(USE_XDGMIME TRUE)

if(WTF_CPU_ARM OR WTF_CPU_MIPS)
  set_and_expose_to_build(USE_CAPSTONE ${DEVELOPER_MODE})
endif()

# Public options specific to the GTK port. Do not add any options here unless
# there is a strong reason we should support changing the value of the option,
# and the option is not relevant to other WebKit ports.
webkit_option_define(ENABLE_DOCUMENTATION "Whether to generate documentation."
                     PUBLIC ON)
webkit_option_define(ENABLE_INTROSPECTION
                     "Whether to enable GObject introspection." PUBLIC ON)
webkit_option_define(ENABLE_JOURNALD_LOG "Whether to enable journald logging"
                     PUBLIC ON)
webkit_option_define(
  ENABLE_QUARTZ_TARGET
  "Whether to enable support for the Quartz windowing target." PUBLIC ON)
webkit_option_define(
  ENABLE_WAYLAND_TARGET
  "Whether to enable support for the Wayland windowing target." PUBLIC ON)
webkit_option_define(
  ENABLE_X11_TARGET "Whether to enable support for the X11 windowing target."
  PUBLIC ON)
webkit_option_define(USE_GBM "Whether to enable usage of GBM." PUBLIC ON)
webkit_option_define(
  USE_GTK4 "Whether to enable usage of GTK4 instead of GTK3." PUBLIC ON)
webkit_option_define(USE_LIBBACKTRACE
                     "Whether to enable usage of libbacktrace." PUBLIC ON)
webkit_option_define(USE_LIBDRM "Whether to enable usage of libdrm." PUBLIC ON)
webkit_option_define(
  USE_LIBHYPHEN
  "Whether to enable the default automatic hyphenation implementation." PUBLIC
  ON)
webkit_option_define(
  USE_LIBSECRET
  "Whether to enable the persistent credential storage using libsecret." PUBLIC
  ON)
webkit_option_define(
  USE_SOUP2 "Whether to enable usage of Soup 2 instead of Soup 3." PUBLIC OFF)

webkit_option_depend(ENABLE_DOCUMENTATION ENABLE_INTROSPECTION)
webkit_option_depend(USE_GBM USE_LIBDRM)

webkit_option_conflict(USE_GTK4 USE_SOUP2)

# Private options specific to the GTK port. Changing these options is completely
# unsupported. They are intended for use only by WebKit developers.
set_and_expose_to_build(ENABLE_DEVELOPER_MODE ${DEVELOPER_MODE})
if(DEVELOPER_MODE)
  webkit_option_default_port_value(ENABLE_API_TESTS PRIVATE ON)
  webkit_option_default_port_value(ENABLE_LAYOUT_TESTS PRIVATE ON)
else()
  webkit_option_default_port_value(ENABLE_API_TESTS PRIVATE OFF)
  webkit_option_default_port_value(ENABLE_LAYOUT_TESTS PRIVATE OFF)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
  webkit_option_default_port_value(ENABLE_BUBBLEWRAP_SANDBOX PUBLIC ON)
  webkit_option_default_port_value(ENABLE_MEMORY_SAMPLER PRIVATE ON)
  webkit_option_default_port_value(ENABLE_RESOURCE_USAGE PRIVATE ON)
else()
  webkit_option_default_port_value(ENABLE_BUBBLEWRAP_SANDBOX PUBLIC OFF)
  webkit_option_default_port_value(ENABLE_MEMORY_SAMPLER PRIVATE OFF)
  webkit_option_default_port_value(ENABLE_RESOURCE_USAGE PRIVATE OFF)
endif()

# Public options shared with other WebKit ports. Do not add any options here
# without approval from a GTK reviewer. There must be strong reason to support
# changing the value of the option.
webkit_option_default_port_value(ENABLE_DRAG_SUPPORT PUBLIC ON)
webkit_option_default_port_value(ENABLE_GAMEPAD PUBLIC ON)
webkit_option_default_port_value(ENABLE_MINIBROWSER PUBLIC ON)
webkit_option_default_port_value(ENABLE_PDFJS PUBLIC ON)
webkit_option_default_port_value(ENABLE_SPELLCHECK PUBLIC ON)
webkit_option_default_port_value(ENABLE_TOUCH_EVENTS PUBLIC ON)
webkit_option_default_port_value(ENABLE_WEBDRIVER PUBLIC ON)

webkit_option_default_port_value(USE_AVIF PUBLIC ON)
webkit_option_default_port_value(USE_LCMS PUBLIC ON)
webkit_option_default_port_value(USE_JPEGXL PUBLIC ON)
webkit_option_default_port_value(USE_WOFF2 PUBLIC ON)

# Private options shared with other WebKit ports. Add options here when we need
# a value different from the default defined in WebKitFeatures.cmake. Changing
# these options is completely unsupported.
webkit_option_default_port_value(ENABLE_ASYNC_SCROLLING PRIVATE ON)
webkit_option_default_port_value(ENABLE_AUTOCAPITALIZE PRIVATE ON)
webkit_option_default_port_value(ENABLE_CONTENT_EXTENSIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_CURSOR_VISIBILITY PRIVATE ON)
webkit_option_default_port_value(ENABLE_DARK_MODE_CSS PRIVATE ON)
webkit_option_default_port_value(ENABLE_DATALIST_ELEMENT PRIVATE ON)
webkit_option_default_port_value(ENABLE_DATE_AND_TIME_INPUT_TYPES PRIVATE ON)
webkit_option_default_port_value(ENABLE_ENCRYPTED_MEDIA PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_FTPDIR PRIVATE OFF)
webkit_option_default_port_value(ENABLE_GPU_PROCESS PRIVATE OFF)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_COLOR PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_DATE PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_DATETIMELOCAL PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_MONTH PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_TIME PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_WEEK PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_RECORDER PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_SESSION PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_SESSION_PLAYLIST PRIVATE OFF)
webkit_option_default_port_value(ENABLE_MEDIA_STREAM PRIVATE ON)
webkit_option_default_port_value(ENABLE_MHTML PRIVATE ON)
webkit_option_default_port_value(ENABLE_MODERN_MEDIA_CONTROLS PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_CONTROLS_CONTEXT_MENUS PRIVATE ON)
webkit_option_default_port_value(ENABLE_MOUSE_CURSOR_SCALE PRIVATE ON)
webkit_option_default_port_value(ENABLE_NETWORK_CACHE_SPECULATIVE_REVALIDATION
                                 PRIVATE ON)
webkit_option_default_port_value(ENABLE_NETWORK_CACHE_STALE_WHILE_REVALIDATE
                                 PRIVATE ON)
webkit_option_default_port_value(ENABLE_OFFSCREEN_CANVAS PRIVATE ON)
webkit_option_default_port_value(ENABLE_OFFSCREEN_CANVAS_IN_WORKERS PRIVATE ON)
webkit_option_default_port_value(ENABLE_THUNDER PRIVATE
                                 ${ENABLE_DEVELOPER_MODE})
webkit_option_default_port_value(ENABLE_PERIODIC_MEMORY_MONITOR PRIVATE ON)
webkit_option_default_port_value(ENABLE_POINTER_LOCK PRIVATE ON)
webkit_option_default_port_value(ENABLE_SHAREABLE_RESOURCE PRIVATE ON)
webkit_option_default_port_value(ENABLE_SPEECH_SYNTHESIS PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})
webkit_option_default_port_value(ENABLE_VARIATION_FONTS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_API_STATISTICS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_CODECS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_RTC PRIVATE
                                 ${ENABLE_EXPERIMENTAL_FEATURES})

webkit_option_default_port_value(USE_SYSPROF_CAPTURE PRIVATE ON)

if(CMAKE_CXX_BYTE_ORDER STREQUAL "LITTLE_ENDIAN")
  webkit_option_default_port_value(USE_SKIA PRIVATE ON)
else()
  webkit_option_default_port_value(USE_SKIA PRIVATE OFF)
endif()

include(GStreamerDependencies)

# Finalize the value for all options. Do not attempt to use an option before
# this point, and do not attempt to change any option after this point.
webkit_option_end()

if(USE_GTK4)
  set(GTK_MINIMUM_VERSION 4.6.0)
  set(GTK_PC_NAME gtk4)
else()
  set(GTK_MINIMUM_VERSION 3.22.0)
  set(GTK_PC_NAME gtk+-3.0)
endif()
find_package(GTK ${GTK_MINIMUM_VERSION} REQUIRED OPTIONAL_COMPONENTS unix-print)

if(ENABLE_QUARTZ_TARGET AND NOT ${GTK_SUPPORTS_QUARTZ})
  set(ENABLE_QUARTZ_TARGET OFF)
endif()
if(ENABLE_X11_TARGET AND NOT ${GTK_SUPPORTS_X11})
  set(ENABLE_X11_TARGET OFF)
endif()
if(ENABLE_WAYLAND_TARGET AND NOT ${GTK_SUPPORTS_WAYLAND})
  set(ENABLE_WAYLAND_TARGET OFF)
endif()

if(USE_SOUP2)
  set(SOUP_MINIMUM_VERSION 2.54.0)
  set(SOUP_API_VERSION 2.4)
else()
  set(SOUP_MINIMUM_VERSION 3.0.0)
  set(SOUP_API_VERSION 3.0)
  set(ENABLE_SERVER_PRECONNECT ON)
endif()
find_package(LibSoup ${SOUP_MINIMUM_VERSION})

if(NOT LibSoup_FOUND)
  if(USE_SOUP2)
    message(FATAL_ERROR "libsoup is required.")
  else()
    message(
      FATAL_ERROR
        "libsoup 3 is required. Enable USE_SOUP2 to use libsoup 2 (disables HTTP/2)"
    )
  endif()
endif()

if(USE_GTK4)
  set(WEBKITGTK_API_INFIX "")
  set(WEBKITGTK_API_VERSION "6.0")
  set_and_expose_to_build(ENABLE_2022_GLIB_API ON)
elseif(USE_SOUP2)
  set(WEBKITGTK_API_INFIX "2")
  set(WEBKITGTK_API_VERSION "4.0")
  set_and_expose_to_build(ENABLE_2022_GLIB_API OFF)
else()
  set(WEBKITGTK_API_INFIX "2")
  set(WEBKITGTK_API_VERSION "4.1")
  set_and_expose_to_build(ENABLE_2022_GLIB_API OFF)
endif()

if(ENABLE_2022_GLIB_API)
  set(GLIB_MINIMUM_VERSION 2.70.0)
else()
  set(GLIB_MINIMUM_VERSION 2.56.4)
endif()
find_package(GLIB ${GLIB_MINIMUM_VERSION} REQUIRED
             COMPONENTS gio gio-unix gobject gthread gmodule)

expose_string_variable_to_build(WEBKITGTK_API_INFIX)
expose_string_variable_to_build(WEBKITGTK_API_VERSION)

if(WEBKITGTK_API_VERSION VERSION_EQUAL "4.0")
  calculate_library_versions_from_libtool_triple(WEBKIT 107 3 70)
  calculate_library_versions_from_libtool_triple(JAVASCRIPTCORE 43 4 25)
elseif(WEBKITGTK_API_VERSION VERSION_EQUAL "4.1")
  calculate_library_versions_from_libtool_triple(WEBKIT 15 3 15)
  calculate_library_versions_from_libtool_triple(JAVASCRIPTCORE 6 4 6)
elseif(WEBKITGTK_API_VERSION VERSION_EQUAL "6.0")
  calculate_library_versions_from_libtool_triple(WEBKIT 13 1 9)
  calculate_library_versions_from_libtool_triple(JAVASCRIPTCORE 4 4 3)
else()
  message(FATAL_ERROR "Unhandled API version")
endif()

set(CMAKE_C_VISIBILITY_PRESET hidden)
set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(bmalloc_LIBRARY_TYPE OBJECT)
set(WTF_LIBRARY_TYPE OBJECT)
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
    "${CMAKE_INSTALL_FULL_LIBEXECDIR}/webkit${WEBKITGTK_API_INFIX}gtk-${WEBKITGTK_API_VERSION}"
    CACHE PATH "Absolute path to install executables executed by the library")

set(WEBKITGTK_HEADER_INSTALL_DIR
    "${CMAKE_INSTALL_INCLUDEDIR}/webkitgtk-${WEBKITGTK_API_VERSION}")
set(INTROSPECTION_INSTALL_GIRDIR "${CMAKE_INSTALL_FULL_DATADIR}/gir-1.0")
set(INTROSPECTION_INSTALL_TYPELIBDIR "${LIB_INSTALL_DIR}/girepository-1.0")

set_and_expose_to_build(WTF_PLATFORM_QUARTZ ${ENABLE_QUARTZ_TARGET})
set_and_expose_to_build(WTF_PLATFORM_X11 ${ENABLE_X11_TARGET})
set_and_expose_to_build(WTF_PLATFORM_WAYLAND ${ENABLE_WAYLAND_TARGET})

set_and_expose_to_build(ENABLE_PLUGIN_PROCESS FALSE)

add_definitions(-DBUILDING_GTK__=1)
add_definitions(-DGETTEXT_PACKAGE="WebKitGTK-${WEBKITGTK_API_VERSION}")
add_definitions(-DJSC_GLIB_API_ENABLED)

if(USER_AGENT_BRANDING)
  add_definitions(-DUSER_AGENT_BRANDING="${USER_AGENT_BRANDING}")
endif()

if(NOT EXISTS "${TOOLS_DIR}/glib/apply-build-revision-to-files.py")
  set(BUILD_REVISION "tarball")
endif()

if(NOT USE_GTK4)
  set_and_expose_to_build(USE_ATK 1)
endif()

set_and_expose_to_build(USE_ATSPI 1)
set_and_expose_to_build(HAVE_GTK_UNIX_PRINTING ${GTK_UNIX_PRINT_FOUND})
set_and_expose_to_build(HAVE_OS_DARK_MODE_SUPPORT 1)

if(USE_SKIA)
  set_and_expose_to_build(USE_CAIRO FALSE)
else()
  find_package(Fontconfig 2.13.0 REQUIRED)
  find_package(Freetype 2.9.0 REQUIRED)
  set_and_expose_to_build(USE_CAIRO TRUE)
endif()

# https://bugs.webkit.org/show_bug.cgi?id=182247
if(ENABLED_COMPILER_SANITIZERS)
  set(ENABLE_INTROSPECTION OFF)
  set(ENABLE_DOCUMENTATION OFF)
endif()

# GUri is available in GLib since version 2.66, but we only want to use it if
# version is >= 2.67.1.
if(PC_GLIB_VERSION VERSION_GREATER "2.67.1" OR PC_GLIB_VERSION STREQUAL
                                               "2.67.1")
  set_and_expose_to_build(HAVE_GURI 1)
endif()

if(ENABLE_GAMEPAD)
  find_package(Manette 0.2.4)
  if(NOT Manette_FOUND)
    message(FATAL_ERROR "libmanette is required for ENABLE_GAMEPAD")
  endif()
  set_and_expose_to_build(USE_MANETTE TRUE)
endif()

if(ENABLE_XSLT)
  find_package(LibXslt 1.1.7 REQUIRED)
endif()

if(USE_LIBSECRET)
  find_package(Libsecret)
  if(NOT LIBSECRET_FOUND)
    message(FATAL_ERROR "libsecret is needed for USE_LIBSECRET")
  endif()
endif()

find_package(GI)
if(ENABLE_INTROSPECTION AND NOT GI_FOUND)
  message(
    FATAL_ERROR "GObjectIntrospection is needed for ENABLE_INTROSPECTION.")
endif()

find_package(GIDocgen)
if(ENABLE_DOCUMENTATION AND NOT GIDocgen_FOUND)
  message(FATAL_ERROR "ENABLE_INTROSPECTION is needed for gi-docgen.")
endif()

if(ENABLE_WEBDRIVER)
  set_and_expose_to_build(ENABLE_WEBDRIVER_KEYBOARD_INTERACTIONS ON)
  set_and_expose_to_build(ENABLE_WEBDRIVER_MOUSE_INTERACTIONS ON)
  set_and_expose_to_build(ENABLE_WEBDRIVER_TOUCH_INTERACTIONS OFF)
  set_and_expose_to_build(ENABLE_WEBDRIVER_WHEEL_INTERACTIONS ON)
endif()

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

set_and_expose_to_build(USE_TEXTURE_MAPPER ON)
set_and_expose_to_build(USE_COORDINATED_GRAPHICS ON)
set_and_expose_to_build(USE_NICOSIA ON)
set_and_expose_to_build(USE_ANGLE ${ENABLE_WEBGL})

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
  set_and_expose_to_build(USE_TEXTURE_MAPPER_DMABUF ON)
endif()

if(ENABLE_SPEECH_SYNTHESIS)
  find_package(Flite 2.2)
  if(NOT Flite_FOUND)
    message(FATAL_ERROR "Flite is needed for ENABLE_SPEECH_SYNTHESIS")
  endif()
endif()

if(ENABLE_SPELLCHECK)
  find_package(Enchant)
  if(NOT PC_ENCHANT_FOUND)
    message(FATAL_ERROR "Enchant is needed for ENABLE_SPELLCHECK")
  endif()
endif()

if(ENABLE_QUARTZ_TARGET)
  if(NOT GTK_SUPPORTS_QUARTZ)
    message(
      FATAL_ERROR
        "Recompile GTK with Quartz backend to use ENABLE_QUARTZ_TARGET")
  endif()
endif()

if(ENABLE_X11_TARGET)
  if(NOT GTK_SUPPORTS_X11)
    message(
      FATAL_ERROR "Recompile GTK with X11 backend to use ENABLE_X11_TARGET")
  endif()

  find_package(X11 REQUIRED)
endif()

if(ENABLE_WAYLAND_TARGET)
  if(NOT GTK_SUPPORTS_WAYLAND)
    message(
      FATAL_ERROR
        "Recompile GTK with Wayland backend to use ENABLE_WAYLAND_TARGET")
  endif()

  find_package(Wayland 1.20 REQUIRED)
  find_package(WaylandProtocols 1.24 REQUIRED)
endif()

if(USE_JPEGXL)
  find_package(JPEGXL 0.7.0)
  if(NOT JPEGXL_FOUND)
    message(FATAL_ERROR "libjxl is required for USE_JPEGXL")
  endif()
endif()

if(USE_LIBHYPHEN)
  find_package(Hyphen)
  if(NOT HYPHEN_FOUND)
    message(FATAL_ERROR "libhyphen is needed for USE_LIBHYPHEN.")
  endif()
endif()

if(USE_WOFF2)
  find_package(WOFF2 1.0.2 COMPONENTS dec)
  if(NOT WOFF2_FOUND)
    message(FATAL_ERROR "libwoff2dec is required for USE_WOFF2")
  endif()
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

if(USE_LIBBACKTRACE)
  find_package(LibBacktrace)
  if(NOT LIBBACKTRACE_FOUND)
    message(FATAL_ERROR "libbacktrace is required for USE_LIBBACKTRACE")
  endif()
endif()

# Override the cached variable, gtk-doc does not really work when building on
# Mac.
if(APPLE)
  set(ENABLE_GTKDOC OFF)
endif()

# Using DERIVED_SOURCES_DIR is deprecated
set(DERIVED_SOURCES_DIR "${CMAKE_BINARY_DIR}/DerivedSources")

# Using FORWARDING_HEADERS_DIR is deprecated
set(FORWARDING_HEADERS_DIR ${DERIVED_SOURCES_DIR}/ForwardingHeaders)

# FIXME: Remove in https://bugs.webkit.org/show_bug.cgi?id=210891
set(WebKit_FRAMEWORK_HEADERS_DIR ${FORWARDING_HEADERS_DIR})
set(WebKit_PRIVATE_FRAMEWORK_HEADERS_DIR ${FORWARDING_HEADERS_DIR})
set(WebKit_DERIVED_SOURCES_DIR "${CMAKE_BINARY_DIR}/DerivedSources/WebKit")

set(JavaScriptCoreGLib_FRAMEWORK_HEADERS_DIR
    "${CMAKE_BINARY_DIR}/JavaScriptCoreGLib/Headers")
set(JavaScriptCoreGLib_DERIVED_SOURCES_DIR
    "${CMAKE_BINARY_DIR}/JavaScriptCoreGLib/DerivedSources")

set(WebKitGTK_FRAMEWORK_HEADERS_DIR "${CMAKE_BINARY_DIR}/WebKitGTK/Headers")
set(WebKitGTK_DERIVED_SOURCES_DIR
    "${CMAKE_BINARY_DIR}/WebKitGTK/DerivedSources")

set(JavaScriptCore_PKGCONFIG_FILE
    ${CMAKE_BINARY_DIR}/Source/JavaScriptCore/javascriptcoregtk-${WEBKITGTK_API_VERSION}.pc
)
set(WebKitGTK_PKGCONFIG_FILE
    ${CMAKE_BINARY_DIR}/Source/WebKit/webkit${WEBKITGTK_API_INFIX}gtk-${WEBKITGTK_API_VERSION}.pc
)
if(ENABLE_2022_GLIB_API)
  set(WebKitGTKWebProcessExtension_PKGCONFIG_FILE
      ${CMAKE_BINARY_DIR}/Source/WebKit/webkitgtk-web-process-extension-${WEBKITGTK_API_VERSION}.pc
  )
else()
  set(WebKitGTKWebProcessExtension_PKGCONFIG_FILE
      ${CMAKE_BINARY_DIR}/Source/WebKit/webkit2gtk-web-extension-${WEBKITGTK_API_VERSION}.pc
  )
endif()

set(JavaScriptCore_LIBRARY_TYPE SHARED)
set(SHOULD_INSTALL_JS_SHELL ON)

# Add a typelib file to the list of all typelib dependencies. This makes it easy
# to expose a 'gir' target with all gobject-introspection files.
macro(ADD_TYPELIB typelib)
  if(ENABLE_INTROSPECTION)
    get_filename_component(target_name ${typelib} NAME_WE)
    add_custom_target(${target_name}-gir ALL DEPENDS ${typelib})
    list(APPEND GObjectIntrospectionTargets ${target_name}-gir)
    set(GObjectIntrospectionTargets
        ${GObjectIntrospectionTargets}
        PARENT_SCOPE)
  endif()
endmacro()

include(BubblewrapSandboxChecks)
include(GStreamerChecks)
