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

ifeq ($(CLUSTER), x64_cygwin)
    BUILDFLAGS     += -D__NON_STD_TCL_INSTALL
    TCL_BASE       = $(OPEN_SOFTWARE_BINARIES_TOPLEVEL)/tcltk-8.6.4
    TK_BASE        = $(OPEN_SOFTWARE_BINARIES_TOPLEVEL)/tcltk-8.6.4
    TCLTK_INCDIR   = -I$(TCL_BASE)/include -I$(TK_BASE)/include
    TCLTK_LIBDIR   = $(LIBPATH_COMPILER_FLAG)$(TCL_BASE)/lib $(LIBPATH_COMPILER_FLAG)$(TK_BASE)/lib
    TCLTK_DLLS     = $(TCL_BASE)/bin/tcl86.$(SOEXT) $(TCL_BASE)/bin/tk86.$(SOEXT)
    TCLTK_LIBS     = $(TCLTK_LIBDIR) \
                     $(LIBFLAG)tcl86$(LIBLINKEXT) $(LIBFLAG)tk86$(LIBLINKEXT) \
                     $(LIBFLAG)user32$(LIBLINKEXT) $(LIBFLAG)advapi32$(LIBLINKEXT) \
                     $(LIBFLAG)gdi32$(LIBLINKEXT)  $(LIBFLAG)comdlg32$(LIBLINKEXT) \
                     $(LIBFLAG)imm32$(LIBLINKEXT)  $(LIBFLAG)comctl32$(LIBLINKEXT) \
                     $(LIBFLAG)shell32$(LIBLINKEXT) $(LIBFLAG)Shlwapi$(LIBLINKEXT)
    # Shlwapi was added to make mingw32 compile happy
    TCLTK_LIBS     +=$(LIBFLAG)Shlwapi$(LIBLINKEXT)
    TKCXIMAGE_BASE = $(OPEN_SOFTWARE_BINARIES_TOPLEVEL)/tkcximage-0.98.9/tcltk-8.6.4
    TKCXIMAGE_DLL  = $(TKCXIMAGE_BASE)/bin/Tkcximage.$(SOEXT)
    TCLTK_SO_PATH  = $(TCL_BASE)/bin
    TCL_LIBRARY    = $(TCL_BASE)/lib/tcl8.6
    TK_LIBRARY     = $(TCL_BASE)/lib/tk8.6
    TCLSH          = $(TCL_BASE)/bin/tclsh86.exe
endif
