#include <Misc.au3> ; for _IsPressed()

; DragonFable_Potion-Mastery.au3

; Created by /u/Pyprohly
; Script Version 2.6.0
; Created on Friday, 07 July 2017
; Modified on Sunday, 22 July 2018
; Written for DragonFable, Build 14.2.52

; Description:
; Generates gold at a rate of about 400 gold per minute by farming the Potion Mastery quest from Nythera.

; Instructions:
; Login to DragonFable and run this script. You will be asked to click the top left then bottom right corners of the game frame.
; The script will act immediately afterwards. If your character is not at Warlic’s Tent you will be taken to this location first.
; Once there, your inventory will be scanned to determine the number of empty slots. Refrain from clicking during this process.

; Note:
; Press F9 to terminate the script.
; AutoIt3's pixel colour inspection functions are not DPI aware! Make sure scaling is at 100% in ‘Display settings’.

$bAutoSellRewardsWhenInventoryIsFull = True
$bConfirmFirstSell = False

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
		 Sleep(150)
		 Return MouseGetPos()
	  EndIf
	  Sleep(50)
   WEnd
EndFunc

Func GetPosFromPercentage($aPosTopLeft, $aPosBottomRight, $fXPercent, $fYPercent)
   If Not ((0 <= $fXPercent And $fXPercent <= 1) Or (0 <= $fYPercent And $fYPercent <= 1))  Then
	  SetError(1, Default, 'Percentage value error')
   EndIf

   Local $aPos[2]
   $aPos[0] = $aPosTopLeft[0] + ($aPosBottomRight[0] - $aPosTopLeft[0]) * $fXPercent
   $aPos[1] = $aPosTopLeft[1] + ($aPosBottomRight[1] - $aPosTopLeft[1]) * $fYPercent
   Return $aPos
EndFunc

Func IsOptionsIconVisible()
   ; test if "Options" icon (gears) is visible

   Local $aPos1, $aPos2
   $aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.387734915924827, 0.959514170040486)
   $aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.415430267062315, 0.995951417004049)
   Local $aColoursInRegion[] = [0x232820, 0x2F2F2C, 0x20211F]
   For $i In $aColoursInRegion
	  PixelSearch($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1], $i, 2)

	  If @error Then
		 Return False
	  EndIf
   Next

   Return True
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

Func IsPlayerAtWarlicPortal()
   Local $aSceneColours[5]

   Local $aPos
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.413563829787234, 0.0688405797101449)
   $aSceneColours[0] = (PixelGetColor($aPos[0], $aPos[1]) = 0x827F58) ? True : False

   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.246010638297872, 0.766304347826087)
   $aSceneColours[1] = (PixelGetColor($aPos[0], $aPos[1]) = 0x2E5C2D) ? True : False

   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.606382978723404, 0.666666666666667)
   $aSceneColours[2] = (PixelGetColor($aPos[0], $aPos[1]) = 0x2E5C2D) ? True : False

   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.16168193484699, 0.116182795698925)
   $aSceneColours[3] = (PixelGetColor($aPos[0], $aPos[1]) = 0x4F4235) ? True : False

   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.683978282329714, 0.723118279569893)
   $aSceneColours[4] = (PixelGetColor($aPos[0], $aPos[1]) = 0x546E27) ? True : False

   For $bColour In $aSceneColours
	  If Not $bColour Then
		 Return False
	  EndIf
   Next

   Return True
EndFunc

Func SelectInventorySlot($iTarget, $iSelected = Null, $iScrollOffset = Null)
   Static $iSlotSelected = 0
   Static $iSlotOffset = 0

   Local $iSlotTarget = $iTarget
   Local $iSlotDelta

   Local $aPos

   If VarGetType($iSelected) = 'Int32' Then
	  $iSlotSelected = $iSelected
   EndIf
   If VarGetType($iScrollOffset) = 'Int32' Then
	  $iSlotOffset = $iScrollOffset
   EndIf

   $iSlotDelta = $iSlotTarget - $iSlotSelected
   $iSlotSelected = $iSlotTarget
   If $iSlotOffset + $iSlotDelta < 0 Then
	  ; Need to scroll upwards
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.531157270029674, 0.245614035087719)
	  MouseClick('left', $aPos[0], $aPos[1], -($iSlotDelta + $iSlotOffset))

	  $iSlotOffset = 0

	  ; Select item
	  Sleep(20)
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.483311081441923, 0.244939271255061 + 0.0472334682861 * $iSlotOffset)
	  MouseClick('left', $aPos[0], $aPos[1])
   ElseIf $iSlotOffset + $iSlotDelta > 9 Then
	  ; Need to scroll downwardss
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.531157270029674, 0.665317139001349)
	  MouseClick('left', $aPos[0], $aPos[1], ($iSlotDelta - (9 - $iSlotOffset)))

	  $iSlotOffset = 9

	  ; Select item
	  Sleep(20)
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.483311081441923, 0.244939271255061 + 0.0472334682861 * $iSlotOffset)
	  MouseClick('left', $aPos[0], $aPos[1])
   Else
	  ; select the target slot
	  $iSlotOffset = $iSlotOffset + $iSlotDelta

	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.121167161226508, 0.244939271255061 + 0.0472334682861 * $iSlotOffset)
	  MouseClick('left', $aPos[0], $aPos[1])
   EndIf
