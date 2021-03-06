# Copyright (c) Stanford University, The Regents of the University of
#               California, and others.
#
# All Rights Reserved.
#
# See Copyright-SimVascular.txt for additional details.
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

set(lib ${SV_LIB_MESHSIM_ADAPTOR_NAME})
set(export_directive meshsim_adaptor)
set(export_file_name svMeshSimAdaptorExports.h)

list(APPEND CORELIBS ${lib})
include_directories(${SV_SOURCE_DIR}/FlowSolvers/ThreeDSolver/SolverIO/)
include_directories(${FLOWSOLVER_OPTIONS_HEADER_PATH})

set(HDRS cvMeshSimAdapt.h cvAdaptHelp.h)
SET(CXXSRCS cvMeshSimAdapt.cxx)

add_definitions("-DSV_EXPORT_MESHSIM_ADAPTOR_COMPILE")

if(SV_USE_MESHSIM_SHARED_LIBRARIES)
  add_library(${lib} SHARED ${CXXSRCS} cv_meshsim_adapt_init.cxx cv_meshsim_adapt_init_py.cxx)
else()
  add_library(${lib} STATIC ${CXXSRCS} cv_meshsim_adapt_init.cxx cv_meshsim_adapt_init_py.cxx)
endif()

if(SV_USE_PYTHON)
  target_link_libraries(${lib} ${PYTHON_LIBRARY})
endif()

target_link_libraries(${lib}
	${VTK_LIBRARIES}
	${TCL_LIBRARY} ${TK_LIBRARY}
	${INTELRUNTIME_LIBRARIES}
	${SV_LIB_ADAPTOR_NAME})

if(SV_USE_PARASOLID)
	target_link_libraries(${lib} ${SV_LIB_PARASOLID_SOLID_NAME})
endif()

# Set up for exports
string(TOUPPER ${export_directive} EXPORT_NAME)
set(_export_macro_names
  EXPORT_MACRO_NAME SV_EXPORT_${EXPORT_NAME}
  NO_EXPORT_MACRO_NAME SV_EXPORT_${EXPORT_NAME}_NO_EXPORT
  DEPRECATED_MACRO_NAME SV_EXPORT_${EXPORT_NAME}_DEPRECATED
  NO_DEPRECATED_MACRO_NAME SV_EXPORT_${EXPORT_NAME}_NO_DEPRECATED
  )

# Generate export headers
generate_export_header(${lib}
  ${_export_macro_names}
  EXPORT_FILE_NAME ${export_file_name})

if(NOT SV_DISTRIBUTE_COMPONENTS STREQUAL OpenSource)
  if(SV_INSTALL_LIBS)
    install(TARGETS ${lib}
      RUNTIME DESTINATION ${SV_INSTALL_RUNTIME_DIR} COMPONENT LicensedExecutables
      LIBRARY DESTINATION ${SV_INSTALL_LIBRARY_DIR} COMPONENT LicensedLibraries
      ARCHIVE DESTINATION ${SV_INSTALL_ARCHIVE_DIR} COMPONENT LicensedLibraries
      )
  endif()
  if(SV_INSTALL_HEADERS)
    install(FILES ${HDRS} ${CMAKE_CURRENT_BINARY_DIR}/${export_file_name}
      DESTINATION ${SV_INSTALL_INCLUDE_DIR}/core COMPONENT LicensedHeaders
      )
  endif()
endif()


