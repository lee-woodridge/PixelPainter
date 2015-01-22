PixelCanvas = require "./pixel_canvas"

loops = 0

init = () ->
	canvas = document.getElementById 'game'
	# Set up the pixel canvas.
	@pixelCanvas = new PixelCanvas canvas, 627, 627, 10, 10, 3, 'rgba(189, 195, 199, 1.0)'
	# Set up the game status.
	gameLoop()

gameLoop = () ->
	# setTimeout gameLoop, 25 # 40 fps
	@pixelCanvas.draw()

init()
