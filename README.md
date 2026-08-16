# Placeholder
# Love2D Terraria-Style Prototype

A small Terraria-inspired 2D sandbox prototype made with **Lua and LÖVE2D**.

This project started as a way for me to practice game development with LÖVE2D and Lua while experimenting with procedural world generation, physics, particles, shaders, and chunk-based worlds.

## Features

* Procedurally generated terrain
* Chunk-based world generation and loading
* Terrain elevation and cave generation
* Player movement and physics
* Block placing and breaking
* Block changes persist when chunks unload and reload
* Dynamic day/night cycle
* Dynamic player lighting
* Parallax background layers
* Particle effects
* Settings menu
* Spectator mode
* Debug information and physics hitbox rendering
* Custom sprites and textures

## Libraries

This project uses:

* [LÖVE2D](https://love2d.org/) — Game framework
* [Windfield](https://github.com/a327ex/windfield) — Physics wrapper
* [HUMP](https://github.com/vrld/hump) — Camera utilities

## Controls

| Key / Input   | Action                   |
| ------------- | ------------------------ |
| `A` / `D`     | Move                     |
| `Space`       | Jump                     |
| `G`           | Toggle spectator mode    |
| `F3`          | Toggle debug information |
| `Left Mouse`  | Place block              |
| `Right Mouse` | Break block              |
| `Escape`      | Open/close settings      |

## About

This is primarily a **learning project**, rather than a finished commercial game.

The goal was to become more comfortable with Lua and LÖVE2D while learning how different parts of a game fit together, including modules, procedural generation, physics, chunk management, particles, shaders, cameras, and game settings.

The project is considered finished for its original purpose. Future projects will build on what I learned here rather than continuing to expand this one indefinitely.
