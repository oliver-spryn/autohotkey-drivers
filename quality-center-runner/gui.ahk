;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Global
currentStep = 0
fontName = Verdana
totalSteps = 0

; Buttons
butHeight = 30

; Window frame
height = 480
padding = 10
title = Quality Center Runner
width = 320

; Header
headerBkgColor = 333333
headerFontColor = White
headerFontSize = 12
headerHeight = 56
headerTextY = 19

; Initial directions
dirButLabel = Go to the Test Steps
dirFontColor = Black
dirFontSize = 10
dirHeaderText = Pre-Run Directions

; Step directions
sdBodyFontSize = 10
sdBodyFontWeight = 400
sdHeaderHeight = 20
sdHeaderFontSize = 12
sdHeaderFontWeight = 700
sdFontColor = Black

sdButFail = Fail
sdButPass = Pass

sdHeaderComment = Comments
sdHeaderExpect = Expected Result

; Welcome directoins
welBodyText = To use this tool, open Quality Center and go to the list of test cases that you want to execute in the Test Lab. Highlight the test you want to run, this click the button at the bottom of this screen.`n`nBEFORE YOU RUN: Make sure you do not have any Quality Center test runner windows open.`n`n`nHotkey shortcuts:`nStart test: Win + S`nSkip direction: Win + D`nPass test: Win + P`nFail test: Win + F
welButLabel = Run the Selected Test
welFontColor = Black
welFontSize = 10
welHeaderText = Welcome

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gui initialization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Window frame
Gui, New, +AlwaysOnTop -MaximizeBox -MinimizeBox -Resize, %title%

; Header
Gui, Add, Progress, background%headerBkgColor% disabled h%headerHeight% w%width% x0 y0
Gui, Font, c%headerFontColor% s%headerFontSize%, %fontName%
Gui, Add, Text, backgroundTrans center vHeader w%width% x0 y%headerTextY%

; Welcome
welButY := height - padding - butHeight
welHeight := height - headerHeight - padding - butHeight - padding
welWidth := width - padding - padding
welY := headerHeight + padding

Gui, Font, c%welFontColor% s%welFontSize%, %fontName%
Gui, Add, Text, backgroundTrans h%welHeight% left vWel w%welWidth% x%padding% y%welY%
Gui, Add, Button, gStartTests vWelStart w%welWidth% x%padding% y%welButY%, %welButLabel%

; Initial directions
dirButY := height - padding - butHeight
dirHeight := height - headerHeight - padding - butHeight - padding
dirWidth := width - padding - padding
dirY := headerHeight + padding

Gui, Font, c%dirFontColor% s%dirFontSize%, %fontName%
Gui, Add, Text, backgroundTrans h%dirHeight% left vDir w%dirWidth% x%padding% y%dirY%
Gui, Add, Button, gSkipDirections vDirStart w%dirWidth% x%padding% y%dirButY%, %dirButLabel%

; Step directions
sdButY := height - padding - butHeight
sdButWidth := (width - padding - padding - padding) / 2
sdButFailX := padding + sdButWidth + padding
sdButPassX := padding

sdHeight := (height - headerHeight - padding - padding - sdHeaderHeight - padding - padding - sdHeaderHeight - padding - padding - butHeight - padding) / 3
sdWidth := width - padding - padding

sdY1 := headerHeight + padding                  ; Directions
sdY2 := sdY1 + sdHeight + padding               ; Expected Result header
sdY3 := sdY2 + sdHeaderHeight + padding         ; Expected Result body
sdY4 := sdY3 + sdHeight + padding               ; Comments header
sdY5 := sdY4 + sdHeaderHeight + padding         ; Comments text box

;;; Directions
Gui, Font, c%sdFontColor% s%sdBodyFontSize% w%sdBodyFontWeight%, %fontName%
Gui, Add, Text, backgroundTrans h%sdHeight% left vStepDir w%sdWidth% x%padding% y%sdY1%

;;; Expectation
Gui, Font, c%sdFontColor% s%sdHeaderFontSize% w%sdHeaderFontWeight%, %fontName%
Gui, Add, Text, backgroundTrans h%sdHeight% left vStepExpectHead w%sdWidth% x%padding% y%sdY2%, %sdHeaderExpect%
Gui, Font, c%sdFontColor% s%sdBodyFontSize% w%sdBodyFontWeight%, %fontName%
Gui, Add, Text, backgroundTrans h%sdHeight% left vStepExpect w%sdWidth% x%padding% y%sdY3%

;;; Comments
Gui, Font, c%sdFontColor% s%sdHeaderFontSize% w%sdHeaderFontWeight%, %fontName%
Gui, Add, Text, backgroundTrans h%sdHeight% left vStepCommentHead w%sdWidth% x%padding% y%sdY4%, %sdHeaderComment%
Gui, Font, c%sdFontColor% s%sdBodyFontSize% w%sdBodyFontWeight%, %fontName%
Gui, Add, Edit, backgroundTrans h%sdHeight% left vStepComment w%sdWidth% x%padding% y%sdY5%

;;; Buttons
Gui, Add, Button, gPass vStepPass w%sdButWidth% x%sdButPassX% y%sdButY%, %sdButPass%
Gui, Add, Button, gFail vStepFail w%sdButWidth% x%sdButFailX% y%sdButY%, %sdButFail%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Gui controllers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

changeHeader(text) {
  GuiControl, Text, Header, %text%
}

clearComment() {
  GuiControl, Text, StepComment
}

hideDirections() {
  GuiControl, Hide, Dir
  GuiControl, Hide, DirStart
}

hideGUI() {
  Gui, Cancel
}

hideStep() {
  global StepComment, StepCommentHead, StepDir, StepExpect, StepExpectHead, StepFail, StepPass

  GuiControl, Hide, StepComment
  GuiControl, Hide, StepCommentHead
  GuiControl, Hide, StepDir
  GuiControl, Hide, StepExpect
  GuiControl, Hide, StepExpectHead
  GuiControl, Hide, StepFail
  GuiControl, Hide, StepPass
}

hideWelcome() {
  GuiControl, Hide, Wel
  GuiControl, Hide, WelStart
}

maximize() {
  Gui, Restore
}

minimize() {
  Gui, Minimize
}

setTotalStepCount(total) {
  global totalSteps

  totalSteps = %total%
}

showGUI() {
  global height, width

  Gui, Show, center w%width% h%height%
}

showDirections(directions) {
  global dirHeaderText

  GuiControl, Show, Dir
  GuiControl, Show, DirStart
  GuiControl, Text, Header, %dirHeaderText%
  GuiControl, Text, Dir, %directions%
}

showStep(stepNumber, directions, expectation) {
  global currentStep, totalSteps
  global StepComment, StepCommentHead, StepDir, StepExpect, StepExpectHead, StepFail, StepPass

; Change the step number in the header
  currentStep = %stepNumber%
  title := "Step: " . currentStep . " of " . totalSteps
  changeHeader(title)

; Show the current step
  GuiControl, Show, StepDir
  GuiControl, Text, StepDir, %directions%

; Show the step expectation
  GuiControl, Show, StepExpectHead
  GuiControl, Show, StepExpect
  GuiControl, Text, StepExpect, %expectation%

; Configure the comments
  GuiControl, Show, StepCommentHead
  GuiControl, Show, StepComment
  GuiControl, Focus, StepComment

; Show the buttons
  GuiControl, Show, StepFail
  GuiControl, Show, StepPass
}

showWelcome() {
  global welBodyText, welHeaderText

  GuiControl, Show, Wel
  GuiControl, Show, WelStart
  GuiControl, Text, Header, %welHeaderText%
  GuiControl, Text, Wel, %welBodyText%
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Reset the GUI for main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hideDirections()
hideStep()
hideWelcome()
