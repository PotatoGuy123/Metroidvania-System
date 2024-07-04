extends "res://Scenes/bullet.gd"

@onready var ammo= load("res://SampleProject/Player.tscn")
signal Ammo_change(value)

var can_shoot : bool = false

var threshold_time = 2
var timer = 0
var charge_ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#$Timer2.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	#if Input.is_action_just_released("shoot"):
		#_shoot()

func _physics_process(delta: float) -> void:
	if GlobalManager.player.laser_is_shooting == true:
		queue_free()
		GlobalManager.player.timer = 0
		GlobalManager.player.is_charge_ready = false
	if can_shoot:
		GlobalManager.player.timer2 = 0
		bullet_movement = bullet_speed * delta * bullet_direction
		translate(bullet_movement.normalized() * bullet_speed)
		charge_ready = false
		GlobalManager.player.has_shot = true
		GlobalManager.player.action2_started = false
	else:
		print(GlobalManager.player.get_child(4).get_child(0))
		position = GlobalManager.player.get_child(4).get_child(0).global_position
		
	if Input.is_action_pressed("shoot"):
		timer += delta
		
	if timer >= threshold_time:
		timer = 0
		print("hold")
		charge_ready=true
		GlobalManager.player.is_charge_ready = true
		GlobalManager.player.action2_started = true
	
	if charge_ready == true and Input.is_action_pressed("shoot"):
		pass
	if charge_ready == true and Input.is_action_just_released("shoot"):
		_shoot()
	if charge_ready == false and Input.is_action_just_released("shoot"):
		queue_free()
	
		

func _shoot():
	GlobalManager.player.change_ammo_count(5)
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
		body.take_damage(30)

func _on_timer_2_timeout():
	_shoot()
