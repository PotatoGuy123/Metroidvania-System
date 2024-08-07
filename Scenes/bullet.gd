extends Area2D
class_name BaseBullet

@export var bullet_speed = 22
var bullet_movement : Vector2 = Vector2()
var bullet_direction : Vector2
var bullet_life = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = GlobalManager.player.bullet_marker_parent.rotation
	GlobalManager.player.change_ammo_count(1)
	$Timer2.start()

func check_direction(dir : Vector2):
	bullet_direction = dir
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#bullet_direction = GlobalManager.player.aim_direction
	bullet_movement = bullet_speed * delta * bullet_direction
	translate(bullet_movement.normalized() * bullet_speed)

func bullet_rotation(value):
	#rotation = value
	pass

func _on_timer_timeout():
	
	queue_free()


func _on_body_entered(body):
	if !body.name == "Player":
		queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(10)

func _get_button_down(shoot):
	pass

func _on_timer_2_timeout():
	pass
