extends "res://Scenes/bullet.gd"

@onready var ammo= load("res://SampleProject/Player.tscn")
signal Ammo_change(value)

var can_shoot : bool = false

var threshold_time = 2
var timer = 0
var charge_ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	print("hi 2")
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$HappyBulletFren.visible = false
	pass
	#$Timer2.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	#if Input.is_action_just_released("shoot"):
		#_shoot()

func _physics_process(delta: float) -> void:
	if can_shoot == false:
		rotation = GlobalManager.player.bullet_marker_parent.rotation
	if GlobalManager.player.laser_is_shooting == true:
		queue_free()
		GlobalManager.player.timer = 0
		GlobalManager.player.is_charge_ready = false
	if can_shoot:
		$CollisionShape2D.disabled = false
		$Area2D/CollisionShape2D.disabled = false
		$HappyBulletFren.visible = true
		GlobalManager.player.timer2 = 0
		bullet_movement = bullet_speed * delta * bullet_direction
		translate(bullet_movement.normalized() * bullet_speed)
		charge_ready = false
		GlobalManager.player.has_shot = true
		GlobalManager.player.action2_started = false
	else:
		
		position = GlobalManager.player.get_child(4).get_child(0).global_position
		
	if Input.is_action_pressed("shoot"):
		timer += delta
		
	if timer >= threshold_time:
		timer = 0
		
		charge_ready=true
		GlobalManager.player.is_charge_ready = true
		GlobalManager.player.action2_started = true
	
	if charge_ready == true and Input.is_action_pressed("shoot"):
		pass
	if charge_ready == true and Input.is_action_just_released("shoot"):
		if GlobalManager.player.aim_direction > Vector2(0,0) or GlobalManager.player.aim_direction < Vector2(0,0):
			bullet_direction = GlobalManager.player.aim_direction
		else:
			if GlobalManager.player.current_direction == "Left":
				bullet_direction = Vector2(-1,0)
			if GlobalManager.player.current_direction == "Right":
				bullet_direction = Vector2(1,0)
		_shoot()
	if charge_ready == false and Input.is_action_just_released("shoot"):
		queue_free()
	
		

func _shoot():
	if GlobalManager.player.ammo_count >= 5:
		GlobalManager.player.change_ammo_count(5)
		
		can_shoot = true
		
	$Timer.start()

func _on_timer_timeout():
	
	queue_free()

func _on_body_entered(body):
	if !body.name == "Player":
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(30)

func _on_timer_2_timeout():
	_shoot()
