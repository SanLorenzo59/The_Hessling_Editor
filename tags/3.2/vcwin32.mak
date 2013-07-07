#
#########################################################################
#
# makefile for The Hessling Editor (THE)
#
#########################################################################
#
# You need the following environment variables set like:
# THE_SRCDIR=c:\the
# PDCURSES_SRCDIR=c:\pdcurses
# PDCURSES_BINDIR=c:\pdc\vc
# If building with Regina...
#   REGINA_BINDIR=c:\regina\vc
#   REGINA_SRCDIR=c:\regina
# If building with Object Rexx...
#   OREXX_BINDIR=c:\objrexx\api
# If building with Rexx/Trans...
#   REXXTRANS_BINDIR=c:\rexxtrans
#   REXXTRANS_SRCDIR=c:\rexxtrans
# If building with WinRexx...
#   WINREXX_BINDIR=c:\winrexx
#   WINREXX_SRCDIR=c:\winrexx
# If building with Quercus Rexx...
#   QUERCUS_BINDIR=c:\quercus
#   QUERCUS_SRCDIR=c:\quercus
# If building with uni-Rexx...
#   UNIREXX_BINDIR=c:\unirexx
#   UNIREXX_SRCDIR=c:\unirexx
#
# MSVCDIR=c:\program files\microsoft visual studio\vc98
#
#########################################################################
#

#
# Use STATIC linking to PDCurses ?????
# Using the PDCurses DLL, then "the -1" will refresh the newly edited
# file correctly. The STATIC linking will NOT refresh the newly edited
# file correctly; you will need to hit a key for it to refresh.
#
!if "$(STATIC)" == "Y"
PDCURSES_LIB=pdcurses.lib
PDCURSES_DEFINES=
CURSESDLLINNSIS=
!else
PDCURSES_LIB=curses.lib
PDCURSES_DEFINES=-DPDC_DLL_BUILD
CURSESDLLINNSIS=/DCURSESDLL
STATIC=N
!endif

SRC       = $(THE_SRCDIR)
CURSBIN   = $(PDCURSES_BINDIR)
REXXTRANSBIN = c:\bin
CURSINC   = -I$(PDCURSES_SRCDIR) $(PDCURSES_DEFINES)
SETARGV   = "$(MSVCDIR)\lib\setargv.obj"
REGINA_BIN = $(REGINA_BINDIR)
REGINA_REXXLIBS = $(REGINA_BIN)\regina.lib
REGINA_REXXINC = -I$(REGINA_SRCDIR) -DUSE_REGINA
OREXX_REXXLIBS = $(OREXX_BINDIR)\api\rexx.lib $(OREXX_BINDIR)\api\rexxapi.lib
OREXX_REXXINC = -I$(OREXX_BINDIR)\api -DUSE_OREXX
WINREXX_REXXLIBS = $(WINREXX_BINDIR)\api\rxrexx.lib
WINREXX_REXXINC = -I$(WINREXX_BINDIR)\api -DUSE_WINREXX
QUERCUS_REXXLIBS = $(QUERCUS_BINDIR)\api\wrexx32.lib
QUERCUS_REXXINC = -I$(QUERCUS_BINDIR)\api -DUSE_QUERCUS
UNIREXX_REXXLIBS = $(UNIREXX_BINDIR)\rxx.lib
UNIREXX_REXXINC = -I$(UNIREXX_BINDIR) -DUSE_UNIREXX
REXXTRANS_REXXLIBS = $(REXXTRANS_BINDIR)\rexxtrans.lib
REXXTRANS_REXXINC = -I$(REXXTRANS_SRCDIR) -DUSE_REXXTRANS

#
# Following included file provides VER, VER_DOT, VER_DATE
#
!include $(SRC)\the.ver

#########################################################################
# MS VC++ compiler on Win32
#########################################################################
PROJ      = the.exe
OBJ       = obj
CC        = cl

!if "$(INT)" == "REGINA"
REXXLIB = $(REGINA_REXXLIBS)
REXXINC =  $(REGINA_REXXINC)
!elseif "$(INT)" == "OREXX"
REXXLIB = $(OREXX_REXXLIBS)
REXXINC =  $(OREXX_REXXINC)
!elseif "$(INT)" == "WINREXX"
REXXLIB = $(WINREXX_REXXLIBS)
REXXINC =  $(WINREXX_REXXINC)
!elseif "$(INT)" == "QUERCUS"
REXXLIB = $(QUERCUS_REXXLIBS)
REXXINC =  $(QUERCUS_REXXINC)
!elseif "$(INT)" == "UNIREXX"
REXXLIB = $(UNIREXX_REXXLIBS)
REXXINC =  $(UNIREXX_REXXINC)
!elseif "$(INT)" == "REXXTRANS"
REXXLIB = $(REXXTRANS_REXXLIBS)
REXXINC =  $(REXXTRANS_REXXINC)
!else
!message Rexx Interpreter NOT specified via INT macro
!message Valid values are: REGINA OREXX WINREXX QUERCUS UNIREXX REXXTRANS
!error Make aborted!
!endif

