;
; THE Install Script, based on Modern Example Script Written by Joost Verburg
; Requires: ${NSISDIR}\Contrib\Path\path.nsi
; Run as:
;  makensis /DVERSION=x.x /DNODOTVER=xx the.nsi
; Note:
;  the.nsi MUST be in the current directory!

!define LONGNAME "The Hessling Editor"  ;Long Name (for descriptions)
!define SHORTNAME "THE" ;Short name (no slash) of package

Name "${LONGNAME} ${VERSION}"

!define MUI_ICON "${SRCDIR}\thewin.ico"
!define MUI_UNICON "${SRCDIR}\thewinun.ico"

!include "MUI.nsh"
!include "Library.nsh"

!define MUI_CUSTOMPAGECOMMANDS

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

Var ALREADY_INSTALLED

;Modern UI System

; VERSION  ;Must be supplied on compile command line
; NODOTVER ;Must be supplied on compile command line

;--------------------------------
;Configuration

  ;General
  OutFile "${SHORTNAME}${NODOTVER}.exe"
  ShowInstdetails show
  SetOverwrite on


  ;License dialog
  LicenseData "COPYING"


  ;Folder-select dialog
  InstallDir "c:\${SHORTNAME}"

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_LICENSE "COPYING"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Language
!insertmacro MUI_LANGUAGE "English"

;========================================================================
;Installer Sections

;------------------------------------------------------------------------
; Core

Section "${LONGNAME} Core (required)" SecMain
  SectionIn 1 RO
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  ; add the shared DLL; rexxtrans.dll BEFORE installing the.exe
  ; so that we don't get a false positive that we have already installed the
  ; application
  ; install rexxtrans.dll in $SYSDIR
  IfFileExists "$INSTDIR\the.exe" 0 new_installation
    StrCpy $ALREADY_INSTALLED 1
  new_installation:
  !insertmacro InstallLib DLL $ALREADY_INSTALLED REBOOT_NOTPROTECTED rexxtrans.dll $SYSDIR\rexxtrans.dll $SYSDIR
  ; Distribution files...
  File the.exe
  File rexxtrans.dll
  !ifdef CURSESDLL
  File curses.dll
  !endif
  File COPYING
  File HISTORY
  File THE_Help.txt
  CreateDirectory "$SMPROGRAMS\${SHORTNAME}"
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\HISTORY.lnk" "$INSTDIR\the.exe" "$INSTDIR\HISTORY" "$INSTDIR\the.exe"
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\LICENSE.lnk" "$INSTDIR\the.exe" "$INSTDIR\LICENSE" "$INSTDIR\the.exe"
  ; Can't use CreateShortcut for URLs
  WriteINIStr "$SMPROGRAMS\${SHORTNAME}\THE Home Page.url" "InternetShortcut" "URL" "http://hessling-editor.sourceforge.net"
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORTNAME}" "DisplayName" "${LONGNAME} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORTNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "$INSTDIR\uninstall.exe"
  ; add install directory to PATH
  DetailPrint "Adding $INSTDIR to PATH"
  Push "$INSTDIR"
  Push "false"
  Call AddToPath
  ; set env variables
  DetailPrint "Setting THE_HOME_DIR to $INSTDIR"
  Push "THE_HOME_DIR"
  Push "$INSTDIR"
  Call WriteEnvStr
  DetailPrint "Setting THE_MACRO_PATH to $INSTDIR\extras"
  Push "THE_MACRO_PATH"
  Push "$INSTDIR\extras"
  Call WriteEnvStr
  DetailPrint "Setting THE_HELP_FILE to $INSTDIR\THE_Help.txt"
  Push "THE_HELP_FILE"
  Push "$INSTDIR\THE_Help.txt"
  Call WriteEnvStr
SectionEnd

;------------------------------------------------------------------------
; Language Definition Files

Section "${LONGNAME} Language Definition Files" SecDemo
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\extras
  File *.tld
SectionEnd

