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
from SnakeModel import Snake, Direction


class SnakeWindow(QMainWindow):
    
    gameTimer = QTimer()
    
    def __init__(self):
        
        super().__init__()
        self.initGame()
        
    def initGame(self):
        
        self.gameFrame = SnakeFrame()
        self.gameFrame.startGame()
                
        self.setGeometry(300, 300, 500, 500)
        self.setWindowTitle('Snake')    
        self.show()
        
class SnakeFrame(QFrame):
    
    gameLoopTime = 30
    
    def __init__(self):
        
        super().__init__()
        self.initFrame()
        
    def initFrame(self):
        
        self.gameTimer = QTimer()
        self.snake = Snake()

    def startGame(self):
        
        self.gameTimer.timeout.connect(self.moveSnake)
        self.gameTimer.start(self.gameLoopTime)
       
    
    def moveSnake(self):
        """ Called every time timer times out """
        
        print("Timer")

if __name__ == '__main__':
    
    app = QApplication(sys.argv)
    window = SnakeWindow()
    sys.exit(app.exec_())