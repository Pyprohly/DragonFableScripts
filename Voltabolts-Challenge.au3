#include <Misc.au3> ; for _IsPressed()

; DragonFable_Dr.-Voltabolt’s-Challenge.au3

; Created by: /u/Pyprohly
; Script Version: 1.3
; Created on: Friday, 14 July 2017
; Last Modified: Friday, 20 July 2018
; Written for: Build 14.2.52

; Description:
; Automation script for the “You Need More Iron In Your Diet” (a.k.a., Dr. Voltabolt’s Challenge) quest.

; Instructions:
; Logon to DragonFable. When you run this script you will be instructed to click the top left then bottom
; right corners of the game frame. The script will immediately act afterwards. If your character is not
; at Dr. Voltabolt’s Challenge you will be taken to this location first.
;
; Customise the “PlayerTurn” function in this script to calibrate the battle sequence to your character’s
; skill set. Be sure to equip an Energy weapon.

; Note:
; Press F9 to terminate the script.
; AutoIt3's pixel colour inspection functions are not DPI aware! Make sure scaling is at 100% in
;+ the Windows ‘Display settings’.
; The script will automatically terminate if a scene change takes too long.

Local $bStopOnLevelUp = False

#cs
; Player Class: Mage
Func PlayerTurn()
   If IsSkillReady(4) Then
	  DoSkill(4) ; Sleep
   ElseIf IsSkillReady(7) Then
	  DoSkill(7) ; Power
   ElseIf IsSkillReady(11) Then
	  DoSkill(11) ; Energy
   ElseIf IsSkillReady(9) Then
	  DoSkill(9) ; Ice
   ElseIf IsSkillReady(8) Then
	  DoSkill(8) ; Fire
   ElseIf IsSkillReady(10) Then
	  DoSkill(10) ; Wind
   Else
	  DoAttack()
   EndIf
EndFunc
#ce

#cs
; Player Class: Warrior
Func PlayerTurn()
   If IsSkillReady(13) Then
	  DoSkill(13) ; Final
   ElseIf IsSkillReady(4) Then
	  DoSkill(4) ; Stun
   ElseIf IsSkillReady(6) Then
	  DoSkill(6) ; WarCry
   ElseIf IsSkillReady(0) Then
	  DoSkill(0) ; Power
   Else
	  DoAttack()
   EndIf
EndFunc
#ce

;~ #cs
; Player Class: Riftwalker (Warrior)
Func PlayerTurn()
   If IsSkillReady(4) Then
	  DoSkill(4) ; The X
   ElseIf IsSkillReady(6) Then
	  DoSkill(6) ; Imbue
   ElseIf IsSkillReady(13) Then
	  DoSkill(13) ; Final
   ElseIf IsSkillReady(0) Then
	  DoSkill(0) ; Power
   ElseIf IsSkillReady(7) Then
	  DoSkill(7) ; Combo
   ElseIf IsSkillReady(8) Then
	  DoSkill(8) ; Rift
   Else
	  DoAttack()
   EndIf
EndFunc
;~ #ce

;;; PlayerTurn() examples ;;;
; Note:
; * Press Ctrl-Q to toggle “;~” line comments in the SciTE editor.
; * $iTurn is 0 on the first turn.

; Example 1: use the leftmost skill every 5 turns if avaliable.
;~ Func PlayerTurn()
;~    If (Mod($iTurn, 5) = 0) And IsSkillReady(0) Then
;~ 	  DoSkill(0)
;~    Else
;~ 	  DoAttack()
;~    EndIf
;~ EndFunc

; Example 2: don’t use skill again after using it twice.
;~ Func PlayerTurn()
;~    Static $iHasDoneWarCry = 0

;~    If $iHasDoneWarCry <= 2 And IsSkillReady(6) Then
;~ 	  DoSkill(6) ; WarCry
;~ 	  $iHasDoneWarCry += 1
;~    ElseIf IsSkillReady(4) Then
;~ 	  DoSkill(4)
;~    Else
;~ 	  DoAttack(0)
;~    EndIf
;~ EndFunc

; Example 3: battle alongside 2 guests.
;~ Func PlayerTurn()
;~    $iNumGuests = 3