;------------------------------------------------------------------------
; Sample Macros

Section "${LONGNAME} Sample Macros" SecDev
  CreateDirectory "$SMPROGRAMS\${SHORTNAME}\Sample Profiles"
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\extras
  ; Distribution files...
  File append.the
  File build.the
  File codecomp.the
  File comm.the
  File compile.the
  File config.the
  File cua.the
  File demo.the
  File diff.the
  File l.the
  File match.the
  File mhprf.the
  File nl.the
  File rm.the
  File spell.the
  File tags.the
  File total.the
  File uncomm.the
  File words.the
  File xeditprf.the
  File demo.txt
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\Sample Profiles\XEDIT Profile.lnk" "$INSTDIR\the.exe" '-p "$INSTDIR\extras\xeditprf.the" "$INSTDIR\extras\xeditprf.the"' "$INSTDIR\the.exe"
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\Sample Profiles\CUA Profile.lnk" "$INSTDIR\the.exe" '-p "$INSTDIR\extras\cua.the" "$INSTDIR\extras\cua.the"' "$INSTDIR\the.exe"
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\Sample Profiles\Authors Profile.lnk" "$INSTDIR\the.exe" '-p "$INSTDIR\extras\mhprf.the" "$INSTDIR\extras\mhprf.the"' "$INSTDIR\the.exe"
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\Sample Profiles\THE Demo.lnk" "$INSTDIR\the.exe" '-p "$INSTDIR\extras\demo.the" "$INSTDIR\extras\demo.txt"' "$INSTDIR\the.exe"
SectionEnd

;------------------------------------------------------------------------
; Doco

Section "${LONGNAME} Documentation" SecDoc
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR\doc
  File THE.pdf
;  File ..\doc\*.html
;  File ..\doc\logo1.jpg
  CreateShortCut "$SMPROGRAMS\${SHORTNAME}\${SHORTNAME} PDF Documentation.lnk" "$INSTDIR\doc\THE.pdf" "" "$INSTDIR\doc\THE.pdf" 0
SectionEnd


Section ""

  ;Invisible section to display the Finish header
; !insertmacro MUI_FINISHHEADER

SectionEnd

;========================================================================
;Installer Functions

Function .onMouseOverSection

  !insertmacro MUI_DESCRIPTION_BEGIN

    !insertmacro MUI_DESCRIPTION_TEXT ${SecMain} "Installs the core components of ${LONGNAME} to the application folder."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDemo} "Installs extra language definition files."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDev} "Install sample ${LONGNAME} macros."
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDoc} "Install ${LONGNAME} documentation."

 !insertmacro MUI_DESCRIPTION_END

FunctionEnd

;========================================================================
;Uninstaller Section

Section "Uninstall"
  Push $INSTDIR
  Push "false"
  Call un.RemoveFromPath
  DeleteRegKey HKCR "${SHORTNAME}"
  ; deincrement rexxtrans.dll and delete if necessary
  !insertmacro UnInstallLib DLL SHARED REBOOT_NOTPROTECTED $SYSDIR\rexxtrans.dll
  ; remove environment variables
  Push "THE_MACRO_PATH"
  Call un.DeleteEnvStr
  Push "THE_HELP_FILE"
  Call un.DeleteEnvStr
  Push "THE_HOME_DIR"
  Call un.DeleteEnvStr

  RMDir /r "$INSTDIR"

  ; Remove the installation stuff
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SHORTNAME}"
  DeleteRegKey HKLM "SOFTWARE\${LONGNAME}"

  ; remove shortcuts directory and everything in it
  RMDir /r "$SMPROGRAMS\${SHORTNAME}"

; !insertmacro MUI_UNFINISHHEADER

SectionEnd

;========================================================================
;Uninstaller Functions

!include "${SRCDIR}\common\isnt.nsh"
!include "${SRCDIR}\common\path.nsh"
!include "${SRCDIR}\common\WriteEnv.nsh"

;eof
