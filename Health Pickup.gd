extends Area2D

func _ready() -> void:
	# Register as storable with a marker. The marker will appear on the map when the orb is first discovered (i.e. get instantiated).
	MetSys.register_storable_object_with_marker(self)

func collect(body: Node2D) -> void:
	# Check if player collided.
	if not body.is_in_group("Player"):
		return
	if body.is_in_group("Player"):
		if body.max_health - body.health >= 25:
			print(body.max_health - body.health)
			body.health += 25
		elif body.max_health - body.health < 25:
			print(body.max_health - body.health)
			body.health += body.max_health - body.health
		body.update_health_text()
	# Increase collectible counter.
	# Store the orb. This will automatically assign the collected marker.
	MetSys.store_object(self)
	# Storing object does not free it automatically.
	queue_free()
