extends "res://Scenes/bullet.gd"

var can_shoot : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer2.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	if Input.is_action_just_released("shoot"):
		_shoot()

func _physics_process(delta):
	if can_shoot:
		bullet_movement = bullet_speed * delta * bullet_direction
		translate(bullet_movement.normalized() * bullet_speed)
	else:
		print(GlobalManager.player.get_child(4).get_child(0))
		position = GlobalManager.player.get_child(4).get_child(0).global_position

func _shoot():
	$Timer.start()
	can_shoot = true
	print("hooray")

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
	_shoot()
