# * Try to find libsecret Once done, this will define
#
# LIBSECRET_FOUND - system has libsecret LIBSECRET_INCLUDE_DIRS - the libsecret
# include directories LIBSECRET_LIBRARIES - link these to use libsecret
#
# Copyright (C) 2012 Raphael Kubo da Costa <rakuco@webkit.org> Copyright (C)
# 2014 Igalia S.L.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 1.
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer. 2.  Redistributions in binary
# form must reproduce the above copyright notice, this list of conditions and
# the following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND ITS CONTRIBUTORS ``AS
# IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR ITS CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

find_package(PkgConfig QUIET)
pkg_check_modules(LIBSECRET libsecret-1)

set(VERSION_OK TRUE)
if(LIBSECRET_VERSION)
  if(LIBSECRET_FIND_VERSION_EXACT)
    if(NOT ("${LIBSECRET_FIND_VERSION}" VERSION_EQUAL "${LIBSECRET_VERSION}"))
      set(VERSION_OK FALSE)
    endif()
  else()
    if("${LIBSECRET_VERSION}" VERSION_LESS "${LIBSECRET_FIND_VERSION}")
      set(VERSION_OK FALSE)
    endif()
  endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  Libsecret
  REQUIRED_VARS LIBSECRET_INCLUDE_DIRS LIBSECRET_LIBRARIES VERSION_OK
  FOUND_VAR LIBSECRET_FOUND)
