extends Node2D
var health = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(20)



func take_damage(value):
	health -= value
	if health <= 0:
		kill()

func kill():
	queue_free()