EndFunc

Func SellFromInventory($iStartSellIndex, $iSellAmount, $iTab = 0)
   If $iTab > 0 Then
	  Local $aPosLeftTab = [0.249666221628838, 0.087431693989071]
	  Local $aPosRightTab = [0.391188251001335, 0.087431693989071]

	  Local $aPos1 = $aPosRightTab
	  Local $aPos2 = $aPosLeftTab

	  If $iTab = 2 Then
		 $aPos1 = $aPosLeftTab
		 $aPos2 = $aPosRightTab
	  EndIf

	  Local $aPos
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aPos1[0], $aPos1[1])
	  MouseClick('left', $aPos[0], $aPos[1])
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aPos2[0], $aPos2[1])
	  MouseClick('left', $aPos[0], $aPos[1])
   EndIf
   Sleep(100)

   For $i = $iStartSellIndex To $iStartSellIndex + $iSellAmount - 1
	  SelectInventorySlot($iStartSellIndex, 0, 0)

	  ; Sell button
	  Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.777777777777778, 0.794460641399417)
	  MouseClick('left', $aPos[0], $aPos[1])
	  Sleep(100)

	  ; Sell confirmation dialogue
	  $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.39465875370919, 0.445344129554656)
	  If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then
		 ; Confirm first item sell
		 If IsDeclared('bConfirmFirstSell') And VarGetType($bConfirmFirstSell) = 'Bool' Then
			If $bConfirmFirstSell Then
			   ToolTip('Press enter to continue selling.', Default, Default, 'Press enter', 1)
			   While 1
				  If _IsPressed('0D') Then
					 ToolTip('')
					 Sleep(150)
					 ExitLoop
				  EndIf
				  Sleep(50)
			   WEnd
			   $bConfirmFirstSell = False
			EndIf
		 EndIf

		 ; Button "Yes"
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.43620178041543, 0.516869095816464)
;~ 		 MouseMove($aPos[0], $aPos[1])
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(100)

		 ; assert scene change -> Inventory
		 Local $hTimer = TimerInit()
		 While 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.09, 0.460188933873144)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then
			   ExitLoop
			EndIf

			If TimerDiff($hTimer) > 4000 Then
			   Exit 1
			EndIf

			Sleep(100)
		 WEnd
	  Else
		 ; No more items to sell
		 Return 1
	  EndIf

	  Sleep(100)
   Next
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

Func FetchPlayerInventoryStats()
   ; returns a two-element array of the player's inventory size and empty spaces avaliable

   Local $iTotalInventorySlots
   Local $iTotalInventoryEmptySlots

   If IsOnInventoryInterface() Then
	  CloseInventoryInterface()
   EndIf

   If Not IsOptionsIconVisible() Then
	  Exit 1
   EndIf

   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.415430267062315, 0.912280701754386)
   MouseClick('left', $aPos[0], $aPos[1])
   Sleep(325)

   $iTotalInventorySlots = 0
   $iTotalInventoryEmptySlots = 0

   $iSlotNumbersCheckSumPrevious = 0
   While 1
	  If $iTotalInventorySlots < 9 Then
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.109792284866469, 0.272594752186589 + 0.0472334682861 * $iTotalInventorySlots)
;~ 		 MouseMove($aPos[0], $aPos[1])
;~ 		 WaitEnter()
		 If PixelGetColor($aPos[0], $aPos[1]) = 0xD1D1D1 Then
			$iTotalInventoryEmptySlots += 1
		 EndIf

		 $iTotalInventorySlots += 1
	  Else
		 ; Scroll down arrow
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.527777777777778, 0.663265306122449)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(150)

		 Local $aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.104700854700855, 0.603498542274053)
		 Local $aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.132478632478632, 0.677842565597668)
		 Local $iSlotNumbersCheckSum = PixelChecksum($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1])

		 If $iSlotNumbersCheckSum = $iSlotNumbersCheckSumPrevious Then
			ExitLoop
		 Else
			$iSlotNumbersCheckSumPrevious = $iSlotNumbersCheckSum
		 EndIf

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.109792284866469, 0.272594752186589 + 0.0472334682861 * 8)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0xD1D1D1 Then
			$iTotalInventoryEmptySlots += 1
		 EndIf

		 $iTotalInventorySlots += 1
	  EndIf
   WEnd

   Local $aRetn[2] = [$iTotalInventorySlots, $iTotalInventoryEmptySlots]
   Return $aRetn
