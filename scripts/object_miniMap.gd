extends Node2D

var dot = "res://scenes/objects/object_minimapDot.tscn"
var map = [[null,null,null,null,null],
[null,null,null,null,null],
[null,null,null,null,null],
[null,null,null,null,null],
[null,null,null,null,null]]
var started = false
var last_one = Vector2(2,0)

func _ready():
	gen_map()
	map[2][0].frame = 2
	pass

func gen_map():
	for x in range(5):
		for y in range(5):
			map[y][x] = d_instance(x,y)
	pass

func d_instance(x,y):
	var d = load(dot).instance()
	d.global_position = Vector2((4*x)+3,(4*y)+3)
	add_child(d)
	return d
	pass

func _on_object_player_LimitCross(qdX, qdY):
	if started:
		map[last_one.x][last_one.y].frame = 1
		map[qdY][qdX].frame = 2
		last_one.x = qdY
		last_one.y = qdX
	else:
		started = true
	pass