;~    If (Mod($iTurn, $iNumGuests) = 0) Then
;~ 	  ; it is the player’s turn
;~ 	  If IsSkillReady(0) Then
;~ 		 DoSkill(0)
;~ 	  Else
;~ 		 DoAttack()
;~ 	  EndIf
;~    ElseIf (Mod($iTurn, $iNumGuests) = 1) Then
;~ 	  ; it is the first guest’s turn
;~ 	  DoAttack()
;~    ElseIf (Mod($iTurn, $iNumGuests) = 2) Then
;~ 	  ; it is the second guest’s turn
;~ 	  DoAttack()
;~    EndIf
;~ EndFunc

Opt('MustDeclareVars', 1)

Func Quit()
   Exit
EndFunc

Func GetMouseCoordsOnClick($sToolTipMsg = 'Click somewhere', $sTitle = '', $iIcon = 0, $iOptions = 0, $bFollowCursor = False)
   ToolTip($sToolTipMsg, Default, Default, $sTitle, $iIcon, $iOptions)
   While 1
	  If $bFollowCursor Then
		 ToolTip($sToolTipMsg, Default, Default, $sTitle, $iIcon, $iOptions)
	  EndIf

	  If _IsPressed('01') Then
		 ToolTip('')
		 Sleep(250)
		 Return MouseGetPos()
	  EndIf
	  Sleep(50)
   WEnd
EndFunc

Func GetPosFromPercentage($aPosTopLeft, $aPosBottomRight, $fXPercent, $fYPercent)
   If Not ((0 <= $fXPercent And $fXPercent <= 1) Or (0 <= $fYPercent And $fYPercent <= 1))  Then
	  SetError(1, Default, 'Percentage value warning')
   EndIf

   Local $aPos[2]
   $aPos[0] = $aPosTopLeft[0] + ($aPosBottomRight[0] - $aPosTopLeft[0]) * $fXPercent
   $aPos[1] = $aPosTopLeft[1] + ($aPosBottomRight[1] - $aPosTopLeft[1]) * $fYPercent
   Return $aPos
EndFunc

Func IsInQuestLogInterface()
   Local $iInQuestLogInterface = 0
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.392680514342235, 0.255060728744939)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x276527 Then $iInQuestLogInterface += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.609297725024728, 0.352226720647773)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xA32727 Then $iInQuestLogInterface += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.778437190900099, 0.346828609986505)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x272746 Then $iInQuestLogInterface += 1
   If $iInQuestLogInterface = 3 Then Return True
   Return False
EndFunc

