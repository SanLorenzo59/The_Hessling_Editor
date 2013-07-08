/*
 * Extract documentation from a source file for a Rexx extension
 * documented with RoboDoc.
 * Produces a THE syntax file that can be :INCLUDEd in the THE
 * rexx.syntax file
 * Arguments:
 *  in - filename of C source file with embedded RoboDoc documentation
 *  out - filename of resulting syntax file
 *  package - Name of package
 *  keyword - value to be incuded in :KEYWORD directive in syntax file
 */
Parse Arg in out package keyword
state = 'ignore'
Call Stream out, 'C', 'OPEN WRITE REPLACE'
Call Lineout out, '* THE Function Syntax file for' package
Call Lineout out, ': KEYWORD' keyword
Do While Lines( in ) > 0
   line = Linein( in )
   Select
      When state = 'function' Then
         Do
            If Word( line, 1 ) = '******' Then
               Do
                  state = 'ignore'
                  Call Lineout out, header
                  Do i = 1 To idx
                     Call Lineout out, func.i
                  End
               End
            idx = idx + 1
            func.idx = '>'line
            If Word( line, 2 ) = 'SYNOPSIS' Then
               Do
                  line = Linein( in )
                  If Countstr( '=', line ) = 0 Then Parse Var line . header
                  Else Parse Var line . '=' header
                  header = Strip( header )
                  idx = idx + 1
                  func.idx = '>'line
               End
         End
      Otherwise
         Do
            If Word( line, 1 ) = '/****f*' Then /**/
               Do
                  state = 'function'
                  idx = 0
               End
         End
   End
End
Call Stream out, 'C', 'CLOSE'
