# WebKit dropped MSVC support. This file is only for clang-cl.

function(MSVC_ADD_COMPILE_OPTIONS)
  foreach(_option ${ARGV})
    add_compile_options($<$<COMPILE_LANGUAGE:C,CXX>:${_option}>)
  endforeach()
endfunction()

# Create pdb files for debugging purposes, also for Release builds
msvc_add_compile_options(/Zi /GS)

# Disable ICF (identical code folding) optimization, as it makes it unsafe to
# pointer-compare functions with identical definitions.
add_link_options(/DEBUG /OPT:NOICF /OPT:REF)

# We do not use exceptions
add_definitions(-D_HAS_EXCEPTIONS=0)
string(REGEX REPLACE "/EH[-a-z]+" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
msvc_add_compile_options(/EHa- /EHc- /EHs- /fp:except-)

# Disable RTTI
string(REGEX REPLACE "/GR-?" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
msvc_add_compile_options(/GR-)

# We have some very large object files that have to be linked
msvc_add_compile_options(/analyze- /bigobj)

# Use CRT security features
add_definitions(-D_CRT_SECURE_NO_WARNINGS)

add_definitions(-D_ENABLE_EXTENDED_ALIGNED_STORAGE)

# Specify the source code encoding
msvc_add_compile_options(/utf-8 /validate-charset)

if(NOT ${CMAKE_GENERATOR} MATCHES "Ninja")
  msvc_add_compile_options(/MP)
endif()

# More warnings. /W4 should be specified before -Wno-* options for clang-cl.
string(REGEX REPLACE "/W3" "" CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
string(REGEX REPLACE "/W3" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})
webkit_prepend_global_compiler_flags(/W4)

# Make sure incremental linking is turned off, as it creates unacceptably long
# link times.
string(REPLACE "/INCREMENTAL[:A-Z]+" "" CMAKE_EXE_LINKER_FLAGS
               ${CMAKE_EXE_LINKER_FLAGS})
string(REPLACE "/INCREMENTAL[:A-Z]+" "" CMAKE_EXE_LINKER_FLAGS_DEBUG
               ${CMAKE_EXE_LINKER_FLAGS_DEBUG})
string(REPLACE "/INCREMENTAL[:A-Z]+" "" CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO
               ${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO})
string(REPLACE "/INCREMENTAL[:A-Z]+" "" CMAKE_SHARED_LINKER_FLAGS
               ${CMAKE_SHARED_LINKER_FLAGS})
string(REPLACE "/INCREMENTAL[:A-Z]+" "" CMAKE_SHARED_LINKER_FLAGS_DEBUG
               ${CMAKE_SHARED_LINKER_FLAGS_DEBUG})
string(REPLACE "/INCREMENTAL[:A-Z]+" ""
               CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO
               ${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO})
add_link_options(/INCREMENTAL:NO)

# Link clang runtime builtins library
string(REGEX MATCH "^[0-9]+" CLANG_CL_MAJOR_VERSION
             ${CMAKE_CXX_COMPILER_VERSION})
cmake_path(REMOVE_FILENAME CMAKE_CXX_COMPILER OUTPUT_VARIABLE CLANG_CL_DIR)
cmake_path(APPEND CLANG_CL_DIR "../lib/clang" ${CLANG_CL_MAJOR_VERSION}
           "lib/windows")
find_library(
  CLANG_BUILTINS_LIBRARY clang_rt.builtins-x86_64
  PATHS ${CLANG_CL_DIR} REQUIRED
  NO_DEFAULT_PATH)
link_libraries(${CLANG_BUILTINS_LIBRARY})
