
' READINI ( file, section, item )
' file = path and name of ini file
' section = [Section] must not be in brackets
' item = the variable to read

Function ReadIni(file, section, item)

  Set oFSO  = CreateObject("Scripting.FileSystemObject")
  ReadIni = ""
  file = Trim(file)
  item = Trim(item)
  If oFSO.FileExists( file ) Then
    Set ini = oFSO.OpenTextFile( file, 1, False)

    Do While ini.AtEndOfStream = False
      line = ini.ReadLine
      line = Trim(line)
      If LCase(line) = "[" & LCase(section) & "]" Then
        line = ini.ReadLine
        line = Trim(line)
        Do While Left( line, 1) <> "["
          'If InStr( 1, line, item & "=", 1) = 1 Then
          equalpos = InStr(1, line, "=", 1 )
          If equalpos > 0 Then
            leftstring = Left(line, equalpos - 1 )
            leftstring = Trim(leftstring)
            If LCase(leftstring) = LCase(item) Then
              ReadIni = Mid( line, equalpos + 1 )
              ReadIni = Trim(ReadIni)
              Exit Do
            End If
          End If

          If ini.AtEndOfStream Then Exit Do
          line = ini.ReadLine
          line = Trim(line)
        Loop
        Exit Do
      End If
    Loop
    ini.Close
  End If
End Function


dnetcId = ReadIni(Session.Property("TARGETDIR") + "dnetc.ini", "parameters", "id")
if dnetcId <> "" Then
  Session.Property("DNETC_PARTICIPANT_ID") = dnetcId
end if