Func FastTravel($sLocation)
   Local $aLocations[][2] = [ _
	  ['Falconreach',    '0.625123639960435, 0.388663967611336'], _
	  ['Oaklore Keep',   '0.611275964391691, 0.427800269905533'], _
	  ["Warlic's Tent",  '0.621167161226508, 0.251012145748988'], _
	  ['The Necropolis', '0.675568743818002, 0.499325236167341'], _
	  ['Dragesvard',     '0.636003956478734, 0.141700404858326'] _
   ]

   Local $sCoords = ''
   For $i = 0 To UBound($aLocations) - 1
	  If $aLocations[$i][0] = $sLocation Then
		 $sCoords = $aLocations[$i][1]
		 ExitLoop
	  EndIf
   Next

   If $sCoords = '' Then
	  Return SetError(1)
   EndIf

   Local $aCoords = StringSplit($sCoords, ', ', 3)
   Local $fMapCoordX = $aCoords[0]
   Local $fMapCoordY = $aCoords[1]

   Local $aPos

   Local $bInTravelMapScene = False, $iInTravelMapScene = 0
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0573689416419387, 0.153846153846154)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x8C9C8B Then $iInTravelMapScene += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0929772502472799, 0.0472334682860999)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x698065 Then $iInTravelMapScene += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.345202769535114, 0.0539811066126856)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInTravelMapScene += 1
   If $iInTravelMapScene = 3 Then $bInTravelMapScene = True

   If Not $bInTravelMapScene Then
	  Local $bInOptionsInterface = False, $iInOptionsInterface = 0
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.176063303659743, 0.607287449392713)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0xDDB88B Then $iInOptionsInterface += 1
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.286844708209693, 0.685560053981107)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInOptionsInterface += 1
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.914935707220574, 0.136302294197031)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInOptionsInterface += 1
	  If $iInOptionsInterface = 3 Then $bInOptionsInterface = True

	  Local $bInQuestLogInterface = False
	  If IsInQuestLogInterface() Then
		 $bInQuestLogInterface = True
	  EndIf

	  Local $aClickPos
	  If Not $bInQuestLogInterface Then
		 If Not $bInOptionsInterface Then
			$aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.455, 0.982)
			MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Options"
			Sleep(200)
		 EndIf

		 $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.185, 0.9)
		 MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Home Town"
		 Sleep(500)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0919881305637982, 0.0566801619433198)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF Then
			$aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.492581602373887, 0.813765182186235)
			MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Back"
		 EndIf

		 $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.585, 0.898)
		 MouseClick('left', $aClickPos[0], $aClickPos[1]) ; open Quest Log
	  EndIf

	  ; assert scene change
	  Local $hTimer = TimerInit()
	  While 1
		 If IsInQuestLogInterface() Then
			ExitLoop
		 EndIf

		 If TimerDiff($hTimer) > 2000 Then
			Return SetError(1)
		 EndIf

		 Sleep(100)
	  WEnd
	  Local $hTimer

	  $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.387, 0.1322)
	  MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Book 1"
	  Sleep(200)

	  If $sLocation = 'Falconreach' Then
		 $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.302, 0.418)
		 MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Falconreach"
		 Sleep(2200)
		 MouseClick('left')
		 Sleep(300)
		 Return
	  EndIf

	  $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.302, 0.48)
	  MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Travel Map"

	  ; assert scene change -> Is in Travel Map scene
	  Local $bInTravelMapScene = False, $iInTravelMapScene = 0
	  Local $hTimer = TimerInit()
	  While Not $bInTravelMapScene
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0573689416419387, 0.153846153846154)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0x8C9C8B Then $iInTravelMapScene += 1
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0929772502472799, 0.0472334682860999)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0x698065 Then $iInTravelMapScene += 1
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.345202769535114, 0.0539811066126856)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInTravelMapScene += 1
		 If $iInTravelMapScene = 3 Then
			$bInTravelMapScene = True
		 Else
			$iInTravelMapScene = 0
		 EndIf

		 If TimerDiff($hTimer) > 6500 Then
			Return SetError(1)
		 EndIf

		 Sleep(100)
	  WEnd
	  Local $hTimer
   EndIf

   $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $fMapCoordX, $fMapCoordY)
   MouseClick('left', $aClickPos[0], $aClickPos[1])
   Sleep(200)

   $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.882, 0.751)
   MouseClick('left', $aClickPos[0], $aClickPos[1]) ; click "Take me there!"
   Sleep(2100)
EndFunc

Func IsOnInventoryInterface()
   ; close inventory/shop screen

   Local $iInInventoryInterface = 0
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0890207715133531, 0.461538461538462)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInInventoryInterface += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0593471810089021, 0.731443994601889)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFF5E Then $iInInventoryInterface += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0801186943620178, 0.179487179487179)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xE0B87C Then $iInInventoryInterface += 1

   Return $iInInventoryInterface = 3 ? True : False
EndFunc

Func CloseInventoryInterface()
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.320474777448071, 0.798920377867746)
   MouseClick('left', $aPos[0], $aPos[1])
   Sleep(400)
EndFunc

Func IsInTalkingWithVoltaboltScene()
   Local $bInTalkingWithVoltaboltScene = False, $iInTalkingWithVoltaboltScene = 0
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.284866468842733, 0.346828609986505)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x666666 Then $iInTalkingWithVoltaboltScene += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.160237388724036, 0.564102564102564)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x333333 Then $iInTalkingWithVoltaboltScene += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.928783382789317, 0.730094466936572)
   If PixelGetColor($aPos[0], $aPos[1]) = 0x62462B Then $iInTalkingWithVoltaboltScene += 1
   If $iInTalkingWithVoltaboltScene = 3 Then
	  $bInTalkingWithVoltaboltScene = True
   EndIf

   Return $bInTalkingWithVoltaboltScene
EndFunc

