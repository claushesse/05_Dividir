;----------------------------------------------------------------------------------
; Written by ClausH.
;----------------------------------------------------------------------------------

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; Name of the subfolder in which to save the temporal files
TempDir = temp

; Name of the subfolder in which to save the final edited files
FinalDir = final

; set this to 1 to enable debug messages or 0 to disable them
showDebugMessages := 1

;src dir

;*******************************************
;** No need to change anything below here **
;*******************************************
music = %A_ScriptDir%\music.mp3
LogoVid = %A_ScriptDir%\logo.mp4
LogoImg = %A_ScriptDir%\logo.png
FilterScript = %A_ScriptDir%\scriptdividir.txt

if showDebugMessages
{
	; display a debug window at the top of the screen
	Gui +LastFound +AlwaysOnTop +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, cBlack
	Gui, Font, s12 
	Gui, Add, Text, vStatusText cLime, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	Gui, Add, Text, vStatusText2 cLime, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	Gui, Show,x100 y0 NoActivate,%A_ScriptName%  ; NoActivate avoids deactivating the currently active window.
	GuiControl,,StatusText,Please wait...
	GuiControl,,StatusText2,
}


Loop
{
	SrcDir = %A_ScriptDir% 
	VideoSrcDir := SrcDir . "\video"
	VideoTempDir := SrcDir . "\" . TempDir
	VideoDestDir := SrcDir . "\" . FinalDir

	
	IfExist,%VideoSrcDir% 
	{
     	
        Loop, %VideoSrcDir%\*.* 
        {
            DebugMessage(1, "Scanning " VideoSrcDir)

			ifExist, %VideoSrcDir%\*.mov
			{
				SrcFile = %A_LoopFileName%
				SrcFile = %A_LoopFileFullPath%

				TempConverted := VideoTempDir . "\" . RegExReplace(A_LoopFileName, "...$", "mp4") 
				TempProcessed := RegExReplace(TempConverted, "\."  , "-processed.") 
				DestFile :=  VideoDestDir . "\" . RegExReplace(A_LoopFileName, "...$", "mp4")

				ifNotExist,%TempConverted%
				{
					DebugMessage(1, "Converting " TempConverted )
					FileCreateDir, %VideoTempDir%
					runwait, ffmpeg -i "%SrcFile%" -c:v libx264 -crf 15 -preset slow -c copy "%TempConverted%" ,, hide
				}

				ifNotExist, %DestFile%
				{
					DebugMessage(1, "Processing to " DestFile)
					FileCreateDir, %VideoDestDir%

					runwait, ffmpeg -ss 0 -t 2 -i "%TempConverted%" -ss 2 -t 1 -i "%TempConverted%" -ss 3 -t 1 -i "%TempConverted%" -ss 4 -t 1 -i "%TempConverted%" -ss 5 -t 1 -i "%TempConverted%" -ss 6 -t 1 -i "%TempConverted%" -ss 7 -t 2 -i "%TempConverted%" -ss 9 -t 1 -i "%TempConverted%" -i "%LogoVid%" -i "%LogoImg%" -i "%music%" -filter_complex_script "%FilterScript%" -map [vid] -map [aud] -c:v libx264 -c:a aac -ac 2 -ar 44100 -ss 0 -t 13 "%DestFile%" ,, hide
					Sleep, 5000

					DebugMessage(1, "Done! file ready in " DestFile)
				}
			}

			ifExist, %VideoSrcDir%\*.mp4
			{
				SrcFile = %A_LoopFileName%
				SrcFile = %A_LoopFileFullPath%

				TempConverted := VideoTempDir . "\" . RegExReplace(A_LoopFileName, "...$", "mp4") 
				TempProcessed := RegExReplace(TempConverted, "\."  , "-processed.") 
				DestFile :=  VideoDestDir . "\" . RegExReplace(A_LoopFileName, "...$", "mp4")

				ifNotExist,%TempConverted%
				{
					DebugMessage(1, "Converting " TempConverted )
					FileCreateDir, %VideoTempDir%
					runwait, ffmpeg -i "%SrcFile%" -c:v libx264 -crf 15 -preset slow -c copy "%TempConverted%" ,, hide
				}

				ifNotExist, %DestFile%
				{
					DebugMessage(1, "Processing to " DestFile)
					FileCreateDir, %VideoDestDir%

					runwait, ffmpeg -ss 0 -t 2 -i "%TempConverted%" -ss 2 -t 1 -i "%TempConverted%" -ss 3 -t 1 -i "%TempConverted%" -ss 4 -t 1 -i "%TempConverted%" -ss 5 -t 1 -i "%TempConverted%" -ss 6 -t 1 -i "%TempConverted%" -ss 7 -t 2 -i "%TempConverted%" -ss 9 -t 1 -i "%TempConverted%" -i "%LogoVid%" -i "%LogoImg%" -i "%music%" -filter_complex_script "%FilterScript%" -map [vid] -map [aud] -c:v libx264 -c:a aac -ac 2 -ar 44100 -ss 0 -t 13 "%DestFile%" ,, hide
					Sleep, 5000

					DebugMessage(1, "Done! file ready in " DestFile)
				}
			}
        }
	}
	else
	{

	    DebugMessage(1, "Waiting for video files")
	}
    
    ; only run every second to avoid hogging the processor
    Sleep 1000
}

; Display a debug message if showDebugMessages = 1
; num specifies the line on which to display the message (1 or 2)
; msg is the message to display
DebugMessage(num, msg)
{
	global cStatusText, cStatusText2
	global showDebugMessages

	if msg
	{
		msg := A_Hour ":" A_Min ":" A_Sec ": " msg
	}
	if showDebugMessages
	{
		if num=1
		{
			GuiControl,,StatusText,%msg%
		}
		else
		{
			GuiControl,,StatusText2,%msg%
		}
	}
}
