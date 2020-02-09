"""
Created on Sat Feb 8 2020

@author: JohnGeiger

Snake Model

"""

class Snake:
    
    bodyPositions = []
    
    def __init__(self):
        
        print("I'm a snake!")
        
    def move(self, direction):
        
        if direction == Direction.Left:
            print("left")
        if direction == Direction.Up:
            print("Up")
        if direction == Direction.Right:
            print("Right")
        if direction == Direction.Down:
            print("Down")
                
     
class Direction:
    
    Left = 0
    Up = 1
    Right = 2
    Down = 3