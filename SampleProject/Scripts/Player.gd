# This script is based on the default CharacterBody2D template. Not much interesting happening here.
extends CharacterBody2D

const SPEED_MIN = 300.0
const SPEED_MAX = 400.0
const ACCEL = 50.0
const JUMP_VELOCITY = -450.0
const MAX_FALL_SPEED = 900.0
const COYOTE_TIME: float = .1
const SHORT_HOP: float = .5

<<<<<<< Updated upstream
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
=======
var shoot_charge = false
var shoot_super_charge = false
var charge_again = false

@onready var load_bullets= load("res://Scenes/bullet.tscn")
@onready var load_charge_bullets = load("res://Scenes/charge.tscn")
@onready var load_laser = load("res://Scenes/laser.tscn")

@export var damage: int = 50
var bullet_direction = Vector2()
@onready var bullet_marker = $Bullet_Exit_Parent/Bullet_Exit_Position
@onready var bullet_marker_parent = $Bullet_Exit_Parent
var is_aiming_up = false
var is_aiming_down = false
var is_aiming = false

var has_shot = false
var is_charge_ready = false
var laser_is_shooting = false

@export var max_ammo_count = 25
@export var ammo_count : int

@export var charge_unlocked = false
@export var laser_unlocked = false
@export var super_charge_unlocked = false

var threshold_time = 0.5
var threshold_time2 = 1
var timer = 0
var timer2 = 0
var action_started = false
var action2_started = false

@export var SPEED = 300.0
@export var JUMP_VELOCITY = 800
@export var JUMP_TERMINATION_MULTIPLIER = 2
var current_direction = "Idle"
var gravity: int = 1000
>>>>>>> Stashed changes
var animation: String

var reset_position: Vector2
# Indicates that the player has an event happening and can't be controlled.
var event: bool

var abilities: Array[StringName]
var double_jump: bool
var prev_on_floor: bool
<<<<<<< Updated upstream
var airtime: float = 0
var speed: float = SPEED_MIN
=======

var aim_direction : Vector2

var can_jump : bool = true

@onready var health_text : Label = %HealthText
@onready var ammo_text : Label = %AmmoText

var controllerangle = Vector2(0,0)
@export var deadzone = 0.3

@onready var coyote_timer = $CoyoteTimer

var has_jumped = false
>>>>>>> Stashed changes

func _ready() -> void:
	on_enter()

func _physics_process(delta: float) -> void:
<<<<<<< Updated upstream
	if event:
		return
	
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, MAX_FALL_SPEED)
		airtime += delta
	elif not prev_on_floor and &"double_jump" in abilities:
		# Some simple double jump implementation.
		double_jump = true
		airtime = 0
	
	var on_floor_ct: bool = is_on_floor() or airtime < COYOTE_TIME
	if Input.is_action_just_pressed("ui_accept") and (on_floor_ct or double_jump):
		if not on_floor_ct:
			double_jump = false
		
		if Input.is_action_pressed("ui_down"):
			position.y += 8
		else:
			velocity.y = JUMP_VELOCITY
=======
	var input_vector = get_input_vector()
	if charge_again ==  true:
		charge_shot()
	#var xAxisRL = Input.get_joy_axis(0, 0)
	#var yAxisUD = Input.get_joy_axis(0 ,1)
	#controllerangle = Vector2(xAxisRL, yAxisUD).angle()
	
	
	#rotation = controllerangle
	#print(rotation)
	controllerangle = Input.get_vector("left", "right", "up", "down", deadzone).angle()
	bullet_marker_parent.rotation = controllerangle
	check_bullet_direction()
	
	if event:
		return
	
	
	var direction := Input.get_axis("left", "right")
	var vertical_direction := Input.get_axis("up", "down")
>>>>>>> Stashed changes
	
	if Input.is_action_just_released("ui_accept"):
		if not is_on_floor() and velocity.y < 0:
			velocity.y = min(0, velocity.y - JUMP_VELOCITY * SHORT_HOP)
			
	
	if is_on_wall():
		speed = SPEED_MIN
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		speed = min(SPEED_MAX, speed + ACCEL * delta)
		velocity.x = direction * speed
	else:
<<<<<<< Updated upstream
		velocity.x = move_toward(velocity.x, 0, SPEED_MIN)
		speed = SPEED_MIN

	prev_on_floor = is_on_floor()
	move_and_slide()
	
