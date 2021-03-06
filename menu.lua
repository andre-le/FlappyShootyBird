local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- takes the game to setting
--local function gotoSettings()
--    composer.gotoScene( "gamesettings" )
--end

-- takes the game to the playground
local function playGame()
    composer.gotoScene( "playground", { time=300, effect="fade" } )
end 

local function showHighScores()
    composer.gotoScene( "highscores", { time=300, effect="fade" } )
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local background = display.newImageRect( sceneGroup, "background.png", 320, 580 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    --local title = display.newImageRect( sceneGroup, "title.png", 250, 25 ) -- assumes the title is 250x25
    --title.x = display.contentCenterX
    --title.y = 50

    local playButton = display.newText( sceneGroup, "Play!", display.contentCenterX, 160, native.systemFontBold, 20 )
    playButton:addEventListener( "tap", playGame )
    local highscoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 200, native.systemFontBold, 20 )
    highscoresButton:addEventListener( "tap", showHighScores )
    --local gameSettingsButton = display.newText( sceneGroup, "Settings", display.contentCenterX, 200, native.systemFontBold, 20 )
    --gameSettingsButton:addEventListener( "tap", gotoSettings )

end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene