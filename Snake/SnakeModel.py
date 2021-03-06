#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 8 2020

@author: JohnGeiger

Snake Clone Model

"""


class Direction:
    """ Enumeration of different directions Snake can go in """

    Left = 0
    Up = 1
    Right = 2
    Down = 3


class Snake:
    """ Model of Snake used in game """

    bodyPositions = []
    direction = Direction.Right
    isEating = False

    def __init__(self):

        self.bodyPositions = [(0, 0)]

    def setBodyPositions(self, positions):

        self.bodyPositions = positions

    def headPosition(self):

        return self.bodyPositions[len(self.bodyPositions) - 1]

    def move(self):

        direction = self.direction

        # Allow snake to get longer if it's eating
        if self.isEating is True:
            self.isEating = False      # Snake only eats for 1 move
        else:
            self.bodyPositions.pop(0)  # Snake stays same size

        headPosition = self.bodyPositions[len(self.bodyPositions) - 1]

        if direction == Direction.Left or direction == Direction.Right:
            """ Horizontal move """

            # New position changes x by 1 or -1 for right or left movement
            directionValue = 1 if direction == Direction.Right else -1
            newPosition = (headPosition[0] + directionValue, headPosition[1])

            self.bodyPositions.append(newPosition)

        elif direction == Direction.Up or direction == Direction.Down:
            """ Vertical move """

            # New position changes y value by 1 or -1 for down or up movement
            directionValue = 1 if direction == Direction.Down else -1
            newPosition = (headPosition[0], headPosition[1] + directionValue)

            self.bodyPositions.append(newPosition)

    def eat(self):
        self.isEating = True


class GameState:
    """ Possible game states that Snake clone can be in """

    NotStarted = 0
    GameOver = 1
    Running = 2
    GameWon = 3