#Region "Battle scene functions"
Func IsPlayerTurn()
   Local $iAssert = 0

   Local $aPosTopLeft, $aPosBottomRight

   ; Check left side potion (HP) icon
   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0384995064165844, 0.730201342281879)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0750246791707799, 0.778523489932886)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0x7A8096, 2)
   $iAssert += @error ? 0 : 1

   ; Check "Attack!" button
   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.466929911154985, 0.735570469798658)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.534057255676209, 0.757046979865772)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0x000000, 2)
   $iAssert += @error ? 0 : 1

   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.466929911154985, 0.735570469798658)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.534057255676209, 0.757046979865772)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0xFFFF00, 2)
   $iAssert += @error ? 0 : 1

   ; Check right side potion (MP) icon
   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.939782823297137, 0.740939597315436)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.970384995064166, 0.778523489932886)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0x7A8096, 2)
   $iAssert += @error ? 0 : 1

   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.939782823297137, 0.740939597315436)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.970384995064166, 0.778523489932886)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0x5A0F8F, 2)
   $iAssert += @error ? 0 : 1

   Return $iAssert = 5
EndFunc

Func IsOnVictoryInterface()
   Local $iAssert = 0
   Local $aPos, $aPosTopLeft, $aPosBottomRight

   ; Check DragonFable logo
   $aPosTopLeft = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.500493583415597, 0.132885906040268)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.518262586377098, 0.177181208053691)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0x5B5962, 2)
   $iAssert += @error ? 0 : 1

   $aPosTopLeft = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.500493583415597, 0.132885906040268)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.518262586377098, 0.177181208053691)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0xFEE4EC, 2)
   $iAssert += @error ? 0 : 1

   ; Check "!" in "Victory!"
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.649555774925963, 0.350335570469799)
   PixelSearch($aPos[0], $aPos[1], $aPos[0], $aPos[1], 0xFFFFFF, 2)
   $iAssert += @error ? 0 : 1

   Return $iAssert = 3 ? True : False
EndFunc

Func IsOnDefeatInterface()
   Local $iAssert = 0
   Local $aPos, $aPosTopLeft, $aPosBottomRight

   ; Check DragonFable logo
   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.500493583415597, 0.132885906040268)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.518262586377098, 0.177181208053691)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0x5B5962, 2)
   $iAssert += @error ? 0 : 1

   $aPosTopLeft     = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.500493583415597, 0.132885906040268)
   $aPosBottomRight = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.518262586377098, 0.177181208053691)
   PixelSearch($aPosTopLeft[0], $aPosTopLeft[1], $aPosBottomRight[0], $aPosBottomRight[1], 0xFEE4EC, 2)
   $iAssert += @error ? 0 : 1

   ; Check "De" in "Defeat..."
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.47675568743818, 0.379217273954116)
   PixelSearch($aPos[0], $aPos[1], $aPos[0], $aPos[1], 0xFF0000, 2)
   $iAssert += @error ? 0 : 1

   Return $iAssert = 3 ? True : False
EndFunc

Func CloseVictoryInterface()
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.515301085883514, 0.606711409395973)
   MouseClick('left', $aPos[0], $aPos[1])
EndFunc

Func CloseDefeatInterface()
   CloseVictoryInterface()
EndFunc

Func IsOnLevelUpInterface()
   Local $bInLevelUpInterface = False, $iInLevelUpInterface = 0
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.629080118694362, 0.334682860998657)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFF5E Then $iInLevelUpInterface += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.645895153313551, 0.642375168690958)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInLevelUpInterface += 1
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.669634025717112, 0.705802968960864)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xE0B87C Then $iInLevelUpInterface += 1
   If $iInLevelUpInterface = 3 Then $bInLevelUpInterface = True

   Return $bInLevelUpInterface
EndFunc

Func CloseLevelUpInterface()
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.51137487636004, 0.771929824561403)
   MouseClick('left', $aPos[0], $aPos[1])
EndFunc

Func IsOnQuestCompletedInterface()
   Local $bInInterface = False, $iInInterface = 0
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.545004945598417, 0.65587044534413)
   If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then $iInInterface += 1

   Local $aPos1, $aPos2
   $aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.687438180019782, 0.73819163292847)
   $aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.745796241345203, 0.780026990553306)
   PixelSearch($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1], 0xFDE041, 2)
   If Not @error Then $iInInterface += 1

   $aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.687438180019782, 0.73819163292847)
   $aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.745796241345203, 0.780026990553306)
   PixelSearch($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1], 0xFFFE5D, 2)
   If Not @error Then $iInInterface += 1

   If $iInInterface = 3 Then $bInInterface = True

   Return $bInInterface
