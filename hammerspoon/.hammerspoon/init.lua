-- Make tapping Control send Escape, and holding it send Control.
hs.loadSpoon('ControlEscape'):start()

-- Use Control + Space to start a new global modal state with Hammerspoon.
-- The bindings below apply only after the modal state has been started.
modal = hs.hotkey.modal.new('control', 'space', '')

-- Reload Hammerspoon configuration and exit the modal state.
modal:bind('', 'r', nil, function ()
  hs.reload()

  modal:exit()
end)

-- Resize the focused window to 33% screen width and 100% screen height,
-- anchor it to the left of the screen, and exit the modal state.
modal:bind('', '1', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.x
  frame.y = screen.y
  frame.w = screen.w / 3
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 50% screen width and 100% screen height,
-- anchor it to the left of the screen, and exit the modal state.
modal:bind('', '2', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.x
  frame.y = screen.y
  frame.w = screen.w / 2
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 67% screen width and 100% screen height,
-- anchor it to the left of the screen, and exit the modal state.
modal:bind('', '3', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.x
  frame.y = screen.y
  frame.w = screen.w / 3 * 2
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 67% screen width and 100% screen height,
-- anchor it to the right of the screen, and exit the modal state.
modal:bind('', '8', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.w / 3
  frame.y = screen.y
  frame.w = screen.w / 3 * 2
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 50% screen width and 100% screen height,
-- anchor it to the right of the screen, and exit the modal state.
modal:bind('', '9', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.w / 2
  frame.y = screen.y
  frame.w = screen.w / 2
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 33% screen width and 100% screen height,
-- anchor it to the right of the screen, and exit the modal state.
modal:bind('', '0', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.w / 3 * 2
  frame.y = screen.y
  frame.w = screen.w / 3
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 100% screen width and 100% screen height
-- and exit the modal state.
modal:bind('', 'f', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.x
  frame.y = screen.y
  frame.w = screen.w
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Resize the focused window to 67% screen width and 100% screen height,
-- center it, and exit the modal state.
modal:bind('', 'j', nil, function ()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local frame = window:frame()

  frame.x = screen.w / 6
  frame.y = screen.y
  frame.w = screen.w / 3 * 2
  frame.h = screen.h

  window:setFrame(frame, 0)

  modal:exit()
end)

-- Move the focused window left one display.
modal:bind('', 'h', nil, function ()
  local window = hs.window.focusedWindow()

  window:moveOneScreenWest(true, true, 0)

  modal:exit()
end)

-- Move the focused window right one display.
modal:bind('', 'l', nil, function ()
  local window = hs.window.focusedWindow()

  window:moveOneScreenEast(true, true, 0)

  modal:exit()
end)

-- Exit the modal state.
modal:bind('', 'escape', nil, function ()
  modal:exit()
end)