EndFunc

HotKeySet('{F9}', 'Quit')

Global $aPosGameFrameTopLeft, $aPosGameFrameBottomRight

Local $bAutoResetLoopIfErrorIsEncountered = False
Local $iQuestTimeValidationLimit = 55 ; seconds

Local $iSceneState = 0
; 0 - Warlic’s Tent portal
; 1 - Warlic’s tent
; 2 - Talking with Nythera
; 3 - Quest brief
; 4 - Potion Mastery game
; 5 - End Potion Mastery
; 6 - Falconreach
; 7 - Yulgar or Lim
; 8 - Yulgar/Lim's shop

Local $aReagentSamplingRegions[17][2][2] = [ _
   [[0.276679841897233, 0.28167115902960], [0.300395256916996, 0.304582210242588]], _
   [[0.384387351778656, 0.33288409703501], [0.408102766798419, 0.351752021563342]], _
   [[0.581027667984192, 0.30862533692722], [0.608695652173913, 0.332884097035044]], _
   [[0.757905138339921, 0.34097035040433], [0.771739130434783, 0.365229110512129]], _
   [[0.205533596837945, 0.44204851752024], [0.223320158102767, 0.460916442048518]], _
   [[0.411067193675889, 0.44204851752025], [0.437747035573123, 0.460916442048518]], _
   [[0.662055335968379, 0.43530997304586], [0.676877470355731, 0.459568733153639]], _
   [[0.781620553359684, 0.44743935309977], [0.794466403162055, 0.460916442048518]], _
   [[0.285573122529644, 0.58490566037738], [0.301383399209486, 0.622641509433962]], _
   [[0.347284060552093, 0.59416767922235], [0.358860195903829, 0.620899149453222]], _ ; 9
   [[0.604743083003953, 0.58625336927220], [0.617588932806324, 0.618598382749326]], _
   [[0.709486166007905, 0.56334231805921], [0.728260869565217, 0.595687331536388]], _
   [[0.267786561264822, 0.69407008086252], [0.292490118577075, 0.722371967654987]], _
   [[0.413043478260875, 0.71428571428573], [0.442687747035573, 0.731805929919138]], _
   [[0.560276679841897, 0.69676549865224], [0.582015810276686, 0.722371967654987]], _
   [[0.688735177865613, 0.68463611859835], [0.706521739130435, 0.711590296495957]], _
   [[0.811264822134387, 0.73584905660376], [0.828063241106719, 0.769541778975741]] _
]

Local $aReagentPositions[17][2] = [ _
   [0.291501976284585, 0.339622641509434], _
   [0.394268774703557, 0.339622641509434], _
   [0.594861660079051, 0.339622641509434], _
   [0.741106719367589, 0.339622641509434], _
   [0.231225296442688, 0.471698113207547], _
   [0.424901185770751, 0.471698113207547], _
   [0.658102766798419, 0.471698113207547], _
   [0.771739130434783, 0.471698113207547], _
   [0.266798418972332, 0.610512129380054], _
   [0.374505928853755, 0.610512129380054], _
   [0.589920948616601, 0.610512129380054], _
   [0.749011857707513, 0.610512129380054], _
   [0.295454545454545, 0.723719676549865], _
   [0.427865612648221, 0.723719676549865], _
   [0.598814229249012, 0.723719676549865], _
   [0.694664031620553, 0.723719676549865], _
   [0.789525691699605, 0.723719676549865] _
]

