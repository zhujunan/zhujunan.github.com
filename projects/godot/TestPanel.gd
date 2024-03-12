extends VBoxContainer

var world

func _ready() -> void:
	world = get_parent().get_parent()

func _on_button_button_down() -> void:
	world.auto_create_card()

func _on_button_2_button_down() -> void:
	for tmp_card in $"../../Cards".get_children():
		tmp_card.call_deferred("health_change", 10)
