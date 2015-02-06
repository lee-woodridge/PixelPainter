# Global variables, private from the user.
_pixelCanvas = {}
_squareGrid = {}
_gameObjectId = 0

# API Functions.
# PixelCanvas functions.
# Create the canvas. Call once on initialization.
createGameCanvas = (canvas, squareDim, gridWidth, gridHeight, squareGap, defaultSquareColour) ->
	_squareGrid = new SquareGrid gridWidth, gridHeight, defaultSquareColour
	_pixelCanvas = new PixelCanvas canvas, squareDim, gridWidth, gridHeight, squareGap, defaultSquareColour
	return

# Update any changes to the canvas. Call once per game loop.
updateGameCanvas = ->
	_pixelCanvas.update()

# GameObject functions.
# Create a game object. Call once for initialization.
createGameObject = ({gridX, gridY, boundingX, boundingY, defaultColour, bitmap, z} = {}) ->
	gameObject = new GameObject gridX, gridY, boundingX, boundingY, defaultColour, bitmap, z

# Class in charge of holding the square grid, and updating any colours when a
# game object is changed by the user.
class SquareGrid
	constructor: (@gridWidth, @gridHeight, @defaultSquareColour) ->
		@grid = ((new Square(i-1, j-1, @defaultSquareColour) for j in [1..@gridHeight]) for i in [1..@gridWidth])
		@changed = []

	moveObjectIntoSquare: (x, y, gameObject) ->
		if @grid[x][y].addGameObject gameObject
			@changed.push @grid[x][y]

	moveObjectFromSquare: (x, y, gameObject) ->
		if @grid[x][y].removeGameObject gameObject
			@changed.push @grid[x][y]

# Class containing information needed to draw a square in the grid.
class Square
	# Square has a stack of colours which has been assigned to it, to handle overlapping shapes.
	constructor: (@x, @y, @colour) ->
		@defaultColour = @colour
		@z = 0
		@gameObjects = []
		@topGameObject = {}
		# @colourKeeper = [{z: 0, colour: @colour}]

	# Add gameObject to this Square, and return true if we changed the colour.
	addGameObject: (gameObject) ->
		# Handle adding the object.
		@gameObjects.push gameObject
		# Update any Square info this changes.
		if @gameObjects.length == 0 or gameObject.z > @z
			@topGameObject = gameObject
			@z = gameObject.z
			@colour = gameObject.defaultColour
			return true
		else
			return false

	removeGameObject: (gameObject) ->
		foundObjectToRemove = false
		keyToRemove = 0
		# Removing the top object requires some colour change logic.
		if @topGameObject?
			if gameObject.id == @topGameObject.id
				currentHighestZ = Number.NEGATIVE_INFINITY
				nextHighestObject = {}

				# Handle removing the object and find the next highest GameObject.
				for obj, key in @gameObjects
					if obj.id == gameObject.id
						foundObjectToRemove = true
						keyToRemove = key
					else
						if obj.z > currentHighestZ
							currentHighestZ = obj.z
							nextHighestObject = obj

				if foundObjectToRemove
					@gameObjects.splice(keyToRemove, 1)
					if @gameObjects.length == 0
						@colour = @defaultColour
						@z = 0
						@topGameObject = {}
					else
						@colour = nextHighestObject.defaultColour
						@z = nextHighestObject.z
						@topGameObject = nextHighestObject
					return true
				else
					throw "Attempting to remove a GameObject from a position where it doesn't exist."
			else # Easier case.
				for obj, key in @gameObjects
					if obj.id == gameObject.id
						foundObjectToRemove = true
						keyToRemove = key

				if foundObjectToRemove
					@gameObjects.splice(keyToRemove, 1)
					return false
				else
					throw "Attempting to remove a GameObject from a position where it doesn't exist."
		else
			throw "Attempting to remove a GameObject from a position where it doesn't exist."