WinActivate('DragonFable - Web RPG')

$aPosGameFrameTopLeft = GetMouseCoordsOnClick('Click top left corner of game frame', 'Step 1 of 2', 1)
$aPosGameFrameBottomRight = GetMouseCoordsOnClick('Click bottom right corner of game frame', 'Step 2 of 2', 1)
;~ Global $aPosGameFrameTopLeft[] = [19, 144]
;~ Global $aPosGameFrameBottomRight[] = [955, 830]

ConsoleWrite('(' & $aPosGameFrameTopLeft[0] & ', ' & $aPosGameFrameTopLeft[1] & ')' & @LF)
ConsoleWrite('(' & $aPosGameFrameBottomRight[0] & ', ' & $aPosGameFrameBottomRight[1] & ')' & @LF)


#cs
; Debug
; Iterate reagent sampling regions

Local $aPos
For $i = 0 To UBound($aReagentSamplingRegions) - 1
   ConsoleWrite($i & @LF)
   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aReagentSamplingRegions[$i][0][0], $aReagentSamplingRegions[$i][0][1])
   MouseMove($aPos[0], $aPos[1])
   While 1
	  If _IsPressed('0D') Then ; Enter key
		 ExitLoop
	  EndIf
	  Sleep(10)
   WEnd

   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aReagentSamplingRegions[$i][1][0], $aReagentSamplingRegions[$i][1][1])
   MouseMove($aPos[0], $aPos[1])
   While 1
	  If _IsPressed('0D') Then ; Enter key
		 ExitLoop
	  EndIf
	  Sleep(10)
   WEnd
Next

Exit
#ce


#cs
; Batch sell from inventory using SellFromInventory().
; Go into a shop's "Sell" tab.
; Can also be used to bulk destroy items if in player inventory.
; Function signature hint:
; 	SellFromInventory($iStartingIndex, $iSellAmount, $iTab)

$bConfirmFirstSell = True

SellFromInventory(17, 999, 2)

Exit
#ce


If IsOnInventoryInterface() Then
   CloseInventoryInterface()
EndIf

If $iSceneState = 0 Then
   If Not IsPlayerAtWarlicPortal() Then
	  FastTravel("Warlic's Tent")
	  If @error Then
		 Exit 1
	  EndIf

	  ; assert scene change -> Warlic's Tent portal
	  Local $hTimer = TimerInit()
	  Local $aPos
	  While 1
		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.410484668644906, 0.0674763832658569)
		 If PixelGetColor($aPos[0], $aPos[1]) = 0x827F58 Then
			ExitLoop
		 EndIf

		 If TimerDiff($hTimer) > 6000 Then
			Exit 1
		 EndIf

		 Sleep(100)
	  WEnd
	  Local $hTimer
   EndIf
EndIf

Local $aPlayerInventoryStats = FetchPlayerInventoryStats()
ConsoleWrite('FetchPlayerInventoryStats() -> ' & '[' & $aPlayerInventoryStats[0] & ', ' & $aPlayerInventoryStats[1] & ']' & @LF)

Local $iInventoryEmptySpaceLeft = $aPlayerInventoryStats[1]
If $iInventoryEmptySpaceLeft = 0 Then
   ToolTip('Inventory full!')
   Sleep(2000)
   ToolTip('')
   Exit 1
EndIf

If IsOnInventoryInterface() Then
   CloseInventoryInterface()
EndIf

