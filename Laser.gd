extends RayCast2D

@onready var load_charge_bullets = load("res://Scenes/charge.tscn")

@export var bullet_speed = 22
var bullet_movement : Vector2 = Vector2()
var bullet_direction : Vector2
var bullet_life = 0

var can_shoot : bool = false

var threshold_time = 2
var timer = 0
var timer2 = 0
var threshold_time2 = 0.1
var charge_ready = false

var is_casting: bool = false
var is_shooting = false

var cast_point = Vector2.ZERO

@onready var casting_particles: GPUParticles2D = $CastingParticles2D
@onready var collision_particles_2: GPUParticles2D = $CollisionParticles2D
@onready var beam_particle_2d: GPUParticles2D = $BeamParticle2D

#var is_casting: bool = false :
	#set(value): 
		#is_casting = value
		
		#beam_particle_2d.emitting = is_casting
		#casting_particles.emitting = is_casting
		
		#if is_casting:
			#appear()
		#else:
			#collision_particles_2.emitting = false
			#disapear()
		#set_physics_process(is_casting)

func _ready():
	
	is_casting = false
	$Line2D.visible = false

#func _unhandled_input(event: InputEvent) -> void:
		#if event is InputEventJoypadButton:
			#self.is_casting = event.pressed
func _process(delta):
	if is_casting:	
		if is_colliding():
			var collision = get_collider()
			if collision != null:
				if collision.is_in_group("Enemy"):
					if collision.health > 0:
						collision.take_damage(0.1)


func _physics_process(delta: float) -> void:
	rotation = GlobalManager.player.bullet_marker_parent.rotation
	
	
	force_raycast_update()
	
	#bullet_movement = bullet_speed * delta * bullet_direction
	#translate(bullet_movement.normalized() * bullet_speed)
	if is_casting:
		cast_point = target_position
		collision_particles_2.emitting = is_colliding()
	
	if is_colliding() and is_casting:
		cast_point = to_local(get_collision_point())
		collision_particles_2.global_rotation = get_collision_normal().angle()
		collision_particles_2.position = cast_point
	
	#$Line2D.points[0] = GlobalManager.player.position
	$Line2D.points[1] = cast_point
	beam_particle_2d.position = cast_point * 0.5
	beam_particle_2d.process_material.emission_box_extents.x = cast_point.length() * 0.5
	
	print(cast_point)
	
	if can_shoot:
		#bullet_movement = bullet_speed * delta * bullet_direction
		#translate(bullet_movement.normalized() * bullet_speed)
		charge_ready = false
		GlobalManager.player.has_shot = true
	else:
		
		position = GlobalManager.player.get_child(4).get_child(0).global_position
		
	if Input.is_action_pressed("shoot"):
		print("starting laser")
		timer += delta
		
	if timer < threshold_time and Input.is_action_just_released("shoot") and is_casting == false:
		print("hi")
		GlobalManager.player.shoot_charge = true
		GlobalManager.player.charge_shot()
		
		#var get_bullets = load_charge_bullets.instantiate()
		#get_bullets.timer = 3
		#get_bullets.can_shoot = true
		
	if timer >= threshold_time and Input.is_action_just_released("shoot") and is_casting == false:
		print("hellop")
		GlobalManager.player.shoot_charge = true
		GlobalManager.player.shoot_super_charge = true
		GlobalManager.player.charge_shot()
		
	if timer >= threshold_time and Input.is_action_pressed("alt fire") and GlobalManager.player.laser_unlocked == true:
		timer = 0
		
		is_casting = true
		shoot()
		#GlobalManager.player.is_charge_ready = true
		
	
		
		
	if is_casting == true:
		timer2 += delta
		if Input.is_action_just_released("alt fire"):
			queue_free()
		
	if timer2 >= threshold_time2:
		GlobalManager.player.change_ammo_count(1) 
		timer2 = 0
		
	if Input.is_action_pressed("shoot") and GlobalManager.player.ammo_count > 0 and Input.is_action_just_released("alt fire"):
		GlobalManager.player.charge_again = true
		
	if Input.is_action_just_released("shoot") or !GlobalManager.player.ammo_count > 0:
		queue_free()
		GlobalManager.player.laser_is_shooting = false
		GlobalManager.player.has_shot = false
		GlobalManager.player.is_charge_ready = false
		is_casting = false
		is_shooting = false
		
	
func shoot():
	await get_tree().process_frame 
	$Line2D.visible = true
	#can_shoot = true
	#target_position = bullet_direction
	is_shooting = true
	beam_particle_2d.emitting = is_casting
	casting_particles.emitting = is_casting
		
	if is_casting == true:
		appear()
	#else:
		#collision_particles_2.emitting = false
		#disapear()
	set_physics_process(is_casting)
	
func bullet_rotation(value):
	rotation = value
	

func check_direction(dir : Vector2):
	bullet_direction = dir

func appear() -> void:
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 3.0, 0.2)


#func disapear() -> void:
	#var tween = create_tween()
	#tween.tween_property($Line2D, "width", 0, 0.1)

