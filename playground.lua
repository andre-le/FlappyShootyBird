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
        -- tapCount = tapCount + 1
        -- tapText.text = tapCount

    end

-- shoot()
function shoot()
    local bullet = display.newImageRect( "laser.png", 30 , 30)
    bullet.x = bird.x
    bullet.y = bird.y
    bullet.isBullet = true
    bullet.myName = "bullet"
    sceneGroup:insert(bullet)
    physics.addBody( bullet, "dynamic", { isSensor=true } )
    transition.to( bullet, { y = bird.y, x=320, time=1000,
        onComplete = function() display.remove( bullet ) end
    } )
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

    bird = display.newImageRect( "flappy-bird.png", 100, 100 )
    bird.x = 16
    bird.y = display.contentCenterY
    bird.myName = "bird"
    sceneGroup:insert( bird )

    local physics = require( "physics" )
    physics.start()

    physics.addBody( bird, "dynamic", { radius=40, bounce=0.3 } )


    wall()

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

        if ( (obj2.myName == "stone" ) or (obj2.myName == "scoreDisplay" )
            or ( obj1.myName == "scoreDisplay") or ( obj1.myName == "stone") )
        then
            --if bird hit the stone
            if ((obj2.myName == "bird") or
                (obj1.myName == "bird"))
            then
                bird.alpha = 0
                composer.gotoScene("menu")
                timer.performWithDelay( 1000, reset )
            --in this case the bullet hit the stone
            else
                if (obj2.score == 1) then
                    display.remove(obj2.scoreDisplay)
                    display.remove(obj2)
                else
                    obj2.score = obj2.score - 1
                    obj2.scoreDisplay.text = obj2.score
                end
                display.remove(obj1)
            end
        end
    end
end

-- wall()
function wall()
            math.randomseed(os.time())

    for i = 0, 7, 1
    do
        local stone = display.newImageRect( "stone.jpg", 50 , 50)
        stone.x = 295
        stone.y = 70 * i
        stone.myName = "stone"
        sceneGroup:insert(stone)

        --generate random score for stone
        stone.score = math.random(1,10)

        --display the score next to the stone
        stone.scoreDisplay = display.newText( sceneGroup, stone.score, stone.x + 50, 
            stone.y, native.systemFontBold, 20 )
        stone.scoreDisplay:setTextColor( 0, 0, 0 )
        stone.scoreDisplay.myName = "scoreDisplay"

        physics.addBody( stone, "kinematic", { radius=20, bounce=0, isSensor=true } )
        stone:setLinearVelocity( -20, 0 )
        physics.addBody( stone.scoreDisplay, "kinematic", { radius=5})
        stone.scoreDisplay:setLinearVelocity( -20, 0 )
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
    if (bird ~= nil and bird.y ~= nil and (bird.y < 0 or bird.y > 520))
    then
        if (bird.y < 0)
        then
            bird.y = 0
        else
            bird.y = 520
        end
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
        --gameLoopTimer = timer.performWithDelay( 500, fireLaser, 0 )
        Runtime:addEventListener( "collision", collision )
        gameLoopTimer1 = timer.performWithDelay( 500, gameLoop, 0 )
        gameLoopTimer2 = timer.performWithDelay( 10, boundCheck, 0 )
        gameLoopTimer3 = timer.performWithDelay( 15000, wallLoop, 0 )
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
-- -----------------------------------------------------------------------------------

return scene
