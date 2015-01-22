
class PixelCanvas
	constructor: (@canvas, @pixel_height, @pixel_width, @square_width, @square_height, @square_gap, @default_square_colour) ->
		# Get the canvas context and set it's size.
		@context = @canvas.getContext '2d'
		@canvas.width = @pixel_width
		@canvas.height = @pixel_height
		# Work out the sizes for each square.
		total_gaps_width = (@square_width-1)*square_gap
		console.log total_gaps_width
		@square_pixel_width = Math.floor (@pixel_height-total_gaps_width)/@square_width
		console.log @square_pixel_width
		total_gaps_height = (@square_height-1)*square_gap
		console.log total_gaps_height
		@square_pixel_height = Math.floor (@pixel_height-total_gaps_height)/@square_height
		console.log @square_pixel_height

	draw: () ->
		placement_width = @square_pixel_width + @square_gap
		placement_height = @square_pixel_height + @square_gap
		for i in [0..@square_width-1]
			for j in [0..@square_height-1]
				@context.fillStyle = @default_square_colour
				@context.fillRect i*placement_width, j*placement_height,
					@square_pixel_width, @square_pixel_height

module.exports = PixelCanvas
