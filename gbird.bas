SCREEN 7

TYPE TREE
    cx AS DOUBLE
    ch AS INTEGER
END TYPE

CONST NTREE = 6
DIM SHARED ballx, bally, ballr, dy, gravity, gscale, gameover AS DOUBLE
DIM SHARED thrust, tscale, dthrust, ithrust
DIM SHARED wingup AS INTEGER
DIM SHARED foodx, foody AS DOUBLE
DIM SHARED eatcount%
DIM SHARED plants(1 TO NTREE) AS TREE


_TITLE "Gravity Bird"

CALL IntroScreen
CALL InitWorld
CALL InitPlants

GameLoop:
IF gameover = 1 THEN
    PRINT "GAME OVER!!"
    PLAY "CC# DD# EF"
ELSE
    CALL DrawWorld
    CALL UpdateWorld

    key$ = RIGHT$(LCASE$(INKEY$), 1)
    IF key$ = "h" THEN
        CALL UpdateThrust(1)
    ELSE
        IF key$ = "p" THEN
            CALL UpdateThrust(0)
        END IF
    END IF

    IF key$ <> CHR$(27) THEN
        _DELAY 0.2
        GOTO GameLoop
    END IF
END IF


SUB IntroScreen ()
    CLS
    CIRCLE (150, 40), 20
    CIRCLE (148, 40), 2
    CIRCLE (152, 40), 2
    LINE (130, 40)-(124, 36)
    LINE (170, 40)-(176, 36)
    LOCATE 10, 14
    PRINT "GRAVITY BIRD"
    LOCATE 12, 9
    PRINT "<> Press UP to accelerate"
    LOCATE 14, 9
    PRINT "<> Press DOWN to decelerate"
    LOCATE 16, 9
    PRINT "<> Press any key to begin"
    PLAY "EDFCDE"
    WHILE INKEY$ = ""
    WEND
END SUB


SUB InitWorld ()
    ballx = 80
    bally = 60
    ballr = 10
    gravity = 9.8
    gscale = 0.01
    wingup = 1
    dy = 1
    gameover = 0
    thrust = 20
    tscale = 0.01
    dthrust = 2
    ithrust = 10
    CALL ResetFood
    eatcount% = 0
END SUB


SUB DrawWorld ()
    CLS
    CIRCLE (ballx, bally), ballr
    CIRCLE (ballx - 4, bally), 2
    CIRCLE (ballx + 4, bally), 2
    IF wingup = 1 THEN
        LINE (ballx + ballr, bally)-(ballx + ballr + 4, bally - 4)
        LINE (ballx - ballr, bally)-(ballx - ballr - 4, bally - 4)
    ELSE
        LINE (ballx + ballr, bally)-(ballx + ballr + 4, bally + 4)
        LINE (ballx - ballr, bally)-(ballx - ballr - 4, bally + 4)
    END IF
    LINE (1, 10)-(thrust, 10)
    CIRCLE (foodx, foody), 2
    LOCATE 1, 1
    PRINT "SCORE"; eatcount%
    FOR i = 1 TO NTREE
        LINE (plants(i).cx, 190)-(plants(i).cx, 190 - plants(i).ch)
        py = 190 - plants(i).ch
        pr = 1
        WHILE py + pr <= 190
            CIRCLE (plants(i).cx, py), pr, 250
            PAINT (plants(i).cx, py), 250
            py = py + pr
            pr = pr + 2
        WEND
    NEXT i
    LINE (0, 190)-(0, 400), 250
    LINE (0, 400)-(400, 400), 250
    LINE (400, 400)-(400, 190), 250
    LINE (0, 190)-(400, 190), 250
    PAINT (10, 192), 250
END SUB


SUB UpdateWorld ()
    IF wingup = 1 THEN
        wingup = 0
    ELSE
        wingup = 1
    END IF

    bally = bally + dy
    dy = dy + (gravity * gscale) - (tscale * thrust)

    IF thrust <= 0 THEN
        thrust = 0
    ELSE
        thrust = thrust - dthrust
    END IF

    IF foodx <= -20 THEN
        CALL ResetFood
    ELSE
        IF (foodx >= (ballx - ballr)) AND (foodx <= (ballx + ballr)) THEN
            IF (foody >= (bally - ballr)) AND (foody <= (bally + ballr)) THEN
                eatcount% = eatcount% + 1
                CALL ResetFood
            END IF
        END IF
    END IF
    foodx = foodx - 2
    IF foodx <= -10 THEN
        CALL ResetFood
    END IF

    IF bally >= 200 THEN
        gameover = 1
    ELSE
        IF bally <= -100 THEN
            gameover = 1
        END IF
    END IF

    CALL UpdatePlants
END SUB


SUB UpdateThrust (i)
    IF i = 1 THEN
        thrust = thrust + ithrust
    ELSE
        thrust = thrust - ithrust
    END IF
END SUB


SUB ResetFood ()
    foodx = 300 + 2
    foody = 50 + (RND * 50)
    SOUND 280, 2
END SUB


SUB InitPlants ()
    startx = 20
    FOR i = 1 TO NTREE
        plants(i).cx = startx + i * 50 + RND * 10
        plants(i).ch = 10 + RND * 20
    NEXT i
END SUB


SUB UpdatePlants ()
    FOR i = 1 TO NTREE
        IF plants(i).cx <= 6 THEN
            plants(i).cx = 294 + RND * 10 + 50 * i
        ELSE
            plants(i).cx = plants(i).cx - 2
        END IF
    NEXT i
END SUB


