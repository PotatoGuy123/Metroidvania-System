extends Area2D

func _ready() -> void:
	# Register as storable with a marker. The marker will appear on the map when the orb is first discovered (i.e. get instantiated).
	MetSys.register_storable_object_with_marker(self)

func collect(body: Node2D) -> void:
	# Check if player collided.
	if not body.is_in_group("Player"):
		return
	if body.is_in_group("Player"):
		body.max_health += 25
		body.health += 25
		body.update_health_text()
	# Increase collectible counter.
	Game.get_singleton().collectibles += 1
	# Store the orb. This will automatically assign the collected marker.
	MetSys.store_object(self)
	# Storing object does not free it automatically.
	queue_free()
