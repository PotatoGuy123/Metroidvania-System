extends Area2D
@export var bullet_speed = 10
var bullet_movement : Vector2 = Vector2()
var bullet_direction : Vector2
var bullet_life = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func check_direction(dir : Vector2):
	bullet_direction = dir
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(bullet_speed * delta * bullet_direction)
	bullet_movement = bullet_speed * delta * bullet_direction
	translate(bullet_movement.normalized() * bullet_speed)


func _on_timer_timeout():
	print_debug("yippee")
	queue_free()


func _on_body_entered(body):
	if !body.name == "Player":
		queue_free()
