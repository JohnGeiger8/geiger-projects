#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  8 15:32:20 2020

@author: JohnGeiger

Snake GUI

"""
import sys, random
from PyQt5.QtWidgets import QApplication, QWidget, QMainWindow, QFrame
from PyQt5.QtCore import Qt, QCoreApplication, QTimer, pyqtSignal
from PyQt5.QtGui import QPainter, QColor, QPen, QBrush
from SnakeModel import Snake, Direction

class SnakeWindow(QMainWindow):
    """ Main window that starts the game """
        
    def __init__(self):
        
        super().__init__()
        self.initGame()
        
    def initGame(self):
        
        self.gameFrame = SnakeFrame()
        self.gameFrame.startGame()
        
        self.setCentralWidget(self.gameFrame)
                
        self.setGeometry(300, 150, self.gameFrame.gameWidth * 
                         self.gameFrame.squareSize, self.gameFrame.gameHeight * self.gameFrame.squareSize)
        self.setWindowTitle('Snake')    
        self.show()
        
        
class SnakeFrame(QFrame):
    """ Game frame where events occur and snake moves """
    
    gameLoopTime = 60
    squareSize = 5
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
        
        self.gameTimer.timeout.connect(self.moveSnake)
        self.gameTimer.start(self.gameLoopTime)
       
    
    def moveSnake(self):
        """ Moves snake every time timer times out """
        
        self.snake.move()
        self.update() 
        
        if self.snake.headPosition() == self.foodPosition:
            self.snake.eat()
            self.createNewFood()
            

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
            
            
    def paintEvent(self, event):
        
        painter = QPainter(self)
        self.drawSnakeAndFood(event, painter)
        
        
    def drawSnakeAndFood(self, event, painter):
        """ Draws the snake """
        
        pen = QPen()
        pen.setWidth(1)
        pen.setBrush(Qt.white)
        pen.setCapStyle(Qt.SquareCap)
        pen.setJoinStyle(Qt.MiterJoin)  
        
        brush = QBrush(Qt.white)
        
        painter.setPen(pen)
        painter.setBrush(brush)
        
        for bodySquare in self.snake.bodyPositions:
            """ Draw each individual square of snake """
            
            x = bodySquare[0] * self.squareSize
            y = bodySquare[1] * self.squareSize
            
            painter.drawRect(x, y, self.squareSize, self.squareSize)

        # Draw food
        x = self.foodPosition[0] * self.squareSize
        y = self.foodPosition[1] * self.squareSize
        
        painter.drawRect(x, y, self.squareSize, self.squareSize)

if __name__ == '__main__':
    if QCoreApplication.instance() != None:
        app = QCoreApplication.instance()
    else:
        app = QApplication(sys.argv)
    window = SnakeWindow()
    app.exec_()