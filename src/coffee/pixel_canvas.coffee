
class Square
	constructor: (@colour) ->
		console.log "square made"

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

	# As canvas is update based, the first draw we need to fill all the squares.
	firstDraw: () ->
		placementWidth = @squarePixelWidth + @squareGap
		placementHeight = @squarePixelHeight + @squareGap
		for i in [0..@squareWidth-1]
			for j in [0..@squareHeight-1]
				@context.fillStyle = @squareGrid[i][j].colour
				@context.fillRect i*placementWidth, j*placementHeight,
					@squarePixelWidth, @squarePixelHeight

module.exports = PixelCanvas
