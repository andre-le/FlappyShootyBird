local composer = require( "composer" )
 
local scene = composer.newScene()
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object
 
    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        parent:resumeGame()
    end
end
 
-- By some method (a "resume" button, for example), hide the overlay
composer.hideOverlay( "fade", 400 )
 
scene:addEventListener( "hide", scene )
return scene