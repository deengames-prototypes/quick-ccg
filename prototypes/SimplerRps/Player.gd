extends KinematicBody2D

const ZERO_VECTOR = Vector2(0, 0)

export var speed = 300

func _ready():
	Globals.player = self

func _physics_process(delta):
	self._move_to_keyboard()

func _move_to_keyboard():
	var velocity = Vector2(0, 0)
	var pressed_key = false
	
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		velocity.x = 1
		pressed_key = true
	elif Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
		velocity.x = -1
		pressed_key = true
	if Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W):
		velocity.y = -1
		pressed_key = true
	elif Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_S):
		velocity.y = 1
		pressed_key = true

	if velocity.x != 0 or velocity.y != 0:
		velocity = velocity.normalized() * self.speed
		velocity = self.move_and_slide(velocity, ZERO_VECTOR)