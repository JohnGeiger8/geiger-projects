# Minesweeper

## Summary
- Simple clone of Minesweeper that includes simple pixel art and features 3 different difficulty levels
- Made with Java 
- Uses Java Swing for the GUI 

## How to Run

**From the command line:**
1. Go to "/Minesweeper/dist" folder.
2. Assuming you have Java installed, run "java -jar Minesweeper.jar".

OR

1. Execute "minesweeper.sh".

**From desktop:** 
1. Go to "/Minesweeper/dist" folder.
2. Double-click on the "Minesweeper.jar" file.

The source code for the Minesweeper application can be found in "/Minesweeper/src/minesweeper/".

## How to Play

For those who have never played Minesweeper:
- Begin the game by clicking on any tile. If a number appears, you can continue. If a mine appears, you lose.
- You continue clicking on tiles until you hit a mine. The numbers shown on the tiles tell you the number of adjacent tiles that contain mines (including diagonal tiles). So, each tile will either contain a mine or a number between 0 and 8.
- As you reveal more tiles, you will be able to figure out which tiles are mines and which are not. If you determine that a tile contains a mine, you can use the flag button to place a flag over that tile so that you remember not to click it. Once you've flagged all the mines, you win the game.
