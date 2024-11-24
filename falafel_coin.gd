extends Node3D

# Falafel Collectable

@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	animation_player.play("pick_up")
	queue_free()
