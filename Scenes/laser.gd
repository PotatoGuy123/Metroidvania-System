extends "res://Charge.gd"

var shot = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta: float) -> void:
	if can_shoot:
		#bullet_movement = bullet_speed * delta * bullet_direction
		#translate(bullet_movement.normalized() * bullet_speed)
		charge_ready = false
		GlobalManager.player.has_shot = true
	else:
		print(GlobalManager.player.get_child(4).get_child(0))
		position = GlobalManager.player.get_child(4).get_child(0).global_position
		
	if Input.is_action_pressed("shoot"):
		timer += delta
		
	if timer >= threshold_time and GlobalManager.player.ammo_count > 0 and shot == false:
		timer = 0
		print("hold")
		charge_ready=true
		GlobalManager.player.is_charge_ready = true
		_shoot()
		shot = true
		
	if shot == true and GlobalManager.player.ammo_count > 0:
		GlobalManager.player.change_ammo_count(1)
	
	#if charge_ready == true and Input.is_action_just_released("shoot"):
		#_shoot()
	if charge_ready == false and Input.is_action_just_released("shoot"):
		queue_free()
		

func _shoot():
	print(GlobalManager.player.ammo_count)
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
		body.take_damage(50)