!if "$(TRACE)" == "Y"
TRACE_FLAGS = -DTHE_TRACE
TRACE_OBJ = trace.obj
!else
TRACE_FLAGS =
TRACE_OBJ =
TRACE=N
!endif

!if "$(DEBUG)" == "Y"
CFLAGS    = -nologo -c -Od -Z7 -FR -DDEBUG -DWIN32 -DSTDC_HEADERS -DHAVE_PROTO $(TRACE_FLAGS) -I$(SRC) $(CURSINC) $(REXXINC) -Fo$@
LDEBUG     = -debug /map
CURSLIB   = $(CURSBIN)\$(PDCURSES_LIB)
DIST=
!else
CFLAGS    = -nologo -c -Ox -DWIN32 -DSTDC_HEADERS -DHAVE_PROTO $(TRACE_FLAGS) -I$(SRC) $(CURSINC) $(REXXINC) -Fo$@
LDEBUG     = -release
CURSLIB   = $(CURSBIN)\$(PDCURSES_LIB)
DEBUG=N
!if "$(INT)" == "REXXTRANS"
DIST=dist
!else
DIST=
!endif
!endif

LD        = link
XTRAOBJ   = mygetopt.obj
MAN       = manext.exe
THERC     = $(SRC)\thew32.rc
THERES    = thew32.res
THEW32OBJ = thew32.obj
docdir = doc
#########################################################################
#
#
# Object files
#
OBJ1 = box.obj colour.obj comm1.obj comm2.obj comm3.obj comm4.obj comm5.obj \
	commset1.obj commset2.obj commsos.obj cursor.obj default.obj \
	edit.obj error.obj execute.obj linked.obj column.obj mouse.obj memory.obj \
	nonansi.obj prefix.obj reserved.obj scroll.obj show.obj single.obj sort.obj \
	target.obj the.obj util.obj parser.obj regex.obj
OBJ2 = commutil.obj print.obj $(TRACE_OBJ)
OBJ3 = getch.obj
OBJ4 = query.obj query1.obj query2.obj
OBJ5 = thematch.obj
OBJ6 = directry.obj file.obj
OBJ7 = rexx.obj
OBJ8 =
OBJX = $(XTRAOBJ)
OBJS = $(OBJ1) $(OBJ2) $(OBJ3) $(OBJ4) $(OBJ5) $(OBJ6) $(OBJ7) $(OBJ8) $(OBJX)
#########################################################################

COMM = $(SRC)\comm1.c $(SRC)\comm2.c $(SRC)\comm3.c $(SRC)\comm4.c $(SRC)\comm5.c \
	$(SRC)\commsos.c $(SRC)\commset1.c $(SRC)\commset2.c $(SRC)\query.c

APPENDIX = $(SRC)\appendix.1
GLOSSARY = $(SRC)\glossary

all: how the.exe $(DIST)

how:
	echo nmake -f $(SRC)\vcwin32.mak INT=$(INT) DEBUG=$(DEBUG) TRACE=$(TRACE) STATIC=$(STATIC) %1 %2 > rebuild.bat
#
#########################################################################
the.exe:	$(OBJS) $(THERES) $(THEW32OBJ)
	$(LD) /NOLOGO /VERSION:$(VER_DOT) $(LDEBUG) $(OBJS) $(THEOBJ) $(THEW32OBJ) $(SETARGV) -out:the.exe $(CURSLIB) $(REXXLIB) user32.lib gdi32.lib comdlg32.lib winspool.lib wsock32.lib shell32.lib advapi32.lib kernel32.lib
#########################################################################
box.obj:	$(SRC)\box.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
colour.obj:	$(SRC)\colour.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
comm1.obj:	$(SRC)\comm1.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
comm2.obj:	$(SRC)\comm2.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
comm3.obj:	$(SRC)\comm3.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
comm4.obj:	$(SRC)\comm4.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
comm5.obj:	$(SRC)\comm5.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
commset1.obj:	$(SRC)\commset1.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
commset2.obj:	$(SRC)\commset2.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
commsos.obj:	$(SRC)\commsos.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
cursor.obj:	$(SRC)\cursor.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
default.obj:	$(SRC)\default.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
edit.obj:	$(SRC)\edit.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
error.obj:	$(SRC)\error.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
execute.obj:	$(SRC)\execute.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
linked.obj:	$(SRC)\linked.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
column.obj:	$(SRC)\column.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
mouse.obj:	$(SRC)\mouse.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
memory.obj:	$(SRC)\memory.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
nonansi.obj:	$(SRC)\nonansi.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
prefix.obj:	$(SRC)\prefix.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
regex.obj:	$(SRC)\regex.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
alloca.obj:	$(SRC)\alloca.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
parser.obj:	$(SRC)\parser.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
print.obj:	$(SRC)\print.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
reserved.obj:	$(SRC)\reserved.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
scroll.obj:	$(SRC)\scroll.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
show.obj:	$(SRC)\show.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
single.obj:	$(SRC)\single.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
sort.obj:	$(SRC)\sort.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
target.obj:	$(SRC)\target.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
the.obj:	$(SRC)\the.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h $(SRC)\the.ver
	$(CC) $(CFLAGS) -DTHE_VERSION=\"$(VER_DOT)\" -DTHE_VERSION_DATE=\"$(VER_DATE)\" $(SRC)\$*.c
