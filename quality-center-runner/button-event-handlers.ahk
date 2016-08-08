AHKTitle = Quality Center Runner

#s::
StartTests:
  global directions, totalSteps

  showTip("Getting the Test Data", "Please do not use your keyboard and mouse while we get the test data")
  minimize()
  startTest()
  getData()
  hideQC()
  hideWelcome()
  showDirections(directions)
  maximize()
  hideTip()
  showTip("Go ahead!", "You can use your keyboard and mouse again")

  Sleep, 500
  WinActivate, %AHKTitle%
return

#d::
SkipDirections:
  hideDirections()
  setTotalStepCount(totalSteps)

  Sleep, 500
  WinActivate, %AHKTitle%
  GoSub, NextStep
return

#p::
Pass:
; Save the results of the test step
  GuiControlGet, StepComment
  comment%currentStep% = %StepComment%
  status%currentStep% = Pass

; Go to the next step
  GoSub, NextStep
return

#f::
Fail:
; Save the results of the test step
  GuiControlGet, StepComment
  comment%currentStep% = %StepComment%
  status%currentStep% = Fail

; Go to the next step
  GoSub, NextStep
return

NextStep:
; Go to the next step
  currentStep++

; Have we reached the end of the list?
  if(currentStep > totalSteps) {
    showTip("Writing the Test Results", "Please do not use your keyboard and mouse while we write the test data")
    minimize()
    hideStep()
    showWelcome()
    dumpData()
    finish()
    maximize()
    showTip("Go ahead!", "You can use your keyboard and mouse again")
    return
  }

; Show the directions of the step
  showStep(currentStep, description%currentStep%, expected%currentStep%)
  clearComment()
return