EndFunc

Func CloseQuestCompletedInterface()
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.515, 0.758434547908232)
   MouseClick('left', $aPos[0], $aPos[1])
   Sleep(600)
EndFunc

Func IsSkillReady($iSkill)
   If Not ((0 <= $iSkill) And ($iSkill <= 13)) Then
	  Return SetError(1, Default, False)
   EndIf

   Local $fXPercentOffset = ($iSkill < 7) ? 0.116979269496545 : 0.596742349457058
   Local $fXPercent = $fXPercentOffset + 0.049358341559724 * Mod($iSkill, 7)
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $fXPercent, 0.75503355704698)

   MouseMove($aPos[0], $aPos[1], 1.5)
   Sleep(100)

   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $fXPercent, 0.665771812080537)
   Return (PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF) ? True : False
EndFunc

Func DoSkill($iSkill)
   If Not ((0 <= $iSkill) And ($iSkill <= 13)) Then
	  Return SetError(1, Default, -1)
   EndIf

   Local $fXPercentOffset = ($iSkill < 7) ? 0.116979269496545 : 0.596742349457058
   Local $fXPercent = $fXPercentOffset + 0.049358341559724 * Mod($iSkill, 7)
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $fXPercent, 0.75503355704698)
   MouseClick('left', $aPos[0], $aPos[1], 1, 1.5)
   Sleep(150)
EndFunc

Func DoAttack()
   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.504442250740375, 0.750335570469799)
   MouseClick('left', $aPos[0], $aPos[1], 1, 1.5)
   Sleep(150)
EndFunc
#EndRegion

HotKeySet('{F9}', 'Quit')

Global $aPosGameFrameTopLeft, $aPosGameFrameBottomRight

Local $iVictories = 0, $iDefeats = 0
Local $iSceneState = 0
; 0 - Talking with Dr. Voltabolt
; 1 - Quest scene
; 2 - Battle
; 3 - End quest
; 4 - Falconreach

WinActivate('DragonFable - Web RPG')

$aPosGameFrameTopLeft = GetMouseCoordsOnClick('Click top left corner of game frame', 'Step 1 of 2', 1)
$aPosGameFrameBottomRight = GetMouseCoordsOnClick('Click bottom right corner of game frame', 'Step 2 of 2', 1)
;~ Global $aPosGameFrameTopLeft[]     = [51, 153]
;~ Global $aPosGameFrameBottomRight[] = [1174, 976]

ConsoleWrite('(' & $aPosGameFrameTopLeft[0] & ', ' & $aPosGameFrameTopLeft[1] & ')' & @LF)
ConsoleWrite('(' & $aPosGameFrameBottomRight[0] & ', ' & $aPosGameFrameBottomRight[1] & ')' & @LF)

If IsOnInventoryInterface() Then
   CloseInventoryInterface()
EndIf

Local $bInBattleScene = False, $iInBattleScene = 0
Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0623145400593472, 0.245614035087719)
If PixelGetColor($aPos[0], $aPos[1]) = 0x7D7C87 Then $iInBattleScene += 1
$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0652818991097923, 0.300944669365722)
If PixelGetColor($aPos[0], $aPos[1]) = 0x7D7C87 Then $iInBattleScene += 1
$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.0633036597428289, 0.233468286099865)
If PixelGetColor($aPos[0], $aPos[1]) = 0x7D7C87 Then $iInBattleScene += 1
$bInBattleScene = ($iInBattleScene = 3) ? True : False

If $bInBattleScene Then
   $iSceneState = 2
