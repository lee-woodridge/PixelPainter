# Global variables, private from the user.
_pixelCanvas = {}
_squareGrid = {}

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
		console.log @grid

	changeSquare: (x, y, z, colour) ->
		if z >= @grid[x][y].z
			console.log "changed square " + x + "," + y
			@grid[x][y].colour = colour
			@changed.push @grid[x][y]
			console.log @grid[x][y]

# Class containing information needed to draw a square in the grid.
class Square
	constructor: (@x, @y, @colour) ->
		@z = 0

# Class that's given to the user to control their game objects on our canvas.
class GameObject
	constructor: (@gridX, @gridY, @boundingX, @boundingY, @defaultColour, @bitmap, @z) ->
		if not @gridX? or not @gridY?
			throw "gridX and gridY arguments required."
		@boundingX ?= 1
		@boundingY ?= 1
		@defaultColour ?= 'rgba(189, 195, 199, 1.0)'
		# Check if bitmap exists.
		if @bitmap?
			# Check it's the correct size.
			if @bitmap.length == @boundingY
				for row in @bitmap
					if row.length != @boundingX
						throw "Bitmap width doesn't match claimed bounding size."
			else
				throw "Bitmap height doesn't match claimed bounding size."
		else
			if (@boundingX > 1 or @boundingY > 1)
				((1 for i in [1..@boundingX]) for j in [1..@boundingY])
		@z ?= 0
		@firstDraw()

	firstDraw: () ->
		if not @bitmap?
			_squareGrid.changeSquare(@gridX, @gridY, @z, @defaultColour)

# Class in charge of holding the canvas object and drawing on it.
class PixelCanvas
	# Change constructor to take named args like in GameObject.
	constructor: (@canvas, @squareDim, @gridWidth, @gridHeight, @squareGap, @defaultSquareColour) ->
		# Get the canvas context and set it's size.
		@context = @canvas.getContext '2d'
		# Work out the canvas size.
		@canvas.width = (@squareDim*@gridWidth) + (@squareGap*(@gridWidth-1))
		@canvas.height = (@squareDim*@gridHeight) + (@squareGap*(@gridHeight-1))
		# Work out placement values.
		@placementWidth = @squareDim + @squareGap
		@placementHeight = @squareDim + @squareGap
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
			console.log square
			@context.fillStyle = square.colour
			@context.fillRect square.x*@placementWidth, square.y*@placementHeight,
				@squareDim, @squareDim

	# Clear the changed-squares-array. 
	clear: () ->
		_squareGrid.changed = []

module.exports = {createGameCanvas, createGameObject, updateGameCanvas}
