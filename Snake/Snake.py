#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 12 18:42:49 2020

@author: JohnGeiger

Snake Clone

"""

import sys
from SnakeGUI import SnakeWindow
from PyQt5.QtWidgets import QApplication
from PyQt5.QtCore import QCoreApplication

if __name__ == '__main__':
    
    # Prevents issue in Spyder IDE where application can't be run twice in a row
    if QCoreApplication.instance() != None:
        app = QCoreApplication.instance()
    else:
        app = QApplication(sys.argv)
        
    window = SnakeWindow()
    app.exec_()