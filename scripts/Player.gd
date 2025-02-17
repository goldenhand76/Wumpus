extends CharacterBody2D

const TILE_SIZE = 64  # Size of one grid tile
var map_size = 0  # This will be set by the TileMap script
var grid = []  # This will represent the map grid, passed from the TileMap script

var player_pos = Vector2(0, 0)  # Start at the top-left corner

func set_map_size(size):
	map_size = size

func set_grid(new_grid):
	grid = new_grid
	
func _ready():
	position = player_pos * TILE_SIZE

func _input(event):
	var ev = InputEventAction.new()

	if event is InputEventScreenDrag:
		if abs(event.relative[0]) > abs(event.relative[1]):
			if event.relative[0] > 1:
				$Sprite2D.scale = Vector2(1, 1)
				move_player(Vector2(1, 0))
			elif event.relative[0] < -1:
				$Sprite2D.scale = Vector2(-1, 1)
				move_player(Vector2(-1, 0))
		else:
			if event.relative[1] < -1:
				move_player(Vector2(0, -1))
			elif event.relative[1] > 1:
				move_player(Vector2(0, 1))
				
	elif event.is_action_pressed("ui_up"):
		move_player(Vector2(0, -1))
	elif event.is_action_pressed("ui_down"):
		move_player(Vector2(0, 1))
	elif event.is_action_pressed("ui_left"):
		$Sprite2D.scale = Vector2(-1, 1)
		move_player(Vector2(-1, 0))
	elif event.is_action_pressed("ui_right"):
		$Sprite2D.scale = Vector2(1, 1)
		move_player(Vector2(1, 0))

#func _unhandled_input(event):
	#print(event)
	
func move_player(direction):
	var target = player_pos + direction
	if target.x >= 0 and target.x < map_size and target.y >= 0 and target.y < map_size:
		player_pos = target
		var tween = create_tween()
		tween.tween_property(self, "position", target*TILE_SIZE, 0.5)
		$AnimationPlayer.play("moving")
		self.set_process_input(false)
		await tween.finished
		self.set_process_input(true)
		$AnimationPlayer.stop()
		#position = player_pos * TILE_SIZE
		check_room()

func check_room():
	var room = grid[player_pos.y][player_pos.x]
	var ui = get_node("../UI")  # Adjust the path if necessary
	if room == 1:
		ui.display_message("The Wumpus got you!")
		game_over("The Wumpus got you!")
	elif room == 2:
		ui.display_message("You fell into a pit!")
		game_over("You fell into a pit!")
	elif room == 3:
		random_teleport()
		ui.display_message("Bats carried you to a new location!")
	elif room == 5:
		ui.display_message("Feeling breeze!")
	elif room == 6:
		ui.display_message("Feeling Stink!")
	else:
		ui.display_message("You are in a safe room.")

func game_over(message):
	print(message)
	var map = get_node("../TileMap")
	map.update_tilemap()
	get_tree().paused = true
	# Await input to restart
	await_user_input()
	
func random_teleport():
	player_pos = Vector2(randi_range(0, map_size - 1), randi_range(0, map_size - 1))
	position = player_pos * TILE_SIZE
	check_room()


func _on_no_pressed():
		# Quit the game or go back to the main menu
	print("No Button Pressed")
	get_tree().quit()  # Or load the main menu scene


func _on_yes_pressed():
		# Restart the current scene
	print("Yes Button Pressed")
	get_tree().reload_current_scene()

func await_user_input():
	while true:
		if Input.is_action_just_pressed("ui_accept"):  # Assuming "ui_accept" is bound to Enter/Space
			get_tree().reload_current_scene()
			break
		elif Input.is_action_just_pressed("ui_cancel"):  # Assuming "ui_cancel" is bound to Esc
			get_tree().quit()
			break
		await get_tree().process_frame  # Wait for the next frame
