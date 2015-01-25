PixelCanvas = require "./pixel_canvas"

loops = 0

init = () ->
	canvas = document.getElementById 'game'
	# Set up the pixel canvas.
	PixelCanvas.createGameCanvas canvas, 627, 627, 10, 10, 7, 'rgba(189, 195, 199, 1.0)'
	gameObjectArgs = {
		gridX: 1
		gridY: 2
	}
	PixelCanvas.createGameObject gameObjectArgs
	# @pixelCanvas = new PixelCanvas canvas, 627, 627, 10, 10, 7, 'rgba(189, 195, 199, 1.0)'
	# Set up the game status.

	# Start the game loop.
	gameLoop()

gameLoop = () ->
	# setTimeout gameLoop, 25 # 40 fps

init()
