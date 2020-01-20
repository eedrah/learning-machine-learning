

'''
strategy is:
    array of actions that you could take

one generation:
    do iterations, for each:
        # either:
            add one more action to the best performing strategies in the last generation
        # or:
            # change one action in the best performing strategies
        get fitness

    evalute iterations:
        list all iterations in this generation
        get the best performing (or the top 10)
'''

Actions = {
    UP: Movement(-1, 0),
    DOWN: Movement(1, 0),
    LEFT: Movement(0, -1),
    RIGHT: Movement(0, 1)
}

class Position:
    def __init__(self, row, col):
        self.row = row
        self.col = col

    def __add__(self, other):
        return Position(self.row + other.row, self.col + other.col)

class Movement(Position):
    def __init__(self, row, col):
        super().__init__(row, col)

class Strategy:
    # actions = [Actions.UP, Actions.RIGHT, Actions.DOWN, Actions.LEFT]
    actions = []

    def __stepThroughMaze(self, locationInMaze, action):

    def travelThroughMaze(self):
        locationInMaze = LocationInMaze()
        for action in self.actions:
            self.__stepThroughMaze(locationInMaze, action)
        return evaluateFitness(locationInMaze)

    def evaluateFitness(self, locationInMaze):
        return locationInMaze.distanceFromEnd()

    def procreate(self):
        # randomly add one action to the end of actions, and return new object
        pass

class LocationInMaze:
    def __init__(self):
        self.maze = Maze()
        self.position = Position(7, 14)

    def move(self, action):
        if maze.isValidSquare(self.position + action):
            self.position += action

    def distanceFromEnd(self):
        pass

class Maze:
    def __init__(self):
        self.maze = np.array([
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1],
            [1, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1],
            [1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1],
            [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1],
            [1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
            [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
        ])

    def isValidPosition(self, position):
        return self.maze[position.row, position.col] == 0

class Game:
    def __init__:
        strategies = [Strategy() for i in range(100)]