ElseIf $iSceneState = 0 Then
   If Not IsInTalkingWithVoltaboltScene() Then
	  Local $bInFalconreachDayScene = False, $iInFalconreachDayScene = 0
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.363006923837784, 0.107962213225371)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0xBEBD8A Then $iInFalconreachDayScene += 1
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.143422354104847, 0.365721997300945)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0x212118 Then $iInFalconreachDayScene += 1
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.981206726013848, 0.576248313090418)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0x7F744B Then $iInFalconreachDayScene += 1
	  If $iInFalconreachDayScene = 3 Then
		 $bInFalconreachDayScene = True
	  Else
		 $iInFalconreachDayScene = 0
	  EndIf

	  Local $bInFalconreachNightScene = False, $iInFalconreachNightScene = 0
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.123639960435213, 0.106612685560054)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0xB6B08E Then $iInFalconreachNightScene += 1
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.107814045499505, 0.192982456140351)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0x1D1A18 Then $iInFalconreachNightScene += 1
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.349159248269041, 0.188933873144399)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0x1D1A18 Then $iInFalconreachNightScene += 1
	  If $iInFalconreachNightScene = 3 Then
		 $bInFalconreachNightScene = True
	  Else
		 $iInFalconreachNightScene = 0
	  EndIf

	  If Not ($bInFalconreachDayScene Or $bInFalconreachNightScene) Then
		 FastTravel('Falconreach')
		 If @error Then
			Exit 1
		 EndIf

		 ; assert scene change -> in Falconreach
		 Local $bInFalconreachDayScene = False, $iInFalconreachDayScene = 0
		 Local $bInFalconreachNightScene = False, $iInFalconreachNightScene = 0
		 Local $hTimer = TimerInit()
		 While Not ($bInFalconreachDayScene Or $bInFalconreachNightScene)
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.363006923837784, 0.107962213225371)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xBEBD8A Then $iInFalconreachDayScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.143422354104847, 0.365721997300945)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x212118 Then $iInFalconreachDayScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.981206726013848, 0.576248313090418)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x7F744B Then $iInFalconreachDayScene += 1
			If $iInFalconreachDayScene = 3 Then
			   $bInFalconreachDayScene = True
			Else
			   $iInFalconreachDayScene = 0
			EndIf

			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.123639960435213, 0.106612685560054)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xB6B08E Then $iInFalconreachNightScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.107814045499505, 0.192982456140351)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x1D1A18 Then $iInFalconreachNightScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.349159248269041, 0.188933873144399)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x1D1A18 Then $iInFalconreachNightScene += 1
			If $iInFalconreachNightScene = 3 Then
			   $bInFalconreachNightScene = True
			Else
			   $iInFalconreachNightScene = 0
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   Exit 1
			EndIf

			Sleep(100)
		 WEnd
	  EndIf

	  ; Ash's feet
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.408506429277943, 0.53306342780027)
	  MouseClick('left', $aPos[0], $aPos[1])
	  Sleep(2200)

	  ; assert scene change: is talking to Ash
	  Local $iTalkingToAsh = 0
	  Local $bTalkingToAsh = False
	  Local $hTimer = TimerInit()
	  While Not $bTalkingToAsh
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.584093872229465, 0.281138790035587)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF Then $iTalkingToAsh += 1
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.333767926988266, 0.677935943060498)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0x55453E Then $iTalkingToAsh += 1
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.882659713168188, 0.138790035587189)
		 PixelSearch($aPos[0], $aPos[1], $aPos[0], $aPos[1], 0xBDBD8A, 2)
		 If Not @error Then $iTalkingToAsh += 1
		 If $iTalkingToAsh = 3 Then
			$bTalkingToAsh = True
		 Else
			$iTalkingToAsh = 0
		 EndIf

		 If TimerDiff($hTimer) > 6000 Then
			Exit 1
		 EndIf

		 Sleep(100)
	  WEnd

	  ; "Quests" button
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.522255192878338, 0.56545209176788)
	  MouseClick('left', $aPos[0], $aPos[1])
	  Sleep(100)

	  ; "Challenge" button
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.70919881305638, 0.473684210526316)
	  MouseClick('left', $aPos[0], $aPos[1])
	  Sleep(300)
   EndIf
EndIf

