extends "res://Scenes/bullet.gd"

@onready var ammo= load("res://SampleProject/Player.tscn")
signal Ammo_change(value)

var can_move : bool = false

var damage = 30

var threshold_time = 2
var timer = 0
var charge_ready = false
var charge_amount = 0
@onready var base_scale : Vector2 = scale

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Spawning Charge Shot")
	$CollisionShape2D.disabled = true
	$Area2D/CollisionShape2D.disabled = true
	$HappyBulletFren.visible = true
	pass
	#$Timer2.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	#if Input.is_action_just_released("shoot"):
		#_shoot()

func _physics_process(delta: float) -> void:
	scale = Vector2(base_scale.x * charge_amount + 1, base_scale.y * charge_amount + 1)
	
	if can_move:
		$CollisionShape2D.disabled = false
		$Area2D/CollisionShape2D.disabled = false
		$HappyBulletFren.visible = true
		GlobalManager.player.timer2 = 0
		bullet_movement = bullet_speed * delta * bullet_direction
		translate(bullet_movement.normalized() * bullet_speed)
		charge_ready = false
	
		

func _shoot():
	if GlobalManager.player.ammo_count >= 5:
		GlobalManager.player.change_ammo_count(5)
		GlobalManager.player.charge_amount = 0
		can_move = true
		
	$Timer.start()

func _on_timer_timeout():
	destroy_bullet()

func _on_body_entered(body):
	if !body.name == "Player":
		destroy_bullet()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(damage)

func destroy_bullet() -> void:
	GlobalManager.player.can_charge = true
	queue_free()
