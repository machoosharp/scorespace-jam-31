extends Control

class_name PauseMenu

@export var CloseMenuButton: Button
@export var QuitGameButton: Button


func _ready():
	CloseMenuButton.pressed.connect(_on_button1_pressed)
	QuitGameButton.pressed.connect(_on_button3_pressed)
	hide()
	process_mode = PROCESS_MODE_WHEN_PAUSED


func pause():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func _on_button1_pressed() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func _on_button2_pressed() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func _on_button3_pressed() -> void:
	get_tree().free()


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
