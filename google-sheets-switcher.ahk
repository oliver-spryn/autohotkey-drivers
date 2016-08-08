Loop {
  Sleep, 30000
  Send, ^+{PgDn}

  Loop, 5 {
    Send, {PgUp}
    Send, {Home}
  }
}
