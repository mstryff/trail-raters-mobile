local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local json = require( "json" )

local params

local getUsers
local loginUser

local usernameInput
local passwordInput
local message

local myData = require( "mydata" )

local function handleSignInButtonEvent( event )
    if ( "ended" == event.phase ) then
        getUsers()
    end
end

local function handleSignUpButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "signin", false )
        composer.gotoScene("signup", { effect = "crossFade", time = 333 })
    end
end

getUsers = function()
    local requestString = myData.host .. "/user"
    network.request(requestString, "GET", loginUser)
end

loginUser = function(event)
    if not event.isError then
        local response = json.decode(event.response)
        local loggedIn = false
        print("login")
        for v, k in pairs(response.Items) do
            if k.name == usernameInput.text and k.password == passwordInput.text then
                local params = {}
                params.name = k.name
                myData.username = k.name
                utility.saveTable(myData.username, "username.json")
                composer.removeScene( "signin", false )
                composer.gotoScene("profile", { effect = "crossFade", time = 333, params = params })
                loggedIn = true
            end
        end
        if not loggedIn then
            message.text = "Incorrect username or password"
        end
    else
        print(error)
        message.text = "Server Error: Connection Unavailable"
    end
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
--[[
    local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )
]]
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

    local signInBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.39, display.contentWidth * 0.9, display.contentHeight * 0.4, 20)
    signInBox.strokeWidth = 2
    signInBox:setFillColor(0.2,0.6,0.2, 0.8)
    signInBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local title = display.newText("Trail Raters", 100, 36, "Cronus Round", 36)
    title.x = display.contentCenterX
    title.y = display.contentHeight * 0.08
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local header = display.newText("Sign In", 100, 32, "Cronus Round", 32)
    header.x = display.contentCenterX
    header.y = display.contentHeight * 0.25
    header:setFillColor(0)
    sceneGroup:insert(header)

    message = display.newText("", 100, 20, "Cronus Round", 20)
    message.x = display.contentCenterX
    message.y = display.contentHeight * 0.29
    message:setFillColor(1, 0, 0)
    sceneGroup:insert(message)

    local usernameText = display.newText("Username", 100, 22, "Cronus Round", 22)
    usernameText.x = display.contentWidth * 0.2
    usernameText.y = display.contentHeight * 0.33
    usernameText:setFillColor(0)
    sceneGroup:insert(usernameText)

    usernameInput = native.newTextField(display.contentCenterX, display.contentHeight * 0.38, display.contentWidth * 0.7, 36)
    usernameInput.font = native.newFont("Cronus Round", 36)
    usernameInput:resizeFontToFitHeight()

    local passwordText = display.newText("Password", 100, 22, "Cronus Round", 22)
    passwordText.x = display.contentWidth * 0.2
    passwordText.y = display.contentHeight * 0.47
    passwordText:setFillColor(0)
    sceneGroup:insert(passwordText)

    passwordInput = native.newTextField(display.contentCenterX, display.contentHeight * 0.52, display.contentWidth * 0.7, 36)
    passwordInput.isSecure = true
    passwordInput.font = native.newFont("Cronus Round", 36)
    passwordInput:resizeFontToFitHeight()

    -- Create the widget
    local signInButton = widget.newButton({
        id = "button1",
        label = "Sign In",
        width = 300,
        height = 100,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 32,
        font = "Cronus Round",
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0.2,0.9,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSignInButtonEvent
    })
    signInButton.x = display.contentCenterX
    signInButton.y = display.contentHeight * 0.72
    sceneGroup:insert( signInButton )

    local signUpButton = widget.newButton({
        id = "button1",
        label = "Don't have an account yet? Sign up!",
        width = 300,
        height = 50,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 20,
        font = "Cronus Round",
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0.2,0.9,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSignUpButtonEvent
    })
    signUpButton.x = display.contentCenterX
    signUpButton.y = display.contentHeight * 0.9
    sceneGroup:insert( signUpButton )

end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
        composer.removeScene( "game" ) 
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    if usernameInput ~= nil then
        usernameInput:removeSelf()
        passwordInput:removeSelf()
    end
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
