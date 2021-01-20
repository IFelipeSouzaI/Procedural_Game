extends Node

export var demonstration = false

var enemies = "res://scenes/objects/object_enemy0"

var door = "res://scenes/objects/object_door.tscn"
var doorPos = Vector2.ZERO

var f_room = "res://scenes/objects/rooms/EXIT_ROOM.tscn"
var rooms = ["res://scenes/objects/rooms/LR/LR_Room",
"res://scenes/objects/rooms/LRU/LRU_Room",
"res://scenes/objects/rooms/LRD/LRD_Room",
"res://scenes/objects/rooms/LRUD/LRUD_Room",
"res://scenes/objects/rooms/FILL_ROOM.tscn"]

var rt = []

var stPY = 0

func _ready():
	
	stPY = int(rand_range(0,4.9))
	randomize()
	path_creator(stPY)
	
	pass

func gen_room(t, p): # t = type, p = pos
	randomize()
	var r = null
	
	if t == 9:
		r = load(rooms[0]+"0.tscn").instance()
	elif t == 8:
		r = load(f_room).instance()
	elif t != 4:
		r = load(rooms[t]+str(randi()%8)+".tscn").instance()
	else:
		r = load(rooms[4]).instance()
	
	for y in range(11):
		for x in range(12):
			var c = r.get_cell(x-1,y)
			if c != -1:
				var cPos = Vector2((p.x/16)-1,(p.y/16))
				if c > 0:
					var cs = randi()%3
					if cs and t != 9:
						e_instance(c,(Vector2((cPos.x+x)*16+8,(cPos.y+y)*16+8)))
				else:
					$tile.set_cell(cPos.x+x,cPos.y+y,c)
	r.queue_free()
	pass

func path_creator(py):
	var working = true
	var mat = [[0,0,0,0,0],
	[0,0,0,0,0],
	[0,0,0,0,0],
	[0,0,0,0,0],
	[0,0,0,0,0]]
	var spot = Vector2(0,py*144)
	mat[spot.y/144][spot.x/160] = 10
	var r = 4
	
	# 1 = LR
	# 2 = Up
	# 3 = Down
	# 4 = all sides
	# 10 = Entry
	# 9 = Exit
	
	while working:
		if r == 0 || r == 1: # Up
			if spot.y + 144 < 720:
				if mat[spot.y/144][spot.x/160] == 1:
					mat[spot.y/144][spot.x/160] = 3
				else:
					mat[spot.y/144][spot.x/160] = 4
				spot += Vector2(0,144)
				mat[spot.y/144][spot.x/160] = 2
				r = randi()%5
				if r == 2:
					r = 1
				elif r == 3:
					r = 4
			else:
				r = 4
		elif r == 2 || r == 3: # Down
			if spot.y - 144 >= 0:
				if mat[spot.y/144][spot.x/160] == 1:
					mat[spot.y/144][spot.x/160] = 2
				else:
					mat[spot.y/144][spot.x/160] = 4
				spot -= Vector2(0,144)
				mat[spot.y/144][spot.x/160] = 3
				r = (randi()%3)+2
			else:
				r = 4
		else: # Right
			if spot.x + 160 < 800:
				spot += Vector2(160,0)
				mat[spot.y/144][spot.x/160] = 1
				r = randi()%5
			else:
				mat[spot.y/144][spot.x/160] = 9
				doorPos.x = spot.x + 128
				doorPos.y = spot.y + 113
				working = false
	
	for x in range(5):
		for y in range(5):
			if mat[x][y] != 0:
				if demonstration:
					var timer = Timer.new()
					timer.set_wait_time(0.25)
					add_child(timer)
					timer.start()
					yield(timer, "timeout")
				gen_room(mat[x][y]-1, Vector2(y*160,x*144))
			else:
				if demonstration:
					var timer = Timer.new()
					timer.set_wait_time(0.25)
					add_child(timer)
					timer.start()
					yield(timer, "timeout")
				gen_room(4, Vector2(y*160,x*144))
	
	d_instance()
	
	$tile.update_bitmask_region(Vector2(0,0),Vector2(640,576))
	pass

func d_instance():
	var d = load(door).instance()
	d.global_position = doorPos
	add_child(d)
	pass

func e_instance(id, pos):
	var e = load(enemies+str(id)+".tscn").instance()
	e.global_position = pos
	add_child(e)
	pass

"""
var t = Timer.new()
t.set_wait_time(0.15)
add_child(t)
t.start()
yield(t, "timeout")
"""


func _on_reset_timer_timeout():
	var _e = get_tree().change_scene("res://demonstration.tscn")
	pass
