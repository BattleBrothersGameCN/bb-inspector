# FIXME: These should line up with versions in Configurations/Version.xcconfig.
# See Source/WebKitLegacy/PlatformWin.cmake for how WebKitVersion.h is
# generated.
set(WEBKIT_MAC_VERSION 615.1.1)
set(MACOSX_FRAMEWORK_BUNDLE_VERSION 615.1.1+)

webkit_option_begin()
# Private options shared with other WebKit ports. Add options here only if we
# need a value different from the default defined in WebKitFeatures.cmake.

# FIXME: https://bugs.webkit.org/show_bug.cgi?id=231776
# WEBKIT_OPTION_DEFAULT_PORT_VALUE(ENABLE_API_TESTS PRIVATE ON)

webkit_option_default_port_value(ENABLE_APPLE_PAY PRIVATE ON)
webkit_option_default_port_value(ENABLE_APPLICATION_MANIFEST PRIVATE ON)
webkit_option_default_port_value(ENABLE_ASYNC_SCROLLING PRIVATE ON)
webkit_option_default_port_value(ENABLE_ATTACHMENT_ELEMENT PRIVATE ON)
webkit_option_default_port_value(ENABLE_AVF_CAPTIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_CACHE_PARTITIONING PRIVATE ON)
webkit_option_default_port_value(ENABLE_CONTENT_EXTENSIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_CONTENT_FILTERING PRIVATE ON)
webkit_option_default_port_value(ENABLE_CURSOR_VISIBILITY PRIVATE ON)
webkit_option_default_port_value(ENABLE_DARK_MODE_CSS PRIVATE ON)
webkit_option_default_port_value(ENABLE_DATACUE_VALUE PRIVATE ON)
webkit_option_default_port_value(ENABLE_DATALIST_ELEMENT PRIVATE ON)
webkit_option_default_port_value(ENABLE_DATE_AND_TIME_INPUT_TYPES PRIVATE ON)
webkit_option_default_port_value(ENABLE_DRAG_SUPPORT PRIVATE ON)
webkit_option_default_port_value(ENABLE_ENCRYPTED_MEDIA PRIVATE ON)
webkit_option_default_port_value(ENABLE_EXPERIMENTAL_FEATURES PRIVATE ON)
webkit_option_default_port_value(ENABLE_GAMEPAD PRIVATE ON)
webkit_option_default_port_value(ENABLE_GPU_PROCESS PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_COLOR PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_DATE PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_DATETIMELOCAL PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_MONTH PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_TIME PRIVATE ON)
webkit_option_default_port_value(ENABLE_INPUT_TYPE_WEEK PRIVATE ON)
webkit_option_default_port_value(ENABLE_INSPECTOR_ALTERNATE_DISPATCHERS PRIVATE
                                 ON)
webkit_option_default_port_value(ENABLE_INSPECTOR_EXTENSIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_INSPECTOR_TELEMETRY PRIVATE ON)
webkit_option_default_port_value(ENABLE_LEGACY_CUSTOM_PROTOCOL_MANAGER PRIVATE
                                 ON)
webkit_option_default_port_value(ENABLE_LEGACY_ENCRYPTED_MEDIA PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_SOURCE PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEDIA_STREAM PRIVATE ON)
webkit_option_default_port_value(ENABLE_MEMORY_SAMPLER PRIVATE ON)
webkit_option_default_port_value(ENABLE_MOUSE_CURSOR_SCALE PRIVATE ON)
webkit_option_default_port_value(ENABLE_NETWORK_CACHE_SPECULATIVE_REVALIDATION
                                 PRIVATE ON)
webkit_option_default_port_value(ENABLE_NETWORK_CACHE_STALE_WHILE_REVALIDATE
                                 PRIVATE ON)
webkit_option_default_port_value(ENABLE_PAYMENT_REQUEST PRIVATE ON)
webkit_option_default_port_value(ENABLE_PDFKIT_PLUGIN PRIVATE ON)
webkit_option_default_port_value(ENABLE_PERIODIC_MEMORY_MONITOR PRIVATE ON)
webkit_option_default_port_value(ENABLE_PICTURE_IN_PICTURE_API PRIVATE ON)
webkit_option_default_port_value(ENABLE_POINTER_LOCK PRIVATE ON)
webkit_option_default_port_value(ENABLE_RESOURCE_USAGE PRIVATE ON)
webkit_option_default_port_value(ENABLE_SANDBOX_EXTENSIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_SERVER_PRECONNECT PRIVATE ON)
webkit_option_default_port_value(ENABLE_SERVICE_CONTROLS PRIVATE ON)
webkit_option_default_port_value(ENABLE_SHAREABLE_RESOURCE PRIVATE ON)
webkit_option_default_port_value(ENABLE_SPEECH_SYNTHESIS PRIVATE ON)
webkit_option_default_port_value(ENABLE_TELEPHONE_NUMBER_DETECTION PRIVATE ON)
webkit_option_default_port_value(ENABLE_TEXT_AUTOSIZING PRIVATE ON)
webkit_option_default_port_value(ENABLE_VARIATION_FONTS PRIVATE ON)
webkit_option_default_port_value(ENABLE_VIDEO_PRESENTATION_MODE PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEBDRIVER_KEYBOARD_INTERACTIONS PRIVATE
                                 ON)
webkit_option_default_port_value(ENABLE_WEBDRIVER_MOUSE_INTERACTIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEBDRIVER_WHEEL_INTERACTIONS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEBXR PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_API_STATISTICS PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_AUTHN PRIVATE ON)
webkit_option_default_port_value(ENABLE_WEB_RTC PRIVATE ON)
webkit_option_default_port_value(ENABLE_WIRELESS_PLAYBACK_TARGET PRIVATE ON)
webkit_option_default_port_value(USE_AVIF PRIVATE OFF)
webkit_option_default_port_value(USE_JPEGXL PRIVATE OFF)

webkit_option_end()

set_and_expose_to_build(USE_LIBWEBRTC TRUE)

set(ENABLE_WEBKIT_LEGACY ON)
set(ENABLE_WEBKIT ON)

set(bmalloc_LIBRARY_TYPE OBJECT)
set(WTF_LIBRARY_TYPE OBJECT)
set(JavaScriptCore_LIBRARY_TYPE SHARED)
set(PAL_LIBRARY_TYPE OBJECT)
set(WebCore_LIBRARY_TYPE SHARED)

set(USE_ANGLE_EGL ON)

find_package(ICU 61.2 REQUIRED COMPONENTS data i18n uc)
find_package(LibXml2 2.8.0 REQUIRED)
find_package(LibXslt 1.1.7 REQUIRED)
