local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local mySceneGroup
local whiteBackground
local background
local swapBackground

local function handleBambooButtonEvent(event)
    if event.phase == "ended" then
        myData.background = "bamboo"
        utility.saveTable(myData.background, "background.json")
        swapBackground("bamboo")
    end
end

local function handlePlankButtonEvent(event)
    if event.phase == "ended" then
        myData.background = "planks"
        utility.saveTable(myData.background, "background.json")
        swapBackground("planks")
    end
end

swapBackground = function(newImage)
    local tempBackground = display.newImageRect( "images/" .. newImage .. ".jpg", display.contentWidth, display.contentHeight )
    tempBackground.alpha = 0.93
    tempBackground.x = background.x
    tempBackground.y = background.y
    mySceneGroup:insert(tempBackground)
    background:removeSelf()
    background = nil
    background = tempBackground
    background:toBack()
    whiteBackground:toBack()
end

local function handleSignOutButtonEvent(event)
    if event.phase == "ended" then
        myData.username = nil
        utility.saveTable(myData.username, "username.json")
        composer.removeScene( "settings", false )
        composer.gotoScene("signin", { effect = "crossFade", time = 333, params = params })
    end
end

local function handleBackButtonEvent(event)
    if ( "ended" == event.phase ) then
        composer.removeScene( "settings", false )
        composer.gotoScene("profile", { effect = "slideDown", time = 333, params = params })
    end
end

local params
--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view
    mySceneGroup = sceneGroup
    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    whiteBackground = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    whiteBackground.x = display.contentCenterX
    whiteBackground.y = display.contentCenterY
    sceneGroup:insert( whiteBackground )

    background = display.newImageRect( "images/" .. myData.background .. ".jpg", display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.alpha = 0.93
    sceneGroup:insert( background )

    local titleBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.12, display.contentWidth * 0.9, display.contentHeight * 0.16, 20)
    titleBox.strokeWidth = 2
    titleBox:setFillColor(0.2,0.6,0.2, 0.8)
    titleBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local title = display.newText("Trail Raters", 100, 32, native.systemFont, 32)
    title.x = display.contentCenterX
    title.y = display.contentHeight * 0.08
    title:setFillColor(0)
    sceneGroup:insert(title)

    local header = display.newText("Settings", 100, 24, native.systemFont, 24)
    header.x = display.contentCenterX
    header.y = display.contentHeight * 0.16
    header:setFillColor(0)
    sceneGroup:insert(header)

    local backgroundBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.27, display.contentWidth * 0.9, display.contentHeight * 0.08, 20)
    backgroundBox.strokeWidth = 2
    backgroundBox:setFillColor(0.2,0.6,0.2, 0.8)
    backgroundBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local backgroundText = display.newText("Background", 100, 20, native.systemFont, 20)
    backgroundText.x = display.contentCenterX
    backgroundText.y = display.contentHeight * 0.27
    backgroundText:setFillColor(0)
    sceneGroup:insert(backgroundText)

    local plankButton = widget.newButton({
        id = "button1",
        label = "Plank",
        width = 150,
        height = 150,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handlePlankButtonEvent
    })
    plankButton.x = display.contentWidth * 0.27
    plankButton.y = display.contentHeight * 0.44
    sceneGroup:insert( plankButton )

    local bambooButton = widget.newButton({
        id = "button1",
        label = "Bamboo",
        width = 150,
        height = 150,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleBambooButtonEvent
    })
    bambooButton.x = display.contentWidth * 0.73
    bambooButton.y = display.contentHeight * 0.44
    sceneGroup:insert( bambooButton )

    local userBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.63, display.contentWidth * 0.9, display.contentHeight * 0.08, 20)
    userBox.strokeWidth = 2
    userBox:setFillColor(0.2,0.6,0.2, 0.8)
    userBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local userText = display.newText("User", 100, 20, native.systemFont, 20)
    userText.x = display.contentCenterX
    userText.y = display.contentHeight * 0.63
    userText:setFillColor(0)
    sceneGroup:insert(userText)

    local signOutButton = widget.newButton({
        id = "button1",
        label = "Log Out",
        width = 300,
        height = 100,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 28,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0.2,0.9,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSignOutButtonEvent
    })
    signOutButton.x = display.contentCenterX
    signOutButton.y = display.contentHeight * 0.765
    sceneGroup:insert( signOutButton )

    local backButton = widget.newButton({
        id = "button1",
        label = "Back",
        width = 300,
        height = 50,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 18,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0.2,0.9,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleBackButtonEvent
    })
    backButton.x = display.contentCenterX
    backButton.y = display.contentHeight * 0.92
    sceneGroup:insert( backButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
