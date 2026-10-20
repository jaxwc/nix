-- tmux-style prefix (Hyper+S, same as the old tmux prefix)
local P = "ctrl+alt+shift+cmd+s"
local function bind(key, action, args) rex.bind(P .. ">" .. key, action, args) end

-- utilities
bind("r", "client.config.reload")
bind("shift+/", "client.palette.toggle") -- prefix ?
bind("/", "client.find.open")

-- tabs (tmux windows)
bind("c", "client.tab.new")
bind("n", "client.tab.next")
bind("p", "client.tab.previous")
bind(",", "client.tab.rename")
bind("shift+7", "client.tab.close") -- prefix &
bind("shift+,", "client.tab.move.backward") -- prefix <
bind("shift+.", "client.tab.move.forward") -- prefix >
for i = 1, 9 do
  bind(tostring(i), "client.tab.goto", { index = i })
end

-- sessions
bind("o", "session.switch")
bind("shift+9", "session.previous") -- prefix (
bind("shift+0", "session.next") -- prefix )
bind("shift+n", "session.new")
bind("shift+4", "session.rename") -- prefix $
bind("shift+d", "session.close")

-- panes
bind("shift+\\", "pane.split", { direction = "right" }) -- prefix |
bind("-", "pane.split", { direction = "down" })
bind("h", "pane.focus", { direction = "left" })
bind("j", "pane.focus", { direction = "down" })
bind("k", "pane.focus", { direction = "up" })
bind("l", "pane.focus", { direction = "right" })
bind(";", "pane.focus_previous")
bind("m", "pane.zoom")
bind("x", "pane.close")
bind("=", "pane.balance")
bind("shift+[", "pane.move", { direction = "left" }) -- prefix {
bind("shift+]", "pane.move", { direction = "right" }) -- prefix }
bind("shift+1", "pane.move_to_new_tab") -- prefix ! (break-pane)

-- resize mode (tmux bind -r): prefix R, then hjkl; esc/enter to leave
rex.mode("resize", { exclusive = true })
bind("shift+r", "client.mode.enter", { name = "resize" })
for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
  rex.bind("resize/" .. key, "pane.resize", { direction = dir })
  rex.bind("resize/shift+" .. key, "pane.resize", { direction = dir, amount = 15 })
end
rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
