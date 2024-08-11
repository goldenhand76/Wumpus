extends TileMap

enum CellType { EMPTY, WUMPUS, PIT, BAT, GOLD, BREEZE, STINK }

const TILE_SIZE = 64  # Size of one grid tile

var MAP_SIZE = 10  # Define the size of your grid
var grid = []  # This will store your game grid
var neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]]

func _ready():
	generate_map()
	$Camera2D.offset = Vector2(TILE_SIZE * MAP_SIZE/2, TILE_SIZE * MAP_SIZE/2)
	var player = get_node("../Player")  # Adjust path if necessary
	var ui = get_node("../UI")
	player.set_map_size(MAP_SIZE)
	player.set_grid(grid)
	ui.get_node("MessageLabel")
	ui.new_position(Vector2(TILE_SIZE * MAP_SIZE/2, -100))
	
func generate_map():
	grid.clear()
	for i in range(MAP_SIZE):
		grid.append([])
		for j in range(MAP_SIZE):
			grid[i].append(CellType.EMPTY)
			set_cell(0, Vector2i(j, i), 0, Vector2(0,0))

	# Place Wumpus, pits, and bats randomly
	add_wumpus()
	add_pit()
	grid[randi_range(0, MAP_SIZE - 1)][randi_range(0, MAP_SIZE - 1)] = CellType.BAT
	grid[randi_range(0, MAP_SIZE - 1)][randi_range(0, MAP_SIZE - 1)] = CellType.GOLD

	# Pass grid to player (done later in this guide)
func update_tilemap():
	for i in range(MAP_SIZE):
		for j in range(MAP_SIZE):
			var cell_type = grid[i][j]
			if cell_type == CellType.EMPTY:
				set_cell(0, Vector2i(j, i), 0, Vector2(0,0))  # Place an EMPTY tile
			elif cell_type == CellType.WUMPUS:
				set_cell(0, Vector2i(j, i), 1, Vector2(0,0))  # Place a WUMPUS tile
			elif cell_type == CellType.PIT:
				set_cell(0, Vector2i(j, i), 2, Vector2(0,0))  # Place a PIT tile
			elif cell_type == CellType.BAT:
				set_cell(0, Vector2i(j, i), 3, Vector2(0,0))  # Place a BAT tile
			elif cell_type == CellType.GOLD:
				set_cell(0, Vector2i(j, i), 4, Vector2(0,0))  # Place a BAT tile
			elif cell_type == CellType.BREEZE:
				set_cell(0, Vector2i(j, i), 5, Vector2(0,0))  # Place a BAT tile
			elif cell_type == CellType.STINK:
				set_cell(0, Vector2i(j, i), 6, Vector2(0,0))  # Place a BAT tile

func add_wumpus():
	var rand_x = randi_range(0, MAP_SIZE - 1)
	var rand_y = randi_range(0, MAP_SIZE - 1)
	grid[rand_x][rand_y] = CellType.WUMPUS
	for i in neighbors:
		if rand_x + i[0] >= 0 and rand_y + i[1] >= 0:
			if rand_x + i[0] < MAP_SIZE and rand_y + i[1] < MAP_SIZE:
				grid[rand_x + i[0]][rand_y + i[1]] = CellType.STINK

func add_pit():
	var rand_x = randi_range(0, MAP_SIZE - 1)
	var rand_y = randi_range(0, MAP_SIZE - 1)
	grid[rand_x][rand_y] = CellType.PIT
	for i in neighbors:
		if rand_x + i[0] >= 0 and rand_y + i[1] >= 0:
			if rand_x + i[0] < MAP_SIZE and rand_y + i[1] < MAP_SIZE:
				grid[rand_x + i[0]][rand_y + i[1]] = CellType.BREEZE