util.obj:	$(SRC)\util.c $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
commutil.obj:	$(SRC)\commutil.c $(SRC)\the.h $(SRC)\command.h $(SRC)\thedefs.h $(SRC)\proto.h $(SRC)\getch.h $(SRC)\key.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
trace.obj:	$(SRC)\trace.c $(SRC)\the.h $(SRC)\command.h $(SRC)\thedefs.h $(SRC)\proto.h $(SRC)\getch.h $(SRC)\key.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
getch.obj:	$(SRC)\getch.c $(SRC)\getch.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
query.obj:	$(SRC)\query.c $(SRC)\query.h $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
query1.obj:	$(SRC)\query1.c $(SRC)\query.h $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
query2.obj:	$(SRC)\query2.c $(SRC)\query.h $(SRC)\the.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
thematch.obj:	$(SRC)\thematch.c $(SRC)\the.h $(SRC)\thematch.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
directry.obj:	$(SRC)\directry.c $(SRC)\the.h $(SRC)\directry.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
file.obj:	$(SRC)\file.c $(SRC)\the.h $(SRC)\directry.h $(SRC)\thedefs.h $(SRC)\proto.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
rexx.obj:	$(SRC)\rexx.c $(SRC)\the.h $(SRC)\therexx.h $(SRC)\proto.h $(SRC)\thedefs.h $(SRC)\query.h
	$(CC) $(CFLAGS) $(SRC)\$*.c
mygetopt.obj:	$(SRC)\mygetopt.c
	$(CC) $(CFLAGS) $(SRC)\$*.c

$(THERES) $(THEW32OBJ): $(THERC)
	copy $(SRC)\thewin.ico
	rc /r /fo$(THERES) /i$(SRC) $(THERC)
	cvtres /MACHINE:IX86 /NOLOGO /OUT:$(THEW32OBJ) $(THERES)
#
#########################################################################
manual:	$(MAN) $(SRC)\overview $(COMM) $(APPENDIX) $(GLOSSARY)
	manext $(SRC)\overview $(COMM) $(APPENDIX) $(GLOSSARY) > the.man
#
$(MAN):	$(XTRAOBJ) manext.$(OBJ)
	$(MANLD)
	$(CHMODMAN)


zip:
	zip thesrc$(VER) README INSTALL TODO COPYING HISTORY THE_Help.txt
	zip thesrc$(VER) overview appendix.1 appendix.2 appendix.3 glossary README.OS2
	zip thesrc$(VER) box.c colour.c comm*.c cursor.c default.c directry.c
	zip thesrc$(VER) edit.c error.c norexx.c scroll.c column.c execute.c
	zip thesrc$(VER) file.c thematch.c getch.c mygetopt.c linked.c mouse.c memory.c
	zip thesrc$(VER) nonansi.c os2eas.c prefix.c query.c reserved.c print.c
	zip thesrc$(VER) rexx.c show.c single.c sort.c target.c the.c trace.c util.c
	zip thesrc$(VER) command.h thedefs.h directry.h thematch.h getch.h vars.h
	zip thesrc$(VER) key.h query.h proto.h therexx.h the.h makefile.dist $(docdir)/*.gif
	zip thesrc$(VER) manext.c *.rc *.rsp *.def *.ico *.diz files.rcs the*.xbm icons.zip the.res the.rc the.eas
	zip thesrc$(VER) append.the comm.the uncomm.the total.the match.the rm.the
	zip thesrc$(VER) words.the l.the compile.the spell.the demo.the demo.txt
	zip thesrc$(VER) Makefile.in configure config.h.in $(docdir)/THE_Help*
	zip thesrc$(VER) vcwin32.mak wccwin32.mak
	zip thesrc$(VER) config.guess config.sub install-sh
	zip thesrc$(VER) aclocal.m4 configure.in
	zip thesrc$(VER) man2html.rex
#

dist:
	-mkdir tmpdir
	cd tmpdir
	-del /Q *.*
	copy ..\the.exe .
	copy $(SRC)\*.the .
	copy $(SRC)\*.tld .
	copy $(SRC)\README .
	copy $(SRC)\COPYING .
	copy $(SRC)\HISTORY .
	copy $(SRC)\TODO .
	copy $(REXXTRANSBIN)\rexxtrans.dll .
	copy $(SRC)\THE_Help.txt .
	copy $(SRC)\demo.txt .
	copy $(SRC)\win32.diz file_id.diz
	copy $(SRC)\doc\THE-$(VER_DOT).pdf THE.pdf
	the -b -p $(SRC)\fix.diz -a "$(VER) $(VER_DOT) T any available Rexx interpreter" file_id.diz
	zip the$(VER)w32 *
	copy $(SRC)\the.nsi .
	makensis $(CURSESDLLINNSIS) /DVERSION=$(VER_DOT) /DNODOTVER=$(VER) /DSRCDIR=$(SRC) the.nsi
	cd ..
