# Copyright (c) 2014-2015 The Regents of the University of California.
# All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#-----------------------------------------------------------------------------
# TK
set(proj TK)

# Dependencies
set(${proj}_DEPENDENCIES TCL)

# Source URL
set(SV_EXTERNALS_${proj}_MANUAL_SOURCE_URL "" CACHE STRING "Manual specification of ${proj}, can be web address or local path to tar file")
mark_as_advanced(SV_EXTERNALS_${proj}_MANUAL_SOURCE_URL)
if(NOT SV_EXTERNALS_${proj}_MANUAL_SOURCE_URL)
  set(SV_EXTERNALS_${proj}_SOURCE_URL "${SV_EXTERNALS_ORIGINALS_URL}/tcltk/tk${SV_EXTERNALS_${proj}_VERSION}-src.tar.gz")
else()
  set(SV_EXTERNALS_${proj}_SOURCE_URL "${SV_EXTERNALS_${proj}_MANUAL_SOURCE_URL}")
endif()

# Configure options
set(SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS
  --prefix=${SV_EXTERNALS_${proj}_BIN_DIR}
  --enable-threads
  --with-tcl=${SV_EXTERNALS_TCL_LIBRARY_DIR})
if(SV_EXTERNALS_ENABLE_${proj}_SHARED)
  set(SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS
    ${SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS}
    --enable-shared)
endif()

# Platform specific additions
if(APPLE)
  set(SV_EXTERNALS_${proj}_URL_EXTENSION unix)
  set(SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS
    ${SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS}
    --enable-corefoundation
    --enable-aqua)
elseif(LINUX)
  set(SV_EXTERNALS_${proj}_URL_EXTENSION unix)
  set(SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS
    ${SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS})
else()
  set(SV_EXTERNALS_${proj}_URL_EXTENSION win)
  set(SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS
    ${SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS}
    --enable-64bit)
endif()

# TK variables needed later on
if(SV_EXTERNALS_ENABLE_${proj}_SHARED)
  set(${proj}_LIBRARY_NAME libtk${SV_EXTERNALS_${proj}_MAJOR_VERSION}.${SV_EXTERNALS_${proj}_MINOR_VERSION}${CMAKE_SHARED_LIBRARY_SUFFIX})
else()
  set(${proj}_LIBRARY_NAME libtk${SV_EXTERNALS_${proj}_MAJOR_VERSION}.${SV_EXTERNALS_${proj}_MINOR_VERSION}${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

set(SV_EXTERNALS_WISH_EXECUTABLE ${SV_EXTERNALS_${proj}_BIN_DIR}/bin/wish${SV_EXTERNALS_${proj}_MAJOR_VERSION}.${SV_EXTERNALS_${proj}_MINOR_VERSION})
set(SV_EXTERNALS_${proj}_INCLUDE_DIR ${SV_EXTERNALS_${proj}_BIN_DIR}/include)
set(SV_EXTERNALS_${proj}_LIBRARY ${SV_EXTERNALS_${proj}_BIN_DIR}/lib/${${proj}_LIBRARY_NAME})
get_filename_component(SV_EXTERNALS_${proj}_LIBRARY_DIR ${SV_EXTERNALS_${proj}_LIBRARY} DIRECTORY)

# Special install rules
if(APPLE)
  set(SV_EXTERNALS_${proj}_CUSTOM_INSTALL make install
    COMMAND chmod -R u+w,a+rx ${SV_EXTERNALS_${proj}_BIN_DIR}
    COMMAND install_name_tool -id @rpath/${${proj}_LIBRARY_NAME} ${SV_EXTERNALS_${proj}_LIBRARY}
    COMMAND install_name_tool -change ${SV_EXTERNALS_TCL_LIBRARY} ${TCL_LIBRARY_NAME} ${SV_EXTERNALS_WISH_EXECUTABLE}
    COMMAND install_name_tool -change ${SV_EXTERNALS_${proj}_LIBRARY} ${${proj}_LIBRARY_NAME} ${SV_EXTERNALS_WISH_EXECUTABLE})
else()
  set(SV_EXTERNALS_${proj}_CUSTOM_INSTALL make install)
endif()

# Add external project
if(SV_EXTERNALS_DOWNLOAD_TCLTK)
  # Empty project
  ExternalProject_Add(${proj}
    URL ${SV_EXTERNALS_${proj}_BINARIES_URL}
    PREFIX ${SV_EXTERNALS_${proj}_PFX_DIR}
    SOURCE_DIR ${SV_EXTERNALS_${proj}_BIN_DIR}
    BINARY_DIR ${SV_EXTERNALS_${proj}_BLD_DIR}
    DEPENDS ${${proj}_DEPENDENCIES}
    DOWNLOAD_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    UPDATE_COMMAND ""
    )
else()
  ExternalProject_Add(${proj}
    URL ${SV_EXTERNALS_${proj}_SOURCE_URL}
    PREFIX ${SV_EXTERNALS_${proj}_PFX_DIR}
    SOURCE_DIR ${SV_EXTERNALS_${proj}_SRC_DIR}
    BINARY_DIR ${SV_EXTERNALS_${proj}_BLD_DIR}
    DEPENDS ${${proj}_DEPENDENCIES}
    CONFIGURE_COMMAND CC=${CMAKE_C_COMPILER} ${SV_EXTERNALS_${proj}_SRC_DIR}/${SV_EXTERNALS_${proj}_URL_EXTENSION}/configure -C ${SV_EXTERNALS_${proj}_CONFIGURE_OPTIONS}
    UPDATE_COMMAND ""
    )
endif()
