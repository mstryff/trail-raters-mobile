local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local passwordInput
local usernameInput
local message

local signUpUser

local params

local function handleSignUpButtonEvent( event )
    if ( "ended" == event.phase ) then
        if usernameInput.text == "" or passwordInput.text == "" then
            message.text = "You must enter a username and password"
        else
            signUpUser()
        end
    end
end

local function handleBackButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "signup", false )
        composer.gotoScene("signin", { effect = "crossFade", time = 333, params = params })
    end
end

signUpUser = function()
    local requestString = myData.host .. "/user?name=" .. usernameInput.text .. "&password=" .. passwordInput.text
    network.request(requestString, "POST", loginUser)
end

loginUser = function()
    local params = {}
    params.name = usernameInput.text
    myData.username = usernameInput.text
    utility.saveTable(myData.username, "username.json")
    composer.removeScene( "signup", false )
    composer.gotoScene("profile", { effect = "crossFade", time = 333, params = params })
end

--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local whiteBackground = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    whiteBackground.x = display.contentCenterX
    whiteBackground.y = display.contentCenterY
    sceneGroup:insert( whiteBackground )

    local background = display.newImageRect( "images/" .. myData.background .. ".jpg", display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    background.alpha = 0.93
    sceneGroup:insert( background )

    local titleBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.08, display.contentWidth * 0.9, display.contentHeight * 0.08, 20)
    titleBox.strokeWidth = 2
    titleBox:setFillColor(0.2,0.6,0.2, 0.8)
    titleBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local signUpBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.39, display.contentWidth * 0.9, display.contentHeight * 0.4, 20)
    signUpBox.strokeWidth = 2
    signUpBox:setFillColor(0.2,0.6,0.2, 0.8)
    signUpBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local title = display.newText("Trail Raters", 100, 32, native.systemFont, 32)
    title.x = display.contentCenterX
    title.y = display.contentHeight * 0.08
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local header = display.newText("Sign Up", 100, 28, native.systemFont, 28)
    header.x = display.contentCenterX
    header.y = display.contentHeight * 0.25
    header:setFillColor(0)
    sceneGroup:insert(header)

    message = display.newText("", 100, 16, native.systemFont, 16)
    message.x = display.contentCenterX
    message.y = display.contentHeight * 0.29
    message:setFillColor(1, 0, 0)
    sceneGroup:insert(message)

    local usernameText = display.newText("Username", 100, 18, native.systemFont, 18)
    usernameText.x = display.contentWidth * 0.2
    usernameText.y = display.contentHeight * 0.33
    usernameText:setFillColor(0)
    sceneGroup:insert(usernameText)

    usernameInput = native.newTextField(display.contentCenterX, display.contentHeight * 0.38, display.contentWidth * 0.7, 32)

    local passwordText = display.newText("Password", 100, 18, native.systemFont, 18)
    passwordText.x = display.contentWidth * 0.2
    passwordText.y = display.contentHeight * 0.47
    passwordText:setFillColor(0)
    sceneGroup:insert(passwordText)

    passwordInput = native.newTextField(display.contentCenterX, display.contentHeight * 0.52, display.contentWidth * 0.7, 32)
    passwordInput.isSecure = true

    -- Create the widget
    local signUpButton = widget.newButton({
        id = "button1",
        label = "Sign Up",
        width = 300,
        height = 100,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 28,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSignUpButtonEvent
    })
    signUpButton.x = display.contentCenterX
    signUpButton.y = display.contentHeight * 0.72
    sceneGroup:insert( signUpButton )

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
    backButton.y = display.contentHeight * 0.9
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
    usernameInput:removeSelf()
    passwordInput:removeSelf()
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
