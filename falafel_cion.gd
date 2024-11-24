extends Node3D

@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	animation_player.play("pick_up")
	queue_free()
