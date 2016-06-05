local composer = require( "composer" )
local widget = require( "widget" )
local ads = require( "ads" )
local store = require( "store" )
local gameNetwork = require("gameNetwork")
local utility = require( "utility" )
local myData = require( "mydata" )
local device = require( "device" )

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() )

if device.isAndroid then
	widget.setTheme( "widget_theme_android_holo_light" )
    store = require("plugin.google.iap.v3")
end

--
-- Load saved in settings
--

--
-- Initialize ads
--

--
-- Put your Ad listener and init code here
--

--
-- Initialize in app purchases
--

--
-- Put your IAP code here
--


--
-- Initialize gameNetwork
--

--
-- Put your gameNetwork login handling code here
--

--
-- Load your global sounds here
-- Load scene specific sounds in the scene
--
-- myData.splatSound = audio.load("audio/splat.wav")
--

--
-- Other system events
--
local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName
    print( event.phase, event.keyName )

    if ( "back" == keyName and phase == "up" ) then
        local currentScene = composer.getCurrentSceneName()
        if ( currentScene == "profile" ) then
            native.requestExit()
        else
            composer.removeScene(currentScene, false)
            composer.gotoScene( "profile", { effect="crossFade", time=500 } )
        end
        return true
    end
    return false
end

--add the key callback
if device.isAndroid then
    Runtime:addEventListener( "key", onKeyEvent )
end

--
-- handle system events
--
local function systemEvents(event)
    print("systemEvent " .. event.type)
    if event.type == "applicationSuspend" then

    elseif event.type == "applicationResume" then
        -- 
        -- login to gameNetwork code here
        --
    elseif event.type == "applicationExit" then

    elseif event.type == "applicationStart" then
        --
        -- Login to gameNetwork code here
        --
        --
        -- Go to the menu
        --
        local fonts = native.getFontNames()
        utility.print_r(fonts)

        system.setIdleTimer(true)
        local params = {}
        params.name = "joey fatone"
        myData.username = "joey fatone"
        myData.background = utility.loadTable("background.json")
        if myData.background == nil then
            myData.background = "planks"
            utility.saveTable(myData.background, "background.json")
        end

        myData.username = utility.loadTable("username.json")
        if myData.username == nil then
            composer.gotoScene( "signin", { time = 250, effect = "fade", params = params } )
        else
            composer.gotoScene( "profile", { time = 250, effect = "fade", params = params } )
        end
        
    end
    return true
end
Runtime:addEventListener("system", systemEvents)
