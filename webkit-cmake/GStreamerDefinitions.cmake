webkit_option_default_port_value(ENABLE_VIDEO PUBLIC ON)
webkit_option_default_port_value(ENABLE_WEB_AUDIO PUBLIC ON)

webkit_option_default_port_value(ENABLE_MEDIA_SOURCE PRIVATE ON)

webkit_option_define(USE_GSTREAMER_GL
                     "Whether to enable support for GStreamer GL" PRIVATE ON)
webkit_option_define(USE_GSTREAMER_MPEGTS
                     "Whether to enable support for MPEG-TS" PRIVATE OFF)
webkit_option_define(
  USE_GSTREAMER_FULL "Whether to enable support for static GStreamer builds"
  PRIVATE OFF)
webkit_option_define(
  USE_GSTREAMER_TRANSCODER
  "Whether to enable support for GStreamer MediaRecorder backend" PUBLIC ON)
webkit_option_define(USE_GSTREAMER_WEBRTC
                     "Whether to enable support for WebRTC" PUBLIC ON)
