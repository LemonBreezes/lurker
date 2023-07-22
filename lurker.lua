-- Make sure the shared library can be found through package.cpath before loading the module.
-- For example, if you put it in the LÖVE save directory, you could do something like this:
-- local lib_path = love.filesystem.getSaveDirectory() .. "/libraries"
local lib_path = "./libraries"
local extension = jit.os == "Windows" and "dll" or jit.os == "Linux" and "so" or jit.os == "OSX" and "dylib"
package.cpath = string.format("%s;%s/?.%s", package.cpath, lib_path, extension)
local imgui = require "cimgui"

local sti = require "sti"

local lurker = require "lurker"
lurker.postswap = function(file)
	-- reinit game here
    map = sti("assets/maps/world.lua")
end

love.load = function()
	love.window.setTitle("Cool Video Game")
    imgui.love.Init()

	local imio = imgui.GetIO()
	imio.ConfigFlags = imgui.love.ConfigFlags("NavEnableKeyboard", "DockingEnable")

    map = sti("assets/maps/world.lua")
end

love.draw = function()
	-- draw game here
    local game_canvas = love.graphics.newCanvas()
    love.graphics.setCanvas(game_canvas)
    map:draw(-60, -20, 8, 8)
    love.graphics.setCanvas()
    local size = imgui.ImVec2_Float(game_canvas:getDimensions())

	local viewport = imgui.GetMainViewport()
	imgui.DockSpaceOverViewport(viewport)

    -- draw windows here
    if imgui.Begin("Game") then
        imgui.Image(game_canvas, size)
    end
    imgui.End()
    imgui.ShowDemoWindow()

    -- code to render imgui
    imgui.Render()
    imgui.love.RenderDrawLists()
end

love.update = function(dt)
    print(dt)
	lurker.update()
    imgui.love.Update(dt)
    imgui.NewFrame()

    map:update(dt)
end

love.mousemoved = function(x, y, ...)
    imgui.love.MouseMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here
    end
end

love.mousepressed = function(x, y, button, ...)
    imgui.love.MousePressed(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end

love.mousereleased = function(x, y, button, ...)
    imgui.love.MouseReleased(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end

love.wheelmoved = function(x, y)
    imgui.love.WheelMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end

love.keypressed = function(key, ...)
    imgui.love.KeyPressed(key)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

love.keyreleased = function(key, ...)
    imgui.love.KeyReleased(key)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

love.textinput = function(t)
    -- only use imgui.love.TextInput when characters are expected
    if imgui.love.GetWantCaptureKeyboard() then
        imgui.love.TextInput(t)
    else
        -- your code here 
    end
end

love.quit = function()
    return imgui.love.Shutdown()
end

-- for gamepad support also add the following:

love.joystickadded = function(joystick)
    imgui.love.JoystickAdded(joystick)
    -- your code here 
end

love.joystickremoved = function(joystick)
    imgui.love.JoystickRemoved()
    -- your code here 
end

love.gamepadpressed = function(joystick, button)
    imgui.love.GamepadPressed(button)
    -- your code here 
end

love.gamepadreleased = function(joystick, button)
    imgui.love.GamepadReleased(button)
    -- your code here 
end

-- choose threshold for considering analog controllers active, defaults to 0 if unspecified
local threshold = 0.2 

love.gamepadaxis = function(joystick, axis, value)
    imgui.love.GamepadAxis(axis, value, threshold)
    -- your code here 
end
