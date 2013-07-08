%define debug_package %{nil}
Summary: The Hessling Editor
%if "%{myrexx}" == "none"
Name: THE
%else
Name: THE-%{mycurses}-%{myrexx}
%endif
Version: %{myversion}
Release: 1
License: GPL
Group: Applications/Editors
Source: THE-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-root
Vendor: Mark Hessling
Packager: Mark Hessling
URL: http://hessling-editor.sourceforge.net
Prefix: /usr
Icon: the64.xpm
Provides: %{name}
%if "%{myrexx}" == "regina"
Conflicts: THE-X11-oorexx THE-ncurses-oorexx THE-X11-rexxtrans THE-ncurses-rexxtrans
%endif
%if "%{myrexx}" == "oorexx"
Conflicts: THE-X11-regina THE-ncurses-regina THE-X11-rexxtrans THE-ncurses-rexxtrans
%endif
%if "%{myrexx}" == "rexxtrans"
Conflicts: THE-X11-regina THE-ncurses-regina THE-X11-oorexx THE-ncurses-oorexx
%endif
Requires: THE-common
%description
THE is a text editor based on the VM/CMS editor
XEDIT and many features of KEDIT written by Mansfield Software.

THE uses Rexx as its macro language which provides a rich and powerful
capability to extend THE.

%if "%{mycurses}" == "ncurses"
This port executes in text mode and can be run from within an xterm window
or over a telnet connection. It requires ncurses to function.
%endif
%if "%{mycurses}" == "ncursesw"
This port executes in text mode and can be run from within an xterm window
or over a telnet connection. It requires ncursesw to function and supports
files encoded in UTF-8.
%endif
%if "%{mycurses}" == "X11"
This port is a native X11 application.
%endif
%if "%{mycurses}" == "X11w"
This port is a native X11 application and suports files encoded in UTF8.
XCurses to function.
%endif
%if "%{mycurses}" == "dwindows"
This port is a native Dynamic Windows GUI application, and requires Dynamic Windows
to function.
%endif
For more information on THE, visit http://hessling-editor.sourceforge.net/

For more information on Rexx, visit http://www.rexxla.org

%package -n THE-common
Summary: The Hessling Editor Common
Group: Applications/Editors
%description -n THE-common
This package provides an executable which invokes either the text-mode or GUI version
of THE together with sample macros and syntax files.

For more information on THE, visit http://hessling-editor.sourceforge.net/

For more information on Rexx, visit http://www.rexxla.org

%package -n THE-doc
Summary: The Hessling Editor Documentation
Group: Applications/Editors
BuildArch: noarch
%description -n THE-doc
This package contains the documentation for THE; The Hessling Editor

THE is a full-screen character mode text editor based on the VM/CMS editor
XEDIT and many features of KEDIT written by Mansfield Software.

THE uses Rexx as its macro language which provides a rich and powerful
capability to extend THE.

For more information on THE, visit http://hessling-editor.sourceforge.net/

For more information on Rexx, visit http://www.rexxla.org

%if 0%{?suse_version} > 910
%define mydocdir %{prefix}/share/doc/packages/%{name}
%else
%if 0%{?mdkversion} > 2006
%define mydocdir %{prefix}/share/doc/%{name}
%else
%define mydocdir %{prefix}/share/doc/%{name}-%{version}
%endif
%endif

%prep
%setup -n THE-%{version}

%build
%if "%{mycurses}" == "ncurses"
./configure --prefix=%{prefix} --with-rexx=%{myrexx} --with-ncurses
make nthe the the.man THE_Help.txt helpviewer
%endif
%if "%{mycurses}" == "ncursesw"
./configure --prefix=%{prefix} --with-rexx=%{myrexx} --with-ncurses --enable-utf8
make nwthe
%endif
%if "%{mycurses}" == "X11"
./configure --prefix=%{prefix} --with-rexx=%{myrexx} --with-xcurses-static
make xthe
%endif
%if "%{mycurses}" == "X11w"
./configure --prefix=%{prefix} --with-rexx=%{myrexx} --with-xcurses-static --enable-utf8
make xwthe
%endif
%if "%{mycurses}" == "dwindows"
./configure --prefix=%{prefix} --with-rexx=%{myrexx} --with-dwindows
make dwthe
%endif

%install
rm -fr %{buildroot}
make DESTDIR=%{buildroot} installrpm installcommon installdoc

%files
%if "%{mycurses}" == "ncurses"
 %{_bindir}/nthe
%endif
%if "%{mycurses}" == "ncursesw"
 %{_bindir}/nwthe
%endif
%if "%{mycurses}" == "X11"
 %{_bindir}/xthe
%endif
%if "%{mycurses}" == "X11w"
 %{_bindir}/xwthe
%endif
%if "%{mycurses}" == "dwindows"
 %{_bindir}/dwthe
%endif

%post
cd %{_mandir}/man1
%if "%{mycurses}" == "ncurses"
ln -sf ./the.1.gz ./nthe.1.gz
%endif
%if "%{mycurses}" == "ncursesw"
ln -sf ./the.1.gz ./nwthe.1.gz
%endif
%if "%{mycurses}" == "X11"
ln -sf ./the.1.gz ./xthe.1.gz
%endif
%if "%{mycurses}" == "X11w"
ln -sf ./the.1.gz ./xwthe.1.gz
%endif
%if "%{mycurses}" == "dwindows"
ln -sf ./the.1.gz ./dwthe.1.gz
%endif

%preun
cd %{_mandir}/THE
if [ "$1" = 0 ] ; then
%if "%{mycurses}" == "ncurses"
   rm -f ./nthe.1.gz
%endif
%if "%{mycurses}" == "ncursesw"
   rm -f ./nwthe.1.gz
%endif
%if "%{mycurses}" == "X11"
   rm -f ./xthe.1.gz
%endif
%if "%{mycurses}" == "X11w"
   rm -f ./xwthe.1.gz
%endif
%if "%{mycurses}" == "dwindows"
   rm -f ./dwthe.1.gz
%endif
fi
exit 0

%files -n THE-common
 %{_bindir}/the
%doc %{_mandir}/man1/the.1.gz
%{_datadir}/THE


%files -n THE-doc
%doc COPYING
%doc README
%doc TODO
%doc index.html
%doc misc
%doc images
%doc commset
%doc commsos
%doc comm
