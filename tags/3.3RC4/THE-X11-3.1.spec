Summary: The Hessling Editor
Name: THE-X11
Version: 3.1
Release: 1
Copyright: 1991-2002 Mark Hessling
Distribution: GPL
Vendor: Mark Hessling
Packager: Mark Hessling
Group: Applications/Editors
Source: ftp://prdownloads.sourceforge.net/hessling-editor/THE-3.1.tar.gz
URL: http://hessling-editor.sourceforge.net
Icon: the64.xpm
Requires: RexxTrans, PDCurses

%description
THE is a full-screen character mode text editor based on the VM/CMS editor
XEDIT and many features of KEDIT written by Mansfield Software.

THE uses Rexx as its macro language which provides a rich and powerful
capability to extend THE.

This port is a native X11 application, and requires the X11 port of PDCurses;
XCurses to function.

For more information on THE, visit http://hessling-editor.sourceforge.net/

For more information on Rexx, visit http://www.rexxla.org

For more information on PDCurses, visit http://pdcurses.sourceforge.net/
%prep

%setup -n THE-3.1

%build
./configure --with-rexx=rexxtrans --with-xcurses
make xthe the.man THE_Help.txt helpviewer

%install
make install

%files
/usr/bin/xthe
/usr/man/man1/the.1
/usr/share/THE
%doc COPYING
%doc README
%doc TODO
%doc index.html
%doc misc
%doc images
%doc commset
%doc commsos
%doc comm

%post
echo ""
echo "The binary for THE has been installed as /usr/bin/xthe"
echo "to allow the ncurses binary 'nthe' to be installed concurrently."
echo "Create a symbolic link called 'the' to either 'xthe' or 'nthe'"
echo "depending on your preference."
echo ""