While 1
   Switch $iSceneState
	  Case 0 ; Talking with Dr. Voltabolt
		 ConsoleWrite('Case 0' & @LF)

		 Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.423343224530168, 0.511470985155196)
		 MouseClick('left', $aPos[0], $aPos[1])

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.423343224530168, 0.337381916329285)
		 MouseClick('left', $aPos[0], $aPos[1])

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.423343224530168, 0.392712550607287)
		 MouseClick('left', $aPos[0], $aPos[1])

		 ; assert scene change
		 Local $bInQuestScene = False, $iInQuestScene = 0
		 Local $hTimer = TimerInit()
		 While Not $bInQuestScene
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.719090009891197, 0.234817813765182)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x5B4B41 Then $iInQuestScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.432245301681503, 0.461538461538462)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x728A45 Then $iInQuestScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.502472799208704, 0.531713900134953)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x527546 Then $iInQuestScene += 1
			If $iInQuestScene = 3 Then
			   $bInQuestScene = True
			Else
			   $iInQuestScene = 0
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   Exit 1
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 $iSceneState += 1

	  Case 1 ; Quest scene
		 ConsoleWrite('Case 1' & @LF)

		 Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.395647873392681, 0.269905533063428)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(800)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.436201780415432, 0.51417004048583)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(100)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.74975272007913, 0.597840755735493)
		 MouseClick('left', $aPos[0], $aPos[1])

		 ; assert scene change
		 Local $hTimer = TimerInit()
		 While Not IsPlayerTurn()
			If TimerDiff($hTimer) > 6000 Then
			   Exit 1
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 $iSceneState += 1

	  Case 2 ; Battle
		 ConsoleWrite('Case 2' & @LF)

		 Local $bVictory = False, $bDefeat = False
		 Local $iTurn = 0
		 While Not ($bVictory Or $bDefeat)
			$bVictory = IsOnVictoryInterface()
			$bDefeat = IsOnDefeatInterface()

			If IsPlayerTurn() Then
			   PlayerTurn()
			   $iTurn += 1
			EndIf

			Sleep(20)
		 WEnd

		 If $bVictory Then
			$iVictories += 1
		 ElseIf $bDefeat Then
			$iDefeats += 1
		 EndIf

		 ConsoleWrite('Victories: ' & $iVictories & ', Defeats: ' & $iDefeats & @LF)

		 CloseVictoryInterface()

		 Local $hTimer = TimerInit()
		 While 1
			If IsOnQuestCompletedInterface() Then
			   $iSceneState += 1
			   ExitLoop
			ElseIf IsOnLevelUpInterface() Then
			   If $bStopOnLevelUp Then
				  Exit
			   EndIf

			   Sleep(5000)
			   $iSceneState += 1
			   CloseLevelUpInterface()
			   ExitLoop
			ElseIf IsInTalkingWithVoltaboltScene() Then
			   $iSceneState = 0
			   ExitLoop
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   Exit 1
			EndIf
		 WEnd
		 Local $hTimer

		 Sleep(100)

	  Case 3 ; End quest
		 ConsoleWrite('Case 3' & @LF)

		 CloseQuestCompletedInterface()

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.52, 0.815114709851552)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(200)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.437190900098912, 0.518218623481781)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(400)

		 Sleep(100)
		 $iSceneState = 0

	  Case 4 ; Falconreach
		 ConsoleWrite('Case 4' & @LF)

		 ; assert scene change
		 Local $bInFalconreachDayScene   = False, $iInFalconreachDayScene   = 0
		 Local $bInFalconreachNightScene = False, $iInFalconreachNightScene = 0
		 Local $hTimer = TimerInit()
		 While Not ($bInFalconreachDayScene Or $bInFalconreachNightScene)
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.363006923837784, 0.107962213225371)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xBEBD8A Then $iInFalconreachDayScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.143422354104847, 0.365721997300945)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x212118 Then $iInFalconreachDayScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.981206726013848, 0.576248313090418)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x7F744B Then $iInFalconreachDayScene += 1
			If $iInFalconreachNightScene = 3 Then
			   $bInFalconreachDayScene = True
			Else
			   $iInFalconreachDayScene = 0
			EndIf

			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.123639960435213, 0.106612685560054)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xB6B08E Then $iInFalconreachNightScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.107814045499505, 0.192982456140351)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x1D1A18 Then $iInFalconreachNightScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.349159248269041, 0.188933873144399)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x1D1A18 Then $iInFalconreachNightScene += 1
			If $iInFalconreachNightScene = 3 Then
			   $bInFalconreachNightScene = True
			Else
			   $iInFalconreachNightScene = 0
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   Exit 1
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.408506429277943, 0.53306342780027)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(1200)

		 Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.583580613254204, 0.27530364372469)
		 If Not (PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF) Then
			Exit 1
		 EndIf

		 Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.522255192878338, 0.56545209176788)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(100)

		 Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.70919881305638, 0.473684210526316)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(500)

		 $iSceneState = 0

   EndSwitch

   Sleep(10)
WEnd