While 1
   Switch $iSceneState
	  Case 0 ; Warlic’s Tent portal
		 ConsoleWrite('Scene 0' & @LF)

		 If $iInventoryEmptySpaceLeft = 0 Then
			If $bAutoSellRewardsWhenInventoryIsFull Then
			   $iSceneState = 6
			   FastTravel('Falconreach')
			   If @error Then
				  Exit 1
			   EndIf
			Else
			   Exit 0
			EndIf
		 Else
			Local $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.93, 0.42)
			MouseClick('left', $aClickPos[0], $aClickPos[1])

			; assert scene change -> Gold orb planet thingy on top of Warlic’s Tent
			Local $aPos1, $aPos2
			Local $hTimer = TimerInit()
			While 1
			   $aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.655138339920949, 0.0700808625336927)
			   $aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.669960474308336, 0.0889487870619946)
			   PixelSearch($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1], 0xF0C66E, 2)
			   If Not @error Then
				  ExitLoop
			   EndIf

			   If TimerDiff($hTimer) > 6000 Then
				  If $bAutoResetLoopIfErrorIsEncountered Then
					 FastTravel("Warlic's Tent")
					 If @error Then
						Exit 1
					 EndIf
				  Else
					 Exit 1
				  EndIf
			   EndIf

			   Sleep(100)
			WEnd
			Local $hTimer

			Sleep(100)
			$iSceneState += 1
		 EndIf

	  Case 1 ; Warlic’s tent
		 ConsoleWrite('Scene 1' & @LF)
		 $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.757, 0.5)
		 MouseClick('left', $aClickPos[0], $aClickPos[1])

		 ; assert scene change
		 Local $aPos
		 Local $hTimer = TimerInit()
		 While 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.599802371541502, 0.288409703504043)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF Then
			   ExitLoop
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   If $bAutoResetLoopIfErrorIsEncountered Then
				  FastTravel("Warlic's Tent")
				  If @error Then
					 Exit 1
				  EndIf
			   Else
				  Exit 1
			   EndIf
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 Sleep(100)
		 $iSceneState += 1

	  Case 2 ; Talking with Nythera
		 ConsoleWrite('Scene 2' & @LF)
		 Local $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.5296, 0.4892)
		 MouseClick('left', $aClickPos[0], $aClickPos[1], 2)

		 $aClickPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.5296, 0.3773)
		 MouseClick('left', $aClickPos[0], $aClickPos[1])

		 ; assert scene change -> Talking with Nythera in quest
		 Local $aPos
		 Local $hTimer = TimerInit()
		 While 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.970355731225296, 0.117250673854447)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF Then
			   ExitLoop
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   If $bAutoResetLoopIfErrorIsEncountered Then
				  FastTravel("Warlic's Tent")
				  If @error Then
					 Exit 1
				  EndIf
			   Else
				  Exit 1
			   EndIf
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 Local $hQuestTime = TimerInit()

		 Sleep(200)
		 $iSceneState += 1

	  Case 3 ; Quest brief
		 ConsoleWrite('Scene 3' & @LF)
		 Local $iMouseClickDelay = AutoItSetOption('MouseClickDelay')
		 AutoItSetOption('MouseClickDelay', 65)
		 MouseClick('left', Default, Default, 5)
		 AutoItSetOption('MouseClickDelay', $iMouseClickDelay)

		 ; assert scene change
		 Local $aPos
		 Local $hTimer = TimerInit()
		 While 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.640316205533597, 0.204851752021563)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xB3B3B3 Then
			   ExitLoop
			ElseIf PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF Then
			   If Mod(TimerDiff($hTimer), 1000) > 500 Then
				  MouseClick('left', Default, Default)
			   EndIf
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   If $bAutoResetLoopIfErrorIsEncountered Then
				  FastTravel("Warlic's Tent")
				  If @error Then
					 Exit 1
				  EndIf
			   Else
				  Exit 1
			   EndIf
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 Sleep(1000)
		 $iSceneState += 1

	  Case 4 ; Potion Mastery game
		 ConsoleWrite('Scene 4' & @LF)
		 Local $aReagentCheckSum[17]
		 Local $aReagentNeeded[6]
		 Local $aPos, $aPos1, $aPos2

		 MouseClick('left')
		 Sleep(3200)

		 ConsoleWrite('Scanning samples...' & @LF)
		 For $i = 0 To UBound($aReagentPositions) - 1
			$aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aReagentSamplingRegions[$i][0][0], $aReagentSamplingRegions[$i][0][1])
			$aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aReagentSamplingRegions[$i][1][0], $aReagentSamplingRegions[$i][1][1])
			$aReagentCheckSum[$i] = PixelChecksum($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1])
		 Next
		 ConsoleWrite('Done' & @LF)

		 Sleep(300)

		 Local $hTimer
		 Local $iCounter
		 For $iAttempt = 0 To 3
			ConsoleWrite('Stage: ' & $iAttempt & @LF)
			$hTimer = TimerInit()
			$iCounter = 0
			While TimerDiff($hTimer) < 1100
			   For $i = 0 To UBound($aReagentPositions) - 1
				  $aPos1 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aReagentSamplingRegions[$i][0][0], $aReagentSamplingRegions[$i][0][1])
				  $aPos2 = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $aReagentSamplingRegions[$i][1][0], $aReagentSamplingRegions[$i][1][1])
				  If PixelChecksum($aPos1[0], $aPos1[1], $aPos2[0], $aPos2[1]) <> $aReagentCheckSum[$i] Then
					 $aReagentNeeded[$iCounter] = $i
					 ConsoleWrite($i & @LF)
					 Sleep(920)
					 $iCounter += 1
					 $hTimer = TimerInit()
				  EndIf
			   Next
			WEnd
			Local $hTimer
			ConsoleWrite('Action' & @LF)

			If ($iCounter < 3) Or ($iCounter > 6) Then
			   If $bAutoResetLoopIfErrorIsEncountered Then
				  FastTravel("Warlic's Tent")
				  If @error Then
					 Exit 1
				  EndIf
			   Else
				  Exit 1
			   EndIf
			EndIf

			Local $bNeedDelay
			For $i = 0 To $iCounter - 1
			   $bNeedDelay = True
			   If $i > 0 Then
				  If $aReagentNeeded[$i] = $aReagentNeeded[$i - 1] Then
					 Sleep(1000)
					 $bNeedDelay = False
				  EndIf
			   EndIf
			   If $bNeedDelay Then
				  If $i > 1 Then
					 If $aReagentNeeded[$i] = $aReagentNeeded[$i - 2] Then
						Sleep(800)
						$bNeedDelay = False
					 EndIf
				  EndIf
			   EndIf
			   If $bNeedDelay Then
				  If $i > 2 Then
					 If $aReagentNeeded[$i] = $aReagentNeeded[$i - 3] Then
						Sleep(500)
						$bNeedDelay = False
					 EndIf
				  EndIf
			   EndIf

			   Local $fPosXPercentage = $aReagentPositions[$aReagentNeeded[$i]][0]
			   Local $fPosYPercentage = $aReagentPositions[$aReagentNeeded[$i]][1]
			   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, $fPosXPercentage, $fPosYPercentage)
			   If $i = 0 Then
				  ; click twice to compensate for the countdown text disengaging the cursor at the start of each round
				  MouseClick('left', $aPos[0], $aPos[1], 1 , 3)
			   EndIf

			   MouseClick('left', $aPos[0], $aPos[1], 1, 3)

			   Sleep(50)
			Next

			If $iAttempt = 3 Then
			   ExitLoop
			EndIf

			Sleep(4900)
		 Next

		 Sleep(50)
		 $iSceneState += 1

	  Case 5 ; End Potion Mastery
		 ConsoleWrite('Scene 5' & @LF)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.52, 0.358974358974359)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(300)

		 If IsDeclared('hQuestTime') Then
			If VarGetType($hQuestTime) = 'Double' Then
			   Local $iQuestTime = TimerDiff($hQuestTime)
			   ConsoleWrite('Completed in ' & StringFormat('%.2f', $iQuestTime / 1000) & ' seconds.')

			   If $iQuestTime < 1000 * $iQuestTimeValidationLimit Then
				  ConsoleWrite(' Break for ' & StringFormat('%.2f', $iQuestTimeValidationLimit - $iQuestTime / 1000) & ' seconds...')
				  Sleep(1000 * $iQuestTimeValidationLimit - $iQuestTime)
				  ConsoleWrite(' Done')
			   EndIf

			   ConsoleWrite(@LF)
			EndIf
		 EndIf

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.52, 0.759784075573549)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(500)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.52, 0.754385964912281)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(800)

		 $iSceneState = 0

		 $iInventoryEmptySpaceLeft -= 1
		 ConsoleWrite('Inventory space remaining: ' & $iInventoryEmptySpaceLeft & @LF)

