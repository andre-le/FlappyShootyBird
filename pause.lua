local composer = require( "composer" )
 
local scene = composer.newScene()

function resume()
	composer.hideOverlay( "fade", 400 )
end 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local pause = display.newText( sceneGroup, "PAUSE", display.contentCenterX, 200, native.systemFontBold, 40 )
    local resumeButton = display.newText( sceneGroup, "Resume", display.contentCenterX, display.contentCenterY, native.systemFontBold, 20 )
    resumeButton:addEventListener( "tap", resume )

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

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object
 
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        parent:resumeGame()
    end
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene