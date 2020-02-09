#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb  8 15:32:20 2020

@author: JohnGeiger

Snake GUI

"""
import sys
from PyQt5.QtWidgets import QApplication, QWidget, QMainWindow, QFrame
from PyQt5.QtCore import Qt, QTimer, pyqtSignal
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
    
    gameLoopTime = 100
    squareSize = 10
    gameHeight = 50
    gameWidth = 50
    initialSnakePosition = [(25,22), (25,23), (25,24), (25,25)]
    
    def __init__(self):
        
        super().__init__()
        self.initFrame()
        
        
    def initFrame(self):
        
        self.gameTimer = QTimer()
        self.snake = Snake()
        
        self.snake.setBodyPositions(self.initialSnakePosition)
        
        self.setStyleSheet("background-color:black")
        

    def startGame(self):
        
        self.gameTimer.timeout.connect(self.moveSnake)
        self.gameTimer.start(self.gameLoopTime)
       
    
    def moveSnake(self):
        """ Moves snake every time timer times out """
        
        self.snake.move()


    def paintEvent(self, event):
        
        painter = QPainter(self)
        self.drawSnake(event, painter)
        
        
    def drawSnake(self, event, painter):
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

if __name__ == '__main__':
    
    app = QApplication(sys.argv)
    window = SnakeWindow()
    app.exec_()