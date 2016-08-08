#SingleInstance Force
#Include gui.ahk

run = 0

setTimeInSeconds(301)

Loop {
  MouseGetPos, x, y

  if (run = 1) {
    Sleep, 1000
    decrementTimeByOneSecond()

    MouseMove, x + 10, y
		MouseMove, x - 10, y
		MouseMove, x, y
  }
}
return

#s::
	run = 0
return

#m::
run = 1
return

#r::
Reload
return
