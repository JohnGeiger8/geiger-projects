"""
Created on Sat Feb 8 2020

@author: JohnGeiger

Snake Model

"""

class Direction:
    
    Left = 0
    Up = 1
    Right = 2
    Down = 3

class Snake:
    
    bodyPositions = []
    direction = Direction.Down
    
    def __init__(self):
        
        self.bodyPositions = [(0,0)]
        
        
    def setBodyPositions(self, positions):
        
        self.bodyPositions = positions
        
        
    def move(self):
        
        self.bodyPositions.pop(0)

        headPosition = self.bodyPositions[len(self.bodyPositions) - 1]

        if self.direction == Direction.Left or self.direction == Direction.Right:
            """ Horizontal move """
            
            # New position changes the x value by 1 or -1 for right or left movement
            directionValue = 1 if self.direction == Direction.Right else -1
            newPosition = (headPosition[0] + directionValue, headPosition[1])
            
            self.bodyPositions.append(newPosition)
            
            
        elif self.direction == Direction.Up or self.direction == Direction.Down:
            """ Vertical move """
            
            # New position changes the y value by 1 or -1 for down or up movement
            directionValue = 1 if self.direction == Direction.Down else -1
            newPosition = (headPosition[0], headPosition[1] + directionValue)
            
            self.bodyPositions.append(newPosition)

                