# Class that's given to the user to control their game objects on our canvas.
class GameObject
	constructor: (@gridX, @gridY, @boundingX, @boundingY, @defaultColour, @bitmap, @z) ->
		@id = _gameObjectId++
		if not @gridX? or not @gridY?
			throw "gridX and gridY arguments required."
		@boundingX ?= 1
		@boundingY ?= 1
		@defaultColour ?= 'rgba(189, 195, 199, 1.0)'
		# Check if bitmap exists.
		if @bitmap?
			# Check it's the correct size.
			if @bitmap.length is @boundingY
				for row in @bitmap
					if row.length is not @boundingX
						throw "Bitmap width doesn't match claimed bounding size."
			else
				throw "Bitmap height doesn't match claimed bounding size."
		else
			if (@boundingX > 1 or @boundingY > 1)
				((1 for i in [1..@boundingX]) for j in [1..@boundingY])
		@z ?= 0
		@draw()

	draw: () ->
		if not @bitmap?
			_squareGrid.moveObjectIntoSquare @gridX, @gridY, @
		else
			for i in [0..@boundingX-1]
				for j in [0..@boundingY-1]
					if @bitmap[j][i]
						_squareGrid.moveObjectIntoSquare @gridX + i, @gridY + j, @

	moveTo: (x, y) ->
		# Change old square back to the default colour.
		if not @bitmap?
			_squareGrid.moveObjectFromSquare @gridX, @gridY, @
		else
			for i in [0..@boundingX-1]
				for j in [0..@boundingY-1]
					if @bitmap[j][i]
						_squareGrid.moveObjectFromSquare @gridX + i, @gridY + j, @
		@gridX = x
		@gridY = y
		@draw()

	moveBy: (x, y) ->
		@moveTo (@gridX + x), (@gridY + y)

	# assignOnClick: (f) ->


# Class in charge of holding the canvas object and drawing on it.
class PixelCanvas
	# Change constructor to take named args like in GameObject.
	constructor: (@canvas, @squareDim, @gridWidth, @gridHeight, @squareGap, @defaultSquareColour) ->
		# Get the canvas context and set it's size.
		@context = @canvas.getContext '2d'
		@canvasBoundingBox = @canvas.getBoundingClientRect()
		# Work out the canvas size.
		@canvas.width = (@squareDim*@gridWidth) + (@squareGap*(@gridWidth-1))
		@canvas.height = (@squareDim*@gridHeight) + (@squareGap*(@gridHeight-1))
		# Work out placement values.
		@placementWidth = @squareDim + @squareGap
		@placementHeight = @squareDim + @squareGap
		# Add event listeners on the canvas.
		@canvas.addEventListener 'click', (evt) => @onClick(evt)
		@firstDraw()

	# As canvas is update based, the first draw we need to fill all the squares.
	firstDraw: () ->
		for i in [0..@gridWidth-1]
			for j in [0..@gridHeight-1]
				@context.fillStyle = _squareGrid.grid[i][j].colour
				@context.fillRect i*@placementWidth, j*@placementHeight,
					@squareDim, @squareDim

	# Call to update the canvas with any changes since the last update call.
	update: () ->
		@draw()
		@clear()

	# Draw the changed squares.
	draw: () ->
		for square in _squareGrid.changed
			@context.fillStyle = square.colour
			@context.fillRect square.x*@placementWidth, square.y*@placementHeight,
				@squareDim, @squareDim

	onClick: (evt) ->
		mousePos = {
			x: evt.clientX - @canvasBoundingBox.left
			y: evt.clientY - @canvasBoundingBox.top
		}
		if mousePos.x %% @placementWidth < @squareDim &&
		mousePos.y %% @placementHeight < @squareDim
			console.log "clicked a square"


	# Clear the changed-squares-array. 
	clear: () ->
		_squareGrid.changed = []

module.exports = {createGameCanvas, createGameObject, updateGameCanvas}
