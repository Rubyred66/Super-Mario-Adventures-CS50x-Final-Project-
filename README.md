# **This is Super Mario Adventures by Berkay Kalender**
#### **Video Demo:**  https://www.youtube.com/watch?v=S7jSWnhpHWg

### *Here is my CS50x Final Project, Super Mario Adventures!*

## Description 
### Super Mario Adventures is a platform game using Lua with LÖVE. 

### It was fundamentally an old scratch game that I made on Aug 03, 2019. I decided to remake this old game with my improved coding skills. 

### This project contains all features of an ordinary Super Mario Bros game such as jumping over goombas, entering warp pipes, hitting the block, earning coins etc. The game has also eye-catching designs in terms of sprites, backgrounds and items. 

### It's just a demo game that has a single level. Rather than building more levels, I prioritized presenting my skills better for my final project. Later, I consider making my game better by adding new levels, bosses etc.


## Controls
* ### Press _space_ or _up arrow_ to jump.
* ### Press _left_ and _right_ arrows to move.
* ### Press _down arrow_ to enter warp pipes.


## Tools
* ### Lua & LOVE2D 
* ### Visual Studio Code
* ### Tiled

## Libraries I used
* ### [Windfield](https://github.com/a327ex/windfield) : A physics module for LÖVE
* ### [anim8](https://github.com/kikito/anim8) :  Animation library for LÖVE.
* ### [Simple Tiled Implementation](https://github.com/karai17/Simple-Tiled-Implementation) : A Tiled map loader and renderer designed for the awesome LÖVE framework.
* ### [hump.camera](https://github.com/vrld/hump) : Move-, zoom- and rotatable camera with camera locking and movement smoothing.

## Details of Game Files
* ### main.lua : main.lua : It's the main file that contains all sprites, libraries, tables, images, sounds, animations etc. I imported my objects and map from tiled by simple tiled implementation library. For sprite animations of Mario, enemies, blocks and toads, I used the anim8 library.
* ### player.lua : These codes are fully associated with the player's movement and outputs after being damaged by enemies or entering the pipe.
* ### enemy.lua : Some codes are about spawning enemies from Tiled. Also, there are codes for enemies' movements and the output when Mario jumped on them.
* ### pipe.lua : This file is for pipes that enable Mario to cross from someplace to someplace.

## Credits
* ### Super Mario Adventures Logo by AsylusGoji91
* ### Super Mario Sprites by Neweegee
* ### Toad Sprites by A.J Nitro
* ### Goomba Sprites by Mit
* ### Tileset by Mr. Reggie
* ### Mushroom Kingdom Background by justcamtro

## Thank you!
### ***I would like to express my thanks to Sir David Malan and the entire CS50x staff for giving me such a great opportunity to improve my coding skills. The process of learning new programming languages and the logic behind the coding was entertaining for me. Labs and problem sets were generally so challenging. -Fiftyville was my favourite one. These sets provided gaining experiences and self-learning some things to me. It was a lot of hard work, but it was worth it when finally had success and submitted problem sets days or weeks later.***
#