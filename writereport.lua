local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local inputTrail
local inputLatitude
local inputLongitude
local inputText
local inputRating
local message

local params

local submitReport
local reportSubmitted
local onLocationEvent

local function handleSetCoordinatesButtonEvent( event )
    if ( "ended" == event.phase ) then
        print("set coordinates")
        Runtime:addEventListener("location", onLocationEvent)
    end
end

onLocationEvent = function(event)
    Runtime:removeEventListener("location", onLocationEvent)
    if event.errorCode then
        print("GPS Location Error: ".. tostring( event.errorMessage ))
    else
        inputLatitude.text = string.format("%.2f", tostring(event.latitude))
        inputLongitude.text = string.format("%.2f", tostring(event.longitude))
    end
end

local function handleSubmitReportButtonButtonEvent( event )
    if ( "ended" == event.phase ) then
        submitReport()
    end
end

submitReport = function()
    if inputTrail.text == "" then
        message.text = "You must enter a trail name"
    elseif inputRating.text == "" then
        message.text = "You must enter a rating"
    else
        local requestString = myData.host .. "/report?trail=" .. inputTrail.text .. "&latitude=" .. inputLatitude.text .. "&longitude=" .. inputLongitude.text .. "&text=" .. inputText.text .. "&rating=" .. inputRating.text .. "&userId=" .. 100001 .. "&username=" .. myData.username
        requestString = string.gsub(requestString, " ", "+")
        network.request(requestString, "POST", reportSubmitted)
    end
end

reportSubmitted = function(event)
    composer.removeScene( "writereport", false )
    composer.gotoScene("viewmyreports", { effect = "crossFade", time = 333 })
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

    local title = display.newText("Trail Raters", 100, 32, native.systemFont, 32)
    title.x = display.contentCenterX
    title.y = display.contentHeight * 0.08
    title:setFillColor(0)
    sceneGroup:insert(title)

    local writeBox = display.newRoundedRect( sceneGroup, display.contentCenterX, display.contentHeight * 0.4475, display.contentWidth * 0.9, display.contentHeight * 0.615, 20)
    writeBox.strokeWidth = 2
    writeBox:setFillColor(0.2,0.6,0.2, 0.8)
    writeBox:setStrokeColor(0.2,0.9,0.4, 0.9)

    local header = display.newText("Write Report", 100, 24, native.systemFont, 24)
    header.x = display.contentCenterX
    header.y = display.contentHeight * 0.18
    header:setFillColor(0)
    sceneGroup:insert(header)

    message = display.newText("", 100, 16, native.systemFont, 16)
    message.x = display.contentCenterX
    message.y = display.contentHeight * 0.22
    message:setFillColor(1, 0, 0)
    sceneGroup:insert(message)

    local trailText = display.newText("Trail Name", 100, 18, native.systemFont, 18)
    trailText.x = display.contentWidth * 0.1 + trailText.contentWidth * 0.5
    trailText.y = display.contentHeight * 0.26
    trailText:setFillColor(0)
    sceneGroup:insert(trailText)

    inputTrail = native.newTextField(display.contentCenterX, display.contentHeight * 0.31, display.contentWidth * 0.7, 32)

    local ratingText = display.newText("Rating", 100, 18, native.systemFont, 18)
    ratingText.x = display.contentWidth * 0.1 + ratingText.contentWidth * 0.5
    ratingText.y = display.contentHeight * 0.36
    ratingText:setFillColor(0)
    sceneGroup:insert(ratingText)

    inputRating = native.newTextField(display.contentCenterX, display.contentHeight * 0.41, display.contentWidth * 0.7, 32)

    local textText = display.newText("Notes", 100, 18, native.systemFont, 18)
    textText.x = display.contentWidth * 0.1 + textText.contentWidth * 0.5
    textText.y = display.contentHeight * 0.46
    textText:setFillColor(0)
    sceneGroup:insert(textText)

    inputText = native.newTextField(display.contentCenterX, display.contentHeight * 0.51, display.contentWidth * 0.7, 32)

    local latitudeText = display.newText("Latitude", 100, 18, native.systemFont, 18)
    latitudeText.x = display.contentWidth * 0.1 + latitudeText.contentWidth * 0.5
    latitudeText.y = display.contentHeight * 0.56
    latitudeText:setFillColor(0)
    sceneGroup:insert(latitudeText)

    inputLatitude = native.newTextField(display.contentCenterX, display.contentHeight * 0.61, display.contentWidth * 0.7, 32)

    local longitudeText = display.newText("Longitude", 100, 18, native.systemFont, 18)
    longitudeText.x = display.contentWidth * 0.1 + longitudeText.contentWidth * 0.5
    longitudeText.y = display.contentHeight * 0.66
    longitudeText:setFillColor(0)
    sceneGroup:insert(longitudeText)

    inputLongitude = native.newTextField(display.contentCenterX, display.contentHeight * 0.71, display.contentWidth * 0.7, 32)

    local setCoordinatesButton = widget.newButton({
        label = "Set Lat/Lon to Current Coordinates",
        width = 300,
        height = 40,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 16,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSetCoordinatesButtonEvent
    })
    setCoordinatesButton.x = display.contentCenterX
    setCoordinatesButton.y = display.contentHeight * 0.8
    sceneGroup:insert( setCoordinatesButton )

    local submitReportButton = widget.newButton({
        label = "Submit Report",
        width = 300,
        height = 80,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 24,
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleSubmitReportButtonButtonEvent
    })
    submitReportButton.x = display.contentCenterX
    submitReportButton.y = display.contentHeight * 0.91
    sceneGroup:insert( submitReportButton )
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

    inputLongitude:removeSelf()
    inputText:removeSelf()
    inputRating:removeSelf()
    inputTrail:removeSelf()
    inputLatitude:removeSelf()
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