; Discard the reward because there is no space left in the inventory
; Not needed any more because script now counts the inventory size
;~ 		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.561917443408788, 0.626811594202899)
;~ 		 If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then
;~ 			If $bAutoSellRewardsWhenInventoryIsFull Then
;~ 			   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.33234421364985, 0.802968960863698)
;~ 			   MouseClick('left', $aPos[0], $aPos[1])
;~ 			   Sleep(50)

;~ 			   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.51730959446093, 0.815114709851552)
;~ 			   MouseClick('left', $aPos[0], $aPos[1])
;~ 			   Sleep(50)

;~ 			   $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.438180019782394, 0.515519568151147)
;~ 			   MouseClick('left', $aPos[0], $aPos[1])
;~ 			   Sleep(2000)

;~ 			   FastTravel('Falconreach')
;~ 			   If @error Then
;~ 				  Exit 1
;~ 			   EndIf

;~ 			   $iSceneState = 6
;~ 			Else
;~ 			   Exit
;~ 			EndIf
;~ 		 EndIf

		 Sleep(500)

	  Case 6 ; Falconreach
		 ConsoleWrite('Scene 6' & @LF)

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

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.896142433234421, 0.535762483130904)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(800)

		 ; assert scene change -> in Yulgar/Lim's shop
		 Local $bInYulgarShopScene = False, $iInYulgarShopScene = 0
		 Local $bInLimShopScene = False, $iInLimShopScene = 0
		 Local $hTimer = TimerInit()
		 While Not ($bInYulgarShopScene Or $bInLimShopScene)
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.098911968348171, 0.118758434547908)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xABB3CC Then $iInYulgarShopScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.475766567754698, 0.470985155195682)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x2D3239 Then $iInYulgarShopScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.318496538081108, 0.248313090418354)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xFFFFFF Then $iInYulgarShopScene += 1
			If $iInYulgarShopScene = 3 Then
			   $bInYulgarShopScene = True
			Else
			   $iInYulgarShopScene = 0
			EndIf

			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.345794392523364, 0.500910746812386)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x605117 Then $iInLimShopScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.307076101468625, 0.70856102003643)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x4F4F4F Then $iInLimShopScene += 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.604806408544726, 0.236794171220401)
			If PixelGetColor($aPos[0], $aPos[1]) = 0x566965 Then $iInLimShopScene += 1
			If $iInLimShopScene = 3 Then
			   $bInLimShopScene = True
			Else
			   $iInLimShopScene = 0
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   If $bAutoResetLoopIfErrorIsEncountered Then
				  FastTravel('Falconreach')
				  If @error Then
					 Exit 1
				  EndIf

				  $iSceneState = 5
				  ExitLoop
			   Else
				  Exit 1
			   EndIf
			EndIf

			Sleep(50)
		 WEnd
		 Local $hTimer

		 $iSceneState += 1

	  Case 7 ; Yulgar or Lim
		 ConsoleWrite('Scene 7' & @LF)

		 If IsDeclared('bInLimShopScene') And VarGetType($bInLimShopScene) = 'Bool' Then
			If $bInLimShopScene Then
			   ; Hello Lim. Lim "Shop" button
			   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.520694259012016, 0.306010928961749)
			   MouseClick('left', $aPos[0], $aPos[1], 2)
			Else
			   ; Hello Yulgar. Yulgar "Shop" button
			   Local $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.272007912957468, 0.399460188933873)
			   MouseClick('left', $aPos[0], $aPos[1])
			EndIf
		 Else
			Exit 1
		 EndIf

		 ; assert scene change -> Shop interface
		 Local $hTimer = TimerInit()
		 While 1
			$aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.09, 0.460188933873144)
			If PixelGetColor($aPos[0], $aPos[1]) = 0xEACEA6 Then
			   ExitLoop
			EndIf

			If TimerDiff($hTimer) > 6000 Then
			   If $bAutoResetLoopIfErrorIsEncountered Then
				  FastTravel('Falconreach')
				  If @error Then
					 Exit 1
				  EndIf

				  $iSceneState = 6
				  ExitLoop
			   Else
				  Exit 1
			   EndIf
			EndIf

			Sleep(100)
		 WEnd
		 Local $hTimer

		 Sleep(100)
		 $iSceneState += 1

	  Case 8 ; Yulgar/Lim's shop
		 ConsoleWrite('Scene 8' & @LF)

		 SellFromInventory($aPlayerInventoryStats[0] - $aPlayerInventoryStats[1] + 1, $aPlayerInventoryStats[1], 2)

		 $aPos = GetPosFromPercentage($aPosGameFrameTopLeft, $aPosGameFrameBottomRight, 0.324431256181998, 0.802968960863698)
		 MouseClick('left', $aPos[0], $aPos[1])
		 Sleep(100)

		 $iInventoryEmptySpaceLeft = $aPlayerInventoryStats[1]
		 ConsoleWrite('Assuming ' & $iInventoryEmptySpaceLeft & ' empty inventory spaces')

		 FastTravel("Warlic's Tent")
		 If @error Then
			Exit 1
		 EndIf

		 Sleep(2000)
		 $iSceneState = 0
   EndSwitch

   Sleep(100)
WEnd
