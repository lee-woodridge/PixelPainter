PixelCanvas = require "./pixel_canvas"

# Game constants.
secondsPerLevel = 5

# Game variables.
gridSize = 2
@squareSize = 200
loops = 0
reactionGame = {}

randomNum = (max, min=0) ->
	return Math.floor(Math.random() * (max - min) + min)

init = () ->
	# Set up the game status.
	reactionGame = new ReactionGame()

gameLoop = () ->
	console.log "called"
	timer = setTimeout gameLoop, 20 # 50 fps
	loops = loops + 1
	if loops %% (50*secondsPerLevel) is 0
		clearTimeout(timer)
		reactionGame.endGame()

	PixelCanvas.updateGameCanvas()

class ReactionGame
	constructor: () ->
		easy = document.getElementById 'easy'
		easy.addEventListener 'click', (evt) => @newGame()

	newLevel: () ->
		gridSize = gridSize * 2
		@squareSize = @squareSize / 2
		PixelCanvas.createGameCanvas @canvas, @squareSize, gridSize, gridSize, 3, 'rgba(189, 195, 199, 1.0)'

	newGame: () ->
		@canvas = document.getElementById 'game-canvas'
		PixelCanvas.createGameCanvas {
			canvas: @canvas
			# @squareDim: @squareSize
			gridPixelWidth: 403
			gridPixelHeight: 403
			gridWidth: gridSize
			gridHeight: gridSize
			squareGap: 3
			defaultSquareColour: 'rgba(189, 195, 199, 1.0)'
		}
		@x = randomNum gridSize
		@y = randomNum gridSize
		squareArgs = {
			gridX: @x
			gridY: @y
			defaultColour: 'rgba(39, 174, 96, 1.0)'
			z: 2
		}
		@score = 0
		@scoreElement = document.getElementById 'score'
		@square = PixelCanvas.createGameObject squareArgs
		reactionClick = () =>
			console.log @square
			newX = @square.x
			newY = @square.y
			while newX == @square.x && newY == @square.y
				newX = randomNum gridSize
				newY = randomNum gridSize
				# console.log newX, newY
				# break unless newX == @square.x and newY == @square.y
			@square.moveTo newX, newY
			@score++
			@scoreElement.innerHTML = @score
		@square.assignOnClick reactionClick
		document.getElementById('game-menu').style.visibility = 'hidden'
		@canvas.style.visibility = 'visible'
		gameLoop()

	endGame: () ->
		@canvas.style.visibility = 'hidden'
		document.getElementById('game-menu').style.visibility = 'visible'

init()