=======
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	
	
	
	var temp_vel_x : float = velocity.x
	
	
		#velocity.y += gravity * delta
	#elif not prev_on_floor and &"double_jump" in abilities:
		# Some simple double jump implementation.
		#double_jump = true
		
	if is_on_floor():
		has_jumped = false
	
	if input_vector.y < 0 and (is_on_floor() or !coyote_timer.is_stopped()) and has_jumped == false:
		velocity.y = input_vector.y * JUMP_VELOCITY
		
	if velocity.y < 0 and !Input.is_action_just_pressed("Jump"):
		velocity.y += gravity * JUMP_TERMINATION_MULTIPLIER * delta
		has_jumped = true
	else:
		velocity.y += gravity * delta
	
	#if Input.is_action_just_pressed("jump") and (is_on_floor() or double_jump or not coyote_timer.is_stopped()) and can_jump:
		#if not is_on_floor():
			#double_jump = false
		
		#if Input.is_action_pressed("down"):
			#position.y += 8
		#else:
			#velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("Aim"):
		#&& is_on_floor()
		velocity.x = 0
		can_jump = false
	elif Input.is_action_just_released("Aim"):
		can_jump = true
	prev_on_floor = is_on_floor()
	
	move_and_slide()
	
	if not is_on_floor() and prev_on_floor:
		coyote_timer.start()
	
	velocity.x = temp_vel_x
	
>>>>>>> Stashed changes
	var new_animation = &"Idle"
	if velocity.y < 0:
		new_animation = &"Jump"
	elif velocity.y >= 0 and not is_on_floor():
		new_animation = &"Fall"
	elif absf(velocity.x) > 1:
		new_animation = &"Run"
	
	if new_animation != animation:
		animation = new_animation
		$AnimationPlayer.play(new_animation)
	
	if velocity.x > 1:
		$Sprite2D.flip_h = false
	elif velocity.x < -1:
		$Sprite2D.flip_h = true
<<<<<<< Updated upstream
=======
		current_direction = "Left"
	if Input.is_action_just_pressed("die"):
		take_damage(damage)
	#if Input.is_action_just_pressed("shoot"):
		#shoot()
	if Input.is_action_just_pressed("shoot"):
		action_started = true
		has_shot = false
		
	if Input.is_action_pressed("shoot") and action_started:
		timer += delta
		
	if timer >= threshold_time and action_started:
		action_started = false
		timer = 0
		
		charge_shot()

	if Input.is_action_just_released("shoot"):
		if timer < threshold_time and action_started:
			
			normal_shot()
			action_started = false
		timer = 0
			
	if Input.is_action_pressed("shoot") and has_shot == false and is_charge_ready == true and action2_started == true:
		timer2 += delta
		
	
	if Input.is_action_just_released("shoot") and has_shot == false and is_charge_ready == true:
		timer2 = 0
		timer = 0
	
	if timer2 >= threshold_time2 and has_shot == false and action2_started == true:
		has_shot = true
		action2_started = false
		timer = 0
		timer2 = 0
		
		laser_shot()
	
	check_bullet_direction()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return input_vector
	
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

func normal_shot():
	if ammo_count > 0:
		var get_bullets = load_bullets.instantiate()
		get_bullets.bullet_rotation(controllerangle)
		if current_direction == "Left":
			get_bullets.check_direction(bullet_direction)
		if current_direction == "Right":
			get_bullets.check_direction(bullet_direction)
		get_parent().add_child(get_bullets)
		get_bullets.position = bullet_marker.global_position
		#ammo_count= ammo_count-1
		

func charge_shot():
	if charge_unlocked == true:
		if shoot_charge == true:
			var get_bullets = load_charge_bullets.instantiate()
			get_bullets.bullet_rotation(controllerangle)
			if current_direction == "Left":
				get_bullets.check_direction(bullet_direction)
			if current_direction == "Right":
				get_bullets.check_direction(bullet_direction)
			get_parent().add_child(get_bullets)
			get_bullets.position = bullet_marker.global_position
			get_bullets.can_shoot = true
			if shoot_super_charge == true:
				print("ploo")
				get_bullets.damage = 60
		elif ammo_count > 0 :
			var get_bullets = load_charge_bullets.instantiate()
			get_bullets.bullet_rotation(controllerangle)
			if current_direction == "Left":
				get_bullets.check_direction(bullet_direction)
			if current_direction == "Right":
				get_bullets.check_direction(bullet_direction)
			get_parent().add_child(get_bullets)
			get_bullets.position = bullet_marker.global_position
			#ammo_count= ammo_count-5
			#print(ammo_count)
			

func laser_shot():
	if super_charge_unlocked == true:
		laser_is_shooting = true
		if ammo_count > 0:
			var get_bullets = load_laser.instantiate()
			get_bullets.bullet_rotation(controllerangle)
			if current_direction == "Left":
				get_bullets.check_direction(bullet_direction)
			if current_direction == "Right":
				get_bullets.check_direction(bullet_direction)
			get_parent().add_child(get_bullets)
			get_bullets.position = bullet_marker.global_position
			#ammo_count= ammo_count-5
			#print(ammo_count)
			
			
func change_ammo_count(value):
	ammo_count = ammo_count - value
	update_ammo_text()
	
	
func melee():
	pass
>>>>>>> Stashed changes

func kill():
	# Player dies, reset the position to the entrance.
	position = reset_position
	Game.get_singleton().load_room(MetSys.get_current_room_name())

func on_enter():
	# Position for kill system. Assigned when entering new room (see Game.gd).
	reset_position = position
