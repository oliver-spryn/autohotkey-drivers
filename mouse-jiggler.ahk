#SingleInstance Force

run = 0
MsgBox, 0, It has the Jiggles, Move your mouse to a target location, then press Windows + M to move the mouse around that location. Press Windows + S to stop.

#s::
	run = 0
return


#m::
run = 1
MouseGetPos, x, y

Loop {
	if (run = 1) {
		MouseMove, x + 10, y
		MouseMove, x - 10, y
		MouseMove, x, y
	} else {
		MouseMove, x, y
		break
	}
}
return
