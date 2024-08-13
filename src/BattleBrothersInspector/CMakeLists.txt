set(BattleBrothersInspector_SOURCES
    Common.cpp
    Common2.cpp
    MainWindow.cpp
    MiniBrowserLib.rc
    WebKitBrowserWindow.cpp
    WinMain.cpp
    stdafx.cpp)

set(BattleBrothersInspector_PRIVATE_LIBRARIES comctl32 shlwapi user32 DbgHelp)

set(WEBKIT_LIBRARY JavaScriptCore WTF WebCore WebKit2)

add_executable(BattleBrothersInspector "${CMAKE_BINARY_DIR}/cmakeconfig.h"
                                       ${BattleBrothersInspector_SOURCES})
target_include_directories(
  BattleBrothersInspector PRIVATE ${webkit_headers_dir} ${external_headers_dir}
                                  ${CMAKE_BINARY_DIR})
target_link_directories(BattleBrothersInspector PRIVATE ${webkit_libs_dir}
                        ${external_libs_dir})
target_link_libraries(BattleBrothersInspector PUBLIC ${WEBKIT_LIBRARY})
target_link_libraries(BattleBrothersInspector
                      PRIVATE ${BattleBrothersInspector_PRIVATE_LIBRARIES})
set_target_properties(BattleBrothersInspector PROPERTIES WIN32_EXECUTABLE ON)
set_target_properties(BattleBrothersInspector PROPERTIES OUTPUT_NAME
                                                         "bb-ui-inspector")
