;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Window frame
height = 465
padding = 10
title = Keep Alive Macro
width = 320

; Headers
headerBkgColor = 333333
headerFontColor = White
headerFontSize = 12
headerHeight = 56
headerTextOffsetY = 19

header1Text = Timer
header2Text = Iteration Counter

; Timer
timerColon = :
timerColonWidth = 20

timerDirections = Duration timer: set to 0:00.`nCountdown timer: set the time value.
timerDirectionsFontColor = Black
timerDirectionsFontSize = 12

timerTextFontColor = Black
timerTextFontSize = 30
timerTextWidth = 70

timerTipFontColor = Black
timerTipFontSize = 8
timerTipTextMin = Minutes
timerTipTextSec = Seconds

; Iteration Counter
icNumberFontColor = Gray
icNumberFontSize = 60

icTip = Iterations
icTipFontColor = Black
icTipFontSize = 8

; Footer
footer = Move your mouse to a target location, then press Windows + M to move the mouse around that location. Press Windows + S to stop.
footerBkgColor = CCCCCC
footerFontColor = 333333
footerFontSize = 10
footerTextOffsetY = 19

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gui initialization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Window frame
Gui, New, -MaximizeBox -MinimizeBox -Resize, %title%

; Timer header
Gui, Add, Progress, background%headerBkgColor% disabled h%headerHeight% w%width% x0 y0
Gui, Font, c%headerFontColor% s%headerFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vHeader1 w%width% x0 y%headerTextOffSetY%, %header1Text%

; Timer directions
timerDY := headerHeight + padding
timerDW := width - padding - padding

Gui, Font, c%timerDirectionsFontColor% s%timerDirectionsFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vTimerDir w%timerDW% x%padding% y%timerDY%, %timerDirections%

; Timer
GuiControlGet, TimerDir, Pos

colonX := width / 2 - timerColonWidth / 2
minuteX := width / 2 - timerColonWidth / 2 - padding - timerTextWidth
secondX := width / 2 + timerColonWidth / 2 + padding
timerY := headerHeight + padding + TimerDirH + padding

Gui, Font, c%timerTextFontColor% s%timerTextFontSize%, %fontName%
Gui, Add, Edit, center r1 vMinute w%timerTextWidth% x%minuteX% y%timerY%, 0
Gui, Add, Text, backgroundTrans center w%timerColonWidth% x%colonX% y%timerY%, %timerColon%
Gui, Add, Edit, center r1 vSecond w%timerTextWidth% x%secondX% y%timerY%, 00

GuiControlGet, Minute, Pos
GuiControl, +Limit2 +Number, Minute
GuiControl, +Limit2 +Number, Second

tipY := timerY + MinuteH + padding

Gui, Font, c%timerTipFontColor% s%timerTipFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vMinuteTip w%timerTextWidth% x%minuteX% y%tipY%, %timerTipTextMin%
Gui, Add, Text, backgroundTrans center vSecondTip w%timerTextWidth% x%secondX% y%tipY%, %timerTipTextSec%

; Iteration Counter header
GuiControlGet, MinuteTip, Pos
header2Y := tipY + MinuteTipH + padding
headerText2Y := header2Y + headerTextOffSetY

Gui, Add, Progress, background%headerBkgColor% disabled h%headerHeight% w%width% x0 y%header2Y%
Gui, Font, c%headerFontColor% s%headerFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vHeader2 w%width% x0 y%headerText2Y%, %header2Text%

; Iteration Counter text
GuiControlGet, Header2, Pos
icY := header2Y + Header2H + padding + padding + padding

Gui, Font, c%icNumberFontColor% s%icNumberFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vICValue w%width% x0 y%icY%, 0

GuiControlGet, ICValue, Pos
icTipY := icY + ICValueH

Gui, Font, c%icTipFontColor% s%icTipFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vICTip w%width% x0 y%icTipY%, %icTip%

; Footer
GuiControlGet, ICTip, Pos
footerY := icTipY + ICTipH + padding + padding
footerHeight := height - footerY
footerTextWidth := width - padding - padding
footerTextY := footerY + padding

Gui, Add, Progress, background%footerBkgColor% disabled h%footerHeight% w%width% x0 y%footerY%
Gui, Font, c%footerFontColor% s%footerFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center w%footerTextWidth% x%padding% y%footerTextY%, %footer%

; Show the window
Gui, Show, center w%width% h%height%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gui controllers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

decrementTimeByOneSecond() {
  sec := getTimeInSeconds()
  sec := sec - 1

  setTimeInSeconds(sec)
}

disableTimerInput() {
  GuiControl, Disable, Minute
  GuiControl, Disable, Second
}

enableTimerInput() {
  GuiControl, Enable, Minute
  GuiControl, Enable, Second
}

fixTime() {
  GuiControlGet, Minute
  GuiControlGet, Second

  if(Second >= 0 && Second <= 9) {
    Second := Second + 0 ; Removes any zeros before 00, 01, 02, etc... if it is already there
    sec = 0%Second%

    GuiControl, , Second, %sec%
  }

  if(Minute >= 0 && Minute <= 9) {
    min := Minute + 0 ; Removes any zeros before 00, 01, 02, etc... if it is already there

    GuiControl, , Minute, %min%
  }

  if(Second >= 60) {
    sec := Second - 60
    min := Minute + 1

    GuiControl, , Minute, %min%
    GuiControl, , Second, %sec%
  }
}

getIterationCounter() {
  GuiControlGet, ICValue

  Return ICValue
}

getTimeInSeconds() {
  GuiControlGet, Minute
  GuiControlGet, Second

  Return Minute * 60 + Second
}

incrementIterationCounter() {
  it := getIterationCounter()
  it := it + 1

  setIterations(it)
}

incrementTimeByOneSecond() {
  sec := getTimeInSeconds()
  sec := sec + 1

  setTimeInSeconds(sec)
}

setIterations(it) {
  GuiControl, , ICValue, %it%
}

setTimeInMinSec(min, sec) {
  GuiControl, , Minute, %min%
  GuiControl, , Second, %sec%

  fixTime()
}

setTimeInSeconds(time) {
  min := Floor(time / 60)
  sec := time - Floor(60 * min)

  setTimeInMinSec(min, sec)
}
