# This script is based on the default CharacterBody2D template. Not much interesting happening here.
extends CharacterBody2D

@export var max_health = 100
var health

@onready var load_bullets= preload("res://Scenes/bullet.tscn")
@onready var load_charge_bullets = preload("res://Scenes/charge.tscn")

var damage: int = 50
var bullet_direction = Vector2()
@onready var bullet_marker = $Bullet_Exit_Parent/Bullet_Exit_Position
@onready var bullet_marker_parent = $Bullet_Exit_Parent
var is_aiming_up = false
var is_aiming_down = false
var is_aiming = false

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
var current_direction = "Idle"
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation: String

var reset_position: Vector2
# Indicates that the player has an event happening and can't be controlled.
var event: bool

var abilities: Array[StringName]
var double_jump: bool
var prev_on_floor: bool

var aim_direction : Vector2

var can_jump : bool = true

@onready var health_text : Label = %HealthText

func _ready() -> void:
	on_enter()
	health = max_health
	GlobalManager.player = self

func _physics_process(delta: float) -> void:
	check_bullet_direction()
	
	if event:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	elif not prev_on_floor and &"double_jump" in abilities:
		# Some simple double jump implementation.
		double_jump = true
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or double_jump) and can_jump:
		if not is_on_floor():
			double_jump = false
		
		if Input.is_action_pressed("down"):
			position.y += 8
		else:
			velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	var vertical_direction := Input.get_axis("up", "down")
	
	aim_direction = Input.get_vector("left", "right", "up", "down", 0.8)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	prev_on_floor = is_on_floor()
	
	var temp_vel_x : float = velocity.x
	
	if Input.is_action_pressed("Aim") && is_on_floor():
		velocity.x = 0
		can_jump = false
	elif Input.is_action_just_released("Aim"):
		can_jump = true
	
	move_and_slide()
	
	velocity.x = temp_vel_x
	
	var new_animation = &"Idle"
	if velocity.y < 0:
		new_animation = &"Jump"
	elif velocity.y >= 0 and not is_on_floor():
		new_animation = &"Fall"
	elif absf(velocity.x)  > 1 && !Input.is_action_pressed("Aim"):
		new_animation = &"Run"
	
	if new_animation != animation:
		animation = new_animation
		$AnimationPlayer.play(new_animation)
	
	if velocity.x > 1:
		$Sprite2D.flip_h = false
		current_direction = "Right"
	elif velocity.x < -1:
		$Sprite2D.flip_h = true
		current_direction = "Left"
	if Input.is_action_just_pressed("die"):
		take_damage(damage)
	if Input.is_action_just_pressed("shoot"):
		shoot()

func check_current_aim():
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if Input.is_action_pressed("Aim_up"):
		is_aiming_up = true
	if Input.is_action_just_released("Aim_up"):
		is_aiming_up = false

func check_bullet_direction():
	if aim_direction != Vector2.ZERO:
		bullet_direction = aim_direction
	else:
		if current_direction == "Left":
			bullet_marker_parent.rotation_degrees = 180
			bullet_direction = Vector2(-1, 0)
		if current_direction == "Right":
			bullet_marker_parent.rotation_degrees = 0
			bullet_direction = Vector2(1, 0)
	
	var aim_direction_modifier : Vector2 = aim_direction
	
	_look_at_target_interpolated(1)

func shoot():
	var get_bullets = load_charge_bullets.instantiate()
	if current_direction == "Left":
		get_bullets.check_direction(bullet_direction)
	if current_direction == "Right":
		get_bullets.check_direction(bullet_direction)
	get_parent().add_child(get_bullets)
	get_bullets.position = bullet_marker.global_position

func kill():
	# Player dies, reset the position to the entrance.
	position = reset_position
	health = max_health
	Game.get_singleton().load_room(MetSys.get_current_room_name())

func on_enter():
	# Position for kill system. Assigned when entering new room (see Game.gd).
	reset_position = position
	update_health_text()

func take_damage(value):
	health -= value
	update_health_text()
	if health <= 0:
		kill()

func update_health_text():
	health_text.text = str(health) + "/" + str(max_health)

func _look_at_target_interpolated(weight:float) -> void:
	var xform : Transform2D = bullet_marker_parent.transform # your transform
	xform = xform.looking_at(aim_direction)
	bullet_marker_parent.transform = bullet_marker_parent.transform.interpolate_with(xform,weight)

func _on_area_2d_body_entered(body):
	pass # Replace with function body.
