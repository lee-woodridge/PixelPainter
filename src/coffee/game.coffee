PixelCanvas = require "./pixel_canvas"

square = {}
cross = {}

init = () ->
	canvas = document.getElementById 'game'
	# Set up the pixel canvas.
	PixelCanvas.createGameCanvas canvas, 30, 20, 12, 7, 'rgba(189, 195, 199, 1.0)'
	squareObjectArgs = {
		gridX: 1
		gridY: 2
		z: 1,
		defaultColour: 'rgba(243, 156, 18, 1.0)'
	}
	square = PixelCanvas.createGameObject squareObjectArgs
	crossObjectArgs = {
		gridX: 5
		gridY: 5
		defaultColour: 'rgba(39, 174, 96, 1.0)'
		boundingX: 3
		boundingY: 3
		bitmap: [
			[0,1,0]
			[1,1,1]
			[0,1,0]
		]
		z: 2
	}
	cross = PixelCanvas.createGameObject crossObjectArgs

	# Set up the game status.

	# Start the game loop.
	gameLoop()

move4 = () ->
	cross.moveBy(4,3)
	PixelCanvas.updateGameCanvas()

move3 = () ->
	cross.moveBy(-2,-2)
	PixelCanvas.updateGameCanvas()
	setTimeout move4, 1000

move2 = () ->
	square.moveBy(-2,-2)
	PixelCanvas.updateGameCanvas()
	setTimeout move3, 1000

move1 = () ->
	square.moveTo(6,6)
	PixelCanvas.updateGameCanvas()
	setTimeout move2, 1000

gameLoop = () ->
	# setTimeout gameLoop, 20 # 50 fps
	PixelCanvas.updateGameCanvas()
	setTimeout move1, 1000

init()
