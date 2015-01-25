


# API Functions.
createGameCanvas = (canvas, pixelHeight, pixelWidth, squareWidth, squareHeight, squareGap, defaultSquareColour) ->
	pixelCanvas = new PixelCanvas canvas, pixelHeight, pixelWidth, squareWidth, squareHeight, squareGap, defaultSquareColour
	return

createGameObject = ({gridX, gridY, boundingX, boundingY, defaultColour, bitmap, z} = {}) ->
	gameObject = new GameObject gridX, gridY, boundingX, boundingY, defaultColour, bitmap, z

class Square
	constructor: (@colour) ->
		console.log "square made"

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
		console.log @

class PixelCanvas
	# Change constructor to take named args like 
	# http://stackoverflow.com/questions/5238398/default-function-parameter-ordering
	constructor: (@canvas, @pixelHeight, @pixelWidth, @squareWidth, @squareHeight, @squareGap, @defaultSquareColour) ->
		# Get the canvas context and set it's size.
		@context = @canvas.getContext '2d'
		@canvas.width = @pixelWidth
		@canvas.height = @pixelHeight
		# Work out the sizes for each square.
		totalGapsWidth = (@squareWidth-1)*squareGap
		@squarePixelWidth = Math.floor (@pixelHeight-totalGapsWidth)/@squareWidth
		totalGapsHeight = (@squareHeight-1)*squareGap
		@squarePixelHeight = Math.floor (@pixelHeight-totalGapsHeight)/@squareHeight
		@squareGrid = ((new Square(@defaultSquareColour) for i in [1..@squareWidth]) for j in [1..@squareHeight])
		@firstDraw()

	# As canvas is update based, the first draw we need to fill all the squares.
	firstDraw: () ->
		placementWidth = @squarePixelWidth + @squareGap
		placementHeight = @squarePixelHeight + @squareGap
		for i in [0..@squareWidth-1]
			for j in [0..@squareHeight-1]
				@context.fillStyle = @squareGrid[i][j].colour
				@context.fillRect i*placementWidth, j*placementHeight,
					@squarePixelWidth, @squarePixelHeight

module.exports = {createGameCanvas, createGameObject}
