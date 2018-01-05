local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function goToMenu()
    composer.gotoScene( "menu" )
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    sceneGroup = self.view

    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- background
    local background = display.newImageRect( "background.png", 320, 580 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    --buttons
    local menuButton = display.newText( sceneGroup, "Back To Menu", 50, 0, native.systemFontBold, 10 )
    menuButton:addEventListener( "tap", goToMenu )

    score = 0
    currentScore = display.newText( sceneGroup, "" .. score, 100, 0, native.systemFontBold, 10 )

    --ground
    local ground = display.newImageRect( "ground.png", 320, 50 )
    ground.x = display.contentCenterX
    ground.y = display.contentHeight
    sceneGroup:insert( ground )

    bird = display.newImageRect( "flappy-bird.png", 100, 100 )
    bird.x = display.contentCenterX
    bird.y = display.contentCenterY
    bird.myName = "bird"
    sceneGroup:insert( bird )




    local physics = require( "physics" )
    physics.start()

    --0...480

    physics.addBody( ground, "static" )
    physics.addBody( bird, "dynamic", { radius=40, bounce=0.3 } )


    wall()



    local function tap()
        bird:applyLinearImpulse( 0, -0.5, bird.x, bird.y )
        print("Y: " .. tostring(bird.y) .. " " .. tostring(display.contentHeight))
        -- tapCount = tapCount + 1
        -- tapText.text = tapCount
    end

    background:addEventListener( "tap", tap )
    -- bird:setLinearVelocity( 10, 0 )
end

-- reset()
function reset()
    transition.to( bird, { alpha=1, time=4000,
        onComplete = function()

        end
    })
end

-- collision()
function collision(event)
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if ( (obj2.myName == "stone" ) or
             ( obj1.myName == "stone") )
        then

            display.remove(obj2)
            if (obj2.myName == "bird")
            then
                bird.alpha = 0
                composer.gotoScene("menu")
                timer.performWithDelay( 1000, reset )
                display.remove(obj1)
            elseif(obj1.myName == "bird")
            then
                bird.alpha = 0
                composer.gotoScene("menu")
                timer.performWithDelay( 1000, reset )
                display.remove(obj2)
            else
                display.remove(obj2)
                display.remove(obj1)
            end
        end
    end
end

-- shoot()
function shoot()
    local bullet = display.newImageRect( "flappy-bird.png", 30 , 30)
    bullet.x = bird.x
    bullet.y = bird.y
    bullet.isBullet = true
    bullet.myName = "bullet"
    sceneGroup:insert(bullet)
    physics.addBody( bullet, "dynamic", { radius=5, bounce=0, isSensor=true } )
    transition.to( bullet, { x=340, time=1000,
        onComplete = function() display.remove( bullet ) end
    } )
end

-- wall()
function wall()
    for i = 0, 9, 1
    do
      local stone = display.newImageRect( "sbs-starexplorer-11.png", 50 , 50)
      stone.x = 295
      stone.y = 50 * i
      stone.myName = "stone"
      sceneGroup:insert(stone)
      physics.addBody( stone, "kinematic", { radius=20, bounce=0, isSensor=true } )
      stone:setLinearVelocity( -20, 0 )
    end
end

-- gameLoop()

function gameLoop()
    shoot()
    score = score + 1
    currentScore.text = "" .. score
end

-- wallLoop()

function wallLoop()
    wall()
end

function boundCheck()
    if (bird ~= nil and bird.y ~= nil and bird.y < 0)
    then
        bird.y = 0
        bird:setLinearVelocity( 0, 0 )
    end
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
        timer.cancel( gameLoopTimer1 )
        timer.cancel( gameLoopTimer2 )
        timer.cancel( gameLoopTimer3 )

    elseif ( phase == "did" ) then
        Runtime:removeEventListener( "collision", collision )
        physics.pause()
        composer.removeScene("playground")

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
Runtime:addEventListener( "collision", collision )
gameLoopTimer1 = timer.performWithDelay( 1000, gameLoop, 0 )
gameLoopTimer2 = timer.performWithDelay( 10, boundCheck, 0 )
gameLoopTimer3 = timer.performWithDelay( 15000, wallLoop, 0 )
-- -----------------------------------------------------------------------------------

return scene
