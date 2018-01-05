local composer = require( "composer" )
 
local scene = composer.newScene()

local bird
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function goToMenu()
    composer.gotoScene( "menu" )
end 

local function tap()
        bird:applyLinearImpulse( 0, -0.75, bird.x, bird.y )
        print("Y: " .. tostring(bird.y) .. " " .. tostring(display.contentHeight))
        -- tapCount = tapCount + 1
        -- tapText.text = tapCount

        if bird.y < 0 or bird.y > 480 then
            print ("game over")
        end
    end

local function fireLaser()
 
        local newLaser = display.newImageRect( "laser.png", 14, 40 )
        physics.addBody( newLaser, "dynamic", { isSensor=true } )
        newLaser.isBullet = true
        newLaser.myName = "laser"
     
        newLaser.x = bird.x
        newLaser.y = bird.y
        --newLaser:toBack()
     
        transition.to( newLaser, { y = bird.y, x=320, time=700,
            onComplete = function() display.remove( newLaser ) end
        } )

    end
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    -- backgroud
    local background = display.newImageRect( "background.png", 320, 580 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    --buttons
    local menuButton = display.newText( sceneGroup, "Back To Menu", 50, 0, native.systemFontBold, 10 )
    menuButton:addEventListener( "tap", goToMenu )

    --ground
    local ground = display.newImageRect( "ground.png", 320, 50 )
    ground.x = display.contentCenterX
    ground.y = display.contentHeight
    sceneGroup:insert( ground )

    --bird
    bird = display.newImageRect( "flappy-bird.png", 112, 112 )
    bird.x = display.contentCenterX
    bird.y = display.contentCenterY
    sceneGroup:insert( bird )

    local physics = require( "physics" )
    physics.start()

    --0...480

    physics.addBody( ground, "static" )
    physics.addBody( bird, "dynamic", { radius=50, bounce=0.1 } )

    background:addEventListener( "tap", tap )
    --bird:setLinearVelocity( 10, 0 )

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 500, fireLaser, 0 )
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
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