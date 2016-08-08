;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

maxQuestions = 35
qcMainTitle = HP ALM - Quality Center
qcRunnerTitle = Manual Runner: Test Set

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Memory storage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

currentStep = 0
directions =
qcX = 0
qcY = 0
qcWidth = 0
qcHeight = 0
totalSteps = 0

Loop, %maxQuestions% {
  comment%A_Index% =
  description%A_Index% =
  expected%A_Index% =
  status%A_Index% =
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Interface library
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

activate(title) {
  WinActivate, %title%
  WinWaitActive, %title%
}

copy() {
  Send, ^c
  Sleep, 125

  Return %Clipboard%
}

dumpData() {
  global qcRunnerTitle, qcWidth, totalSteps

; Get the window dimensions
  measureWindow(qcRunnerTitle)

; Go the first question
  activate(qcRunnerTitle)
  MouseMove, qcWidth - 40, 210
  Click
  Send, {Home}

; Loop through all of the questions
  Loop, %totalSteps% {
  ; Focus on the question list
    activate(qcRunnerTitle)
    MouseMove, qcWidth - 40, 210
    Click

  ; Send the comment
    if(comment%A_Index% != "") {
      Clipboard := comment%A_Index%
      Sleep, 125

      activate(qcRunnerTitle)
      Send, {tab}{tab}{tab}
      Send, ^a
      Send, {Backspace}
      Sleep, 125
      paste()
    }

  ; Go back to the question list
    activate(qcRunnerTitle)
    Click

  ; Send the pass or fail command
    activate(qcRunnerTitle)

    if(status%A_Index% == "Pass") {
      Send, ^p
    } else {
      Send, ^f

    ; Must manually go to the next step
      Click
      Send, {Down}
    }
  }

; The GUI is too slow, so wait before continuing
  Sleep, 2000
}

finish() {
  global qcRunnerTitle

  activate(qcRunnerTitle)
  Send, ^q
}

getData() {
  global currentStep, qcRunnerTitle, qcWidth, totalSteps

; Get the window dimensions
  measureWindow(qcRunnerTitle)

; Go the first question
  MouseMove, qcWidth - 40, 210
  Click
  Send, {Home}

; Loop through all of the questions
  currentStep = 1
  lastDesc =
  lastExpect =

  Loop {
  ; Focus on the question list
    activate(qcRunnerTitle)
    MouseMove, qcWidth - 40, 210
    Click

  ; Get the description
    activate(qcRunnerTitle)
    Send, {tab}
    Send, ^a
    description%A_Index% := copy()

  ; Get the expected result
    activate(qcRunnerTitle)
    Send, {tab}
    Send, ^a
    expected%A_Index% := copy()

  ; If we reach the bottom of the list, then the description and expectation
  ; values will be the same, so quit the loop
    if(description%A_Index% == lastDesc and expected%A_Index% == lastExpect) {
      totalSteps := currentStep - 1
      break
    }

  ; Focus on the question list again and jump to the next question
    activate(qcRunnerTitle)
    MouseMove, qcWidth - 40, 210
    Click
    Send, {Down}

  ; Save the previous description and expectation values
    lastDesc := description%A_Index%
    lastExpect := expected%A_Index%

  ; Go to the next step
    currentStep++
    Sleep, 250
  }

  currentStep = 0
}

hideQC() {
  global qcMainTitle

  WinSet, AlwaysOnTop, Off, %qcMainTitle%
  WinMinimize, %qcMainTitle%
}

measureWindow(title) {
  global qcX, qxY, qcWidth, qcHeight

  activate(title)
  WinGetPos, qcX, qcY, qcWidth, qcHeight, A
}

nextTest() {
  global qcMainTitle, qcWidth

; Go to the next test in the list
  measureWindow(qcMainTitle)
  MouseMove, qcWidth - 40, 210
  Send, {Down}
}

paste() {
  Send, ^v
  Sleep, 125
}

startTest() {
  global appVersion, browserName, browserVersion, environment
  global directions, qcMainTitle, qcRunnerTitle, qcHeight, qcWidth

; Bring up the currently selected test
  measureWindow(qcMainTitle)
  activate(qcMainTitle)
  MouseMove, qcWidth - 40, 210
  Click
  Send, ^{F9}
  Sleep, 5000

; Fill out the initial form
  na = N/A

  measureWindow(qcRunnerTitle)
  activate(qcRunnerTitle)
  Send, {tab}{tab}{tab}{tab}   ; Get to the first field
  Send, %na%{tab}%browserVersion%{tab}%appVersion%{tab}%na%{tab}%browserName%{tab}%na%{tab}%appVersion%{tab}{tab}%na%{tab}{tab}%environment%{tab}

; Go to the test details box and get the directions
  activate(qcRunnerTitle)
  MouseMove, 100, qcHeight - 50
  Click
  Send, ^a
  directions := copy()

; Start the test
  Send, ^r
  Sleep, 5000
}
