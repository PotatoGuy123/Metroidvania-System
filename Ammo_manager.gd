extends Node

@export var max_ammo_count = 25
var ammo_count
# Called when the node enters the scene tree for the first time.
func _ready():
	ammo_count = max_ammo_count


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
