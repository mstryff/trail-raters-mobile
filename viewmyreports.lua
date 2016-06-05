local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )
local json = require( "json" )

local drawReports
local onDelete

local params
local reportGroup
local reports

local trailText = {}
local ratingText = {}
local indexText = {}
local latitudeText = {}
local longitudeText = {}
local usernameText = {}
local descriptionText = {}

local function handleEditButtonEvent( event )
    if ( "ended" == event.phase ) then
        local id = event.target.id
        for v, k in ipairs(reports) do
            if k.id == id then
                data = k
            end
        end
        local params = {}
        params.trail = data.trail
        params.rating = data.rating
        params.latitude = data.latitude
        params.longitude = data.longitude
        params.description = data.text
        params.id = id

        composer.removeScene( "viewmyreports", false )
        composer.gotoScene("editreport", { effect = "crossFade", time = 333, params = params })
    end
end

local function handleDeleteButtonEvent( event )
    if ( "ended" == event.phase ) then
        local id = event.target.id
        local requestString = myData.host .. "/report/" .. id
        network.request(requestString, "DELETE", onDelete)
    end
end

local function handleBackButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene( "viewmyreports", false )
        composer.gotoScene("profile", { effect = "slideLeft", time = 333, params = params })
    end
end

onDelete = function()
    composer.removeScene( "viewmyreports", false )
    composer.gotoScene("viewmyreports", { effect = "crossFade", time = 333})
end

local populateReports = function(event)
    if not event.isError then
        local response = json.decode(event.response)
        reports = response.Items
        drawReports(reports)
    end
end

drawReports = function(reports)    
    for v, k in ipairs(reports) do
        if k.username == myData.username then
            local index = #trailText

            local stripe = display.newRect(reportGroup, display.contentCenterX, display.contentHeight * 0.2 * index + 50, display.contentWidth, display.contentHeight * 0.2)
            if index % 2 == 0 then
                stripe:setFillColor(0.65, 0.8, 0.65, 0.8)
            else
                stripe:setFillColor(1, 0.8)
            end

            local trail = display.newText(k.trail, 100, 20, "Cronus Round", 20)
            trail.x = display.contentWidth * 0.06 + trail.contentWidth * 0.5
            trail.y = display.contentHeight * 0.2 * index
            trail:setFillColor(0)
            reportGroup:insert(trail)
            table.insert(trailText, trail)

            local rating = display.newText(k.rating .. " / 5", 100, 20, "Cronus Round", 20)
            rating.x = display.contentWidth * 0.51 + rating.contentWidth * 0.5
            rating.y = display.contentHeight * 0.2 * index
            rating:setFillColor(0)
            reportGroup:insert(rating)
            table.insert(ratingText, rating)

            local latitude = display.newText("Lat: " .. k.latitude, 100, 18, "Cronus Round", 18)
            latitude.x = display.contentWidth * 0.06 + latitude.contentWidth * 0.5
            latitude.y = (display.contentHeight * 0.2 * index) + 40
            latitude:setFillColor(0)
            reportGroup:insert(latitude)
            table.insert(latitudeText, latitude)

            local longitude = display.newText("Lon: " .. k.longitude, 100, 18, "Cronus Round", 18)
            longitude.x = display.contentWidth * 0.51 + longitude.contentWidth * 0.5
            longitude.y = (display.contentHeight * 0.2 * index) + 40
            longitude:setFillColor(0)
            reportGroup:insert(longitude)
            table.insert(longitudeText, longitude)

            local username = display.newText(k.username, 100, 18, "Cronus Round", 18)
            username.x = display.contentWidth * 0.06 + username.contentWidth * 0.5
            username.y = (display.contentHeight * 0.2 * index) + 20
            username:setFillColor(0)
            reportGroup:insert(username)
            table.insert(usernameText, username)

            local description = display.newText(k.text, 100, 18, "Cronus Round", 18)
            description.x = display.contentWidth * 0.06 + description.contentWidth * 0.5
            description.y = (display.contentHeight * 0.2 * index) + 60
            description:setFillColor(0)
            reportGroup:insert(description)
            table.insert(descriptionText, description)

            local editButton = widget.newButton({
                id = k.id,
                label = "Edit",
                width = 60,
                height = 32,
                shape = "roundedRect",
                cornerRadius = 5,
                fontSize = 20,
                font = "Cronus Round",
                fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
                strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
                strokeWidth = 4,
                onEvent = handleEditButtonEvent
            })
            editButton.x = display.contentWidth * 0.08 + editButton.contentWidth * 0.5
            editButton.y = (display.contentHeight * 0.2 * index) + 90
            reportGroup:insert( editButton )

            local deleteButton = widget.newButton({
                id = k.id,
                label = "Delete",
                width = 60,
                height = 32,
                shape = "roundedRect",
                cornerRadius = 5,
                fontSize = 20,
                font = "Cronus Round",
                fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
                strokeColor = { default={0,0.8,0.4,1}, over={0.8,1,0.8,1} },
                strokeWidth = 4,
                onEvent = handleDeleteButtonEvent
            })
            deleteButton.x = display.contentWidth * 0.53 + deleteButton.contentWidth * 0.5
            deleteButton.y = (display.contentHeight * 0.2 * index) + 90
            reportGroup:insert( deleteButton )
        end
    end
    scrollView:setScrollHeight(#trailText * display.contentHeight * 0.2 + 35)
    if #trailText == 0 then
        local message = display.newText("No reports to display", 100, 22, "Cronus Round", 22)
        message.x = scrollView.contentWidth / 2
        message.y = (display.contentHeight * 0.2)
        message:setFillColor(0)
        reportGroup:insert(message)
        scrollView.alpha = 0.8
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

    local title = display.newText("Trail Raters", 100, 36, "Cronus Round", 36)
    title.x = display.contentCenterX
    title.y = display.contentHeight * 0.08
    title:setFillColor(0)
    sceneGroup:insert(title)

    local header = display.newText("My Trail Reports", 100, 28, "Cronus Round", 28)
    header.x = display.contentCenterX
    header.y = display.contentHeight * 0.16
    header:setFillColor(0)
    sceneGroup:insert(header)

    scrollView = widget.newScrollView({
        top = display.contentHeight * 0.23,
        left = display.contentWidth * 0.05,
        width = display.contentWidth * 0.9,
        height = display.contentHeight * 0.65,
        backgroundColor = { 1, 1, 1, 0 },
        horizontalScrollDisabled = true,
        isBounceEnabled = false,
        isLocked = false,
        bottomPadding = -18,
        topPadding = -17,
        hideScrollBar = false,
        listener = scrollListener
    })
    sceneGroup:insert(scrollView)

    reportGroup = display.newGroup()
    scrollView:insert(reportGroup)
    reportGroup.y = display.contentHeight * 0.05

    local backButton = widget.newButton({
        id = "button1",
        label = "Back",
        width = 300,
        height = 50,
        shape = "roundedRect",
        cornerRadius = 5,
        fontSize = 22,
        font = "Cronus Round",
        fillColor = { default={0.2,0.6,0.2,1}, over={0.1,1,0.7,0.4} },
        strokeColor = { default={0.2,0.9,0.4,1}, over={0.8,1,0.8,1} },
        strokeWidth = 4,
        onEvent = handleBackButtonEvent
    })
    backButton.x = display.contentCenterX
    backButton.y = display.contentHeight * 0.93
    sceneGroup:insert( backButton )

    local requestString = myData.host .. "/report"
    network.request(requestString, "GET", populateReports)
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
