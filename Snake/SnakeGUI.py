#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  8 15:32:20 2020

@author: JohnGeiger

Snake GUI

"""

import sys, random
from PyQt5.QtWidgets import QApplication, QMainWindow, QFrame
from PyQt5.QtCore import Qt, QCoreApplication, QTimer, QPoint
from PyQt5.QtGui import QPainter, QColor, QPen, QBrush, QFont
from SnakeModel import Snake, Direction, GameState


class SnakeWindow(QMainWindow):
    """ Main window that starts the game """
        
    def __init__(self):
        
        super().__init__()
        self.initGame()
        
    def initGame(self):
        
        self.gameFrame = SnakeFrame()
        
        self.setCentralWidget(self.gameFrame)
                
        self.setGeometry(300, 150, self.gameFrame.gameWidth * 
                         self.gameFrame.squareSize, self.gameFrame.gameHeight * self.gameFrame.squareSize)
        self.setWindowTitle('Snake')    
        self.show()
        
        
class SnakeFrame(QFrame):
    """ Game frame where events occur and snake moves """
    
    gameState = GameState.NotStarted
    gameLoopTime = 60
    squareSize = 8
    gameHeight = 80
    gameWidth = 80
    
    def __init__(self):
        
        super().__init__()
        self.initFrame()
        
        
    def initFrame(self):
        
        self.gameTimer = QTimer()
        self.snake = Snake()
        
        # Set snake's initial body positions and direction
        xPosition = self.gameWidth // 4
        yPosition = self.gameHeight // 2
        self.initialSnakePosition = [(i,yPosition) for i in range(xPosition-3, xPosition+1)]
        self.snake.setBodyPositions(self.initialSnakePosition)
        self.snake.direction = Direction.Right
        
        self.foodPosition = (self.gameWidth // 1.33, self.gameHeight // 2)
        
        self.setFocusPolicy(Qt.StrongFocus)
        self.setStyleSheet("background-color:black")
        

    def startGame(self):
        
        self.gameState = GameState.Running
        self.gameTimer.timeout.connect(self.moveSnake)
        self.gameTimer.start(self.gameLoopTime)
       
    
    def moveSnake(self):
        """ Moves snake every time timer times out """
        
        self.snake.move()
        self.update() 
        
        snakeHead = self.snake.headPosition()
        
        if snakeHead == self.foodPosition:
            self.snake.eat()
            self.createNewFood()
            
        # Check that snake isn't running into self
        elif snakeHead in self.snake.bodyPositions[:-1]:
            self.gameTimer.stop()
            self.gameState = GameState.GameOver
            self.update()

        # Check that snake isn't running into the wall
        elif snakeHead[0] not in range(0, self.gameWidth) or snakeHead[1] not in range(0, self.gameHeight):
            self.gameTimer.stop()
            self.gameState = GameState.GameOver
            self.update()
        
        
        
    def createNewFood(self):
        """ Creates new food square at random spot not on top of snake """
                
        while True:
            newX = random.randint(0, self.gameWidth-1)
            newY = random.randint(0, self.gameHeight-1)
            newPosition = (newX, newY)
            
            if newPosition not in self.snake.bodyPositions:
                break
        
        self.foodPosition = newPosition
        

    def keyPressEvent(self, event):
        """ Handles key inputs """
        
        keyPressed = event.key()
        
        if keyPressed == Qt.Key_Left and self.snake.direction != Direction.Right:
            self.snake.direction = Direction.Left
        elif keyPressed == Qt.Key_Right and self.snake.direction != Direction.Left:
            self.snake.direction = Direction.Right
        elif keyPressed == Qt.Key_Up and self.snake.direction != Direction.Down:
            self.snake.direction = Direction.Up
        elif keyPressed == Qt.Key_Down and self.snake.direction != Direction.Up:
            self.snake.direction = Direction.Down
        # Start/Restart game
        elif keyPressed == Qt.Key_Space and self.gameState != GameState.Running:
            self.gameState = GameState.Running
            self.initFrame()
            self.startGame()
            
            
    def paintEvent(self, event):
        
        painter = QPainter(self)
        
        if self.gameState == GameState.NotStarted:
            self.drawGameStart(event, painter)
        elif self.gameState == GameState.GameOver:
            self.drawGameOver(event, painter)
        
        self.drawSnakeAndFood(event, painter)
        
    
    def drawGameStart(self, event, painter):
        """ Draw Game Start message """
        
        font = QFont("Courier", 30, QFont.Bold)
        painter.setFont(font)
        painter.setPen(Qt.white)

        painter.drawText(0, self.squareSize * self.gameHeight // 4 - 40, 
                         self.squareSize * self.gameWidth, 40, Qt.AlignCenter, "SNAKE")
        
        font.setPointSize(18)
        painter.setFont(font)
        painter.drawText(0, self.squareSize * self.gameHeight // 4, 
                         self.squareSize * self.gameWidth, 30, Qt.AlignCenter, "Press the spacebar to start")
        
        
    def drawSnakeAndFood(self, event, painter):
        """ Draws the snake and food"""
        
        pen = QPen()
        pen.setWidth(1)
        pen.setBrush(Qt.white)
        pen.setCapStyle(Qt.SquareCap)
        pen.setJoinStyle(Qt.MiterJoin)  
        
        brush = QBrush(Qt.white)
        
        painter.setPen(pen)
        painter.setBrush(brush)
        
        # Draw each individual square of snake 
        for bodySquare in self.snake.bodyPositions:
            
            x = bodySquare[0] * self.squareSize
            y = bodySquare[1] * self.squareSize
            
            painter.drawRect(x, y, self.squareSize, self.squareSize)

        # Draw food
        x = self.foodPosition[0] * self.squareSize
        y = self.foodPosition[1] * self.squareSize
        
        painter.drawRect(x, y, self.squareSize, self.squareSize)
        
        
    def drawGameOver(self, event, painter):
        """ Draw Game Over message """
        
        font = QFont("Courier", 30, QFont.Bold)
        painter.setFont(font)
        painter.setPen(Qt.white)

        painter.drawText(0, self.squareSize * self.gameHeight // 2 - 40, 
                         self.squareSize * self.gameWidth, 40, Qt.AlignCenter, "GAME OVER")
        
        font.setPointSize(18)
        painter.setFont(font)
        painter.drawText(0, self.squareSize * self.gameHeight // 2, 
                         self.squareSize * self.gameWidth, 30, Qt.AlignCenter, "Press the spacebar to restart")
        
    
        
if __name__ == '__main__':
    if QCoreApplication.instance() != None:
        app = QCoreApplication.instance()
    else:
        app = QApplication(sys.argv)
    window = SnakeWindow()
    app.exec_()