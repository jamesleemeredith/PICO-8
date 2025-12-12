# PICO-8 Notes

## What is Pico-8?
PICO-8 is a "fantasy console"—a virtual system for making, sharing, and playing tiny retro-style games, running on Windows, Mac, Linux, and web browsers, known for its intentionally limited specs (128x128 screen, 16 colors, Lua scripting) that encourage creativity and simplicity, bundling all tools (code, sprite, sound editors) into one environment for easy game development and exploration. It offers a fun, constrained way for beginners and pros to prototype ideas, with games saved as steganographic PNG images that contain both art and code, easily playable in its built-in browser (Splore) or exported. 

## THE MENU:
- PICO-8 functions in a command-line style for navigating directories, loading, running games, etc.
- Type "HELP" in the console to pull up the list of commands

## CONFIGURING PICO-8:
- You can use the "CONFIG" command to alter various configuration options for PICO-8

### RUN COMMANDS:
- run -- runs the game
- Esc key -- pauses the game
- resume -- resumes the game
- . -- resumes the game for one frame and then pauses again

## THE CODE EDITOR:
- The first thing that pops up after hitting the "Esc" key from the main menu
- code is separated via tabs (which are really just commented out "-->8" symbols in the code files), but can reference code from other tabs freely - feel free to use them to organize code and reference code created on other tabs
- To simulate developing for retro games of the past, PICO-8 limits you to a maximum of 8192 "tokens", or 65535 characters (whichever you hit first)

### Shortcuts:
(complete later)

## SCREEN COORDINATES:
- Coordinates in PIC0-8 work like in other programs

## FUNCTIONS:
- CLS(color) --Clear Screen
- PSET(x,y,color) --Pixel Set
- PRINT(object,x,y,color) --Prints to the screen
- LINE(x1,y1,x2,y2,color) --Draws a line
- RECT(x1,y1,x2,y2,color) --Draws a rectangle
- RECTFILL(x1,y1,x2,y2,color) --Draws a filled rectangle
- OVAL(x1,y1,x2,y2,color)
- OVALFILL(x1,y1,x2,y2,color)
- CIRC(centerpoint_x,centerpoint_y,radius, color)
- CIRCFILL(centerpoint_x,centerpoint_y,radius, color)

## VARIABLES:
- hold any number of data types, can vary

### DATA TYPES:
- string
- number
- Boolean

## DRAW ORDER:
- There are no layers on the screen in PICO-8, everything is drawn on the screen according to the draw order

## RELATIVE POSITION:
- Use it! Major time saver

## THE GAME LOOP:
A game loop is the fundamental, continuous cycle that keeps a video game running, handling player input, updating game logic (like movement, physics, AI), and rendering the updated graphics to the screen, repeating this process rapidly to create the illusion of smooth, real-time action.
- The game screen updates 30-60 times per second, depending on your frame rate
- Each of these updates of the screen is referred to as a "frame" (ex. 60 fps)
- Each frame consists of a game loop with the following two steps:
  1. Update: Handles input from the player, updates any variables, etc. in order to keep up with the games' current state
  2. Draw: Renders the visual output of such updates to the screen (ex. moving the player sprite in response to a button press identified during the "Update" step)

We have to create a _DRAW() and _UPDATE function in PICO-8:
function _update()
 --add stuff here
end

function _draw()
 --add stuff here
end

Note:
- When running, _update() is ALWAYS executed before _draw() by pico-8
- _update() and _draw() help you keep your code organized, but technically we can also draw in _update(), and update variables in _draw(), it's more for organization than a strict requirement
- On rare occasions, if _update() takes to long to finish, _draw() for that frame may get skipped (unlikely for small programs)

## THE STARTUP SEQUENCE:
1. Error Checking
2. Runs Standalone Code ONCE (aka any code not inside a function)
3. Runs _init() ONCE, but can be called to run again
4. Runs the game loop (_update() and _draw()) continuously until the game is paused or ended

### Initialization: The _init() Function
Used to set up your game to it's starting values (useful for "resetting" the game)

SO, the ideal code layout of a game file is:
--global variables
-- example here might include a highscore variable

function _init()
 -- example here might include a score variable
end

function _update()
 -- example here if play wins then wins+1
 -- Replay? If yes then _init()
end

function _draw()
end