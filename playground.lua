local composer = require( "composer" )

local scene = composer.newScene()

local buttonsGroup = display.newGroup()

local bird
local bulletPow = 2
local bulletSpeed = 1000
local score = 0
math.randomseed(os.time())
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function goToMenu()
    composer.gotoScene( "menu" )
end

local function tap()
        bird:applyLinearImpulse( 0, -0.5, bird.x, bird.y )
        -- tapCount = tapCount + 1
        -- tapText.text = tapCount
    end

-- shoot()
function shoot()
    for i = 1, bulletPow, 1
    do
        local bullet = display.newImageRect( "laser.png", 30 , 30)
        bullet.x = bird.x
        bullet.y = bird.y
        bullet.isBullet = true
        bullet.myName = "bullet"
        sceneGroup:insert(bullet)
        physics.addBody( bullet, "dynamic", { isSensor=true } )
        transition.to( bullet, { y = bird.y, x=320, time=bulletSpeed,
            onComplete = function() display.remove( bullet ) end
        } )
    end
end

-- pause()
function pause()
    physics.pause()
    transition.pause()
    timer.pause( gameLoopTimer1 )
    composer.showOverlay( "pause", { isModal = true, time=300, effect="fade" } )
end

-- Custom function for resuming the game (from pause state)
function scene:resumeGame()
    --code to resume game
    transition.resume()
    physics.start()
    timer.resume( gameLoopTimer1 )
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


    local pauseButton = display.newText( sceneGroup, "Pause", 120, 0, native.systemFontBold, 10 )
    pauseButton:addEventListener( "tap", pause )
    pauseButton:toFront()

    currentScore = display.newText( sceneGroup, "" .. score, display.contentCenterX, 50, native.systemFontBold, 30 )

    bird = display.newImageRect( "flappy-bird.png", 100, 100 )
    bird.x = 16
    bird.y = display.contentCenterY
    bird.myName = "bird"
    sceneGroup:insert( bird )

    physics = require( "physics" )
    physics.start()

    physics.addBody( bird, "dynamic", { radius=40, bounce=0.3 } )


    wall()

    background:addEventListener( "tap", tap )
end

-- gameover()
function gameover()
    bird.alpha = 0
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=300, effect="fade" } )
end

-- power(x, y)
function power(x, y)
    local powerup = display.newImageRect( "flappy-bird.png", 50 , 50)
    powerup.x = x
    powerup.y = y
    powerup.myName = "powerup"
    sceneGroup:insert(powerup)
    physics.addBody( powerup, "kinematic", { radius=20, bounce=0, isSensor=true } )
    transition.to( powerup, { y = y, x=-50, time=10000,
        onComplete = function() display.remove( powerup ) end
    } )
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
                gameover()
            --in this case the bullet hit the stone
            else
                if (obj2.score == 1 or bulletPow == -1) then
                    display.remove(obj2.scoreDisplay)
                    display.remove(obj2)
                else
                    obj2.score = obj2.score - 1
                    obj2.scoreDisplay.text = obj2.score
                end
                display.remove(obj1)
            end
        end

        if (obj2.myName == "powerup" or obj1.myName == "powerup") and (obj2.myName == "bird" or obj1.myName == "bird")
        then
          local type = math.random(1,3)
          print(type)
          if type == 1 then bulletPow = bulletPow + 1
          elseif type == 2 then bulletSpeed = bulletSpeed/2
          elseif type == 3 then bulletPow = score end
          if(obj1.myName == "bird") then display.remove(obj2)
          else display.remove(obj1) end
        end
    end
end

-- wall()
function wall()


    for i = 0, 7, 1
    do
        local stone = display.newImageRect( "stone.jpg", 50 , 50)
        stone.x = 295
        stone.y = 70 * i
        stone.myName = "stone"
        sceneGroup:insert(stone)

        --generate random score for stone
        stone.score = math.random(1,10)
        if stone.score == 5 then power(stone.x, stone.y) end
        --display the score next to the stone
        stone.scoreDisplay = display.newText( sceneGroup, stone.score, stone.x + 50,
            stone.y, native.systemFontBold, 20 )
        stone.scoreDisplay:setTextColor( 0, 0, 0 )
        stone.scoreDisplay.myName = "scoreDisplay"

        physics.addBody( stone, "kinematic", { radius=20, bounce=0, isSensor=true } )
        transition.to( stone, { y = stone.y, x=-50, time=10000,
            onComplete = function() display.remove( stone ) end
        } )
        physics.addBody( stone.scoreDisplay, "kinematic", { radius=5})
        transition.to( stone.scoreDisplay, { y = stone.scoreDisplay.y, x=0, time=10000,
            onComplete = function() display.remove( stone.scoreDisplay ) end
        } )
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
        gameover()
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
        transition.cancel()
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
