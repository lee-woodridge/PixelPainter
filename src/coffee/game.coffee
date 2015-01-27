PixelCanvas = require "./pixel_canvas"

init = () ->
	canvas = document.getElementById 'game'
	# Set up the pixel canvas.
	PixelCanvas.createGameCanvas canvas, 60, 10, 6, 7, 'rgba(189, 195, 199, 1.0)'
	gameObjectArgs = {
		gridX: 1
		gridY: 2
		defaultColour: 'rgba(243, 156, 18, 1.0)'
	}
	PixelCanvas.createGameObject gameObjectArgs
	# Set up the game status.

	# Start the game loop.
	gameLoop()

gameLoop = () ->
	# setTimeout gameLoop, 20 # 50 fps
	PixelCanvas.updateGameCanvas()

init()
