extends "res://Scenes/bullet.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Timer2.start()
	print("I want to die")
	
func _get_button_down(shoot):
	pass

func _on_timer_timeout():
	print_debug("yippee")
	queue_free()

func _on_body_entered(body):
	if !body.name == "Player":
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(30)

func _on_timer_2_timeout():
	print("hell")
