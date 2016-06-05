local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local function handleViewAllReportsButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "profile", false )
        composer.gotoScene("viewall", { effect = "slideLeft", time = 333 })
    end
end

local function handleViewMyReportsButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "profile", false )
        composer.gotoScene("viewmyreports", { effect = "slideRight", time = 333 })
    end
end

local function handleNewReportButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "profile", false )
        composer.gotoScene("writereport", { effect = "crossFade", time = 333 })
    end
end

local function handleSettingsButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "profile", false )
        composer.gotoScene("settings", { effect = "slideUp", time = 333 })
    end
end

local params
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

    local titleBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.12, display.contentWidth * 0.9, display.contentHeight * 0.16, 20)
    titleBox.strokeWidth = 2
    titleBox:setFillColor(0.2,0.6,0.2, 0.8)
    titleBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local title = display.newText("Trail Raters", 100, 32, native.systemFont, 32)
    title.x = display.contentCenterX
    title.y = display.contentHeight * 0.08
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local header = display.newText("Welcome, " .. myData.username, 100, 20, native.systemFont, 20)
    header.x = display.contentCenterX
    header.y = display.contentHeight * 0.16
    header:setFillColor(0)
    sceneGroup:insert(header)

    --View All Reports
    local viewAllReportsButton = widget.newButton({
        id = "button1",
        label = "View All Reports",
        width = 300,
        height = 100,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleViewAllReportsButtonEvent
    })
    viewAllReportsButton.x = display.contentCenterX
    viewAllReportsButton.y = display.contentHeight * 0.34
    sceneGroup:insert( viewAllReportsButton )

    --View My Reports
    local viewMyReportsButton = widget.newButton({
        id = "button1",
        label = "View My Reports",
        width = 300,
        height = 100,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleViewMyReportsButtonEvent
    })
    viewMyReportsButton.x = display.contentCenterX
    viewMyReportsButton.y = display.contentHeight * 0.54
    sceneGroup:insert( viewMyReportsButton )

    --Write Report
    local newReportButton = widget.newButton({
        id = "button1",
        label = "Write New Report",
        width = 300,
        height = 100,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleNewReportButtonEvent
    })
    newReportButton.x = display.contentCenterX
    newReportButton.y = display.contentHeight * 0.74
    sceneGroup:insert( newReportButton )

    local settingsButton = widget.newButton({
        id = "button1",
        label = "Settings",
        width = 300,
        height = 75,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSettingsButtonEvent
    })
    settingsButton.x = display.contentCenterX
    settingsButton.y = display.contentHeight * 0.91
    sceneGroup:insert( settingsButton )

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
