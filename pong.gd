#La bola se mueve automáticamente
#Las paletas se mueven con las teclas
#La bola rebota en la pared superior e inferior
#La bola rebota en las palas
#El juego se reinicia cuando sale por los extremos laterales
#La pelota se acelera cuando rebota en una paleta

extends Node2D

var screenSize
var padSize

#(in pixels/second)
var ballSpeed = 300

#direction(normal vector)
var direction = Vector2(-1,0)

#constant for pad speed (also in pixels/second)
const PAD_SPEED = 170

func _ready():
	screenSize = get_viewport_rect().size
	padSize = get_node("LeftPalette").get_texture().get_size()
	set_process(true)

func _process(delta):
	var ballPos = get_node("Ball").get_pos()
	var leftPaletteArea = Rect2( get_node("LeftPalette").get_pos() - padSize/16, padSize )
	var rightPaletteArea = Rect2( get_node("RightPalette").get_pos() - padSize/16, padSize )
	
	ballPos+=direction*ballSpeed*delta
	
	if ( (ballPos.y<0 and direction.y <0) or (ballPos.y>screenSize.y and direction.y>0)):
    	direction.y = -direction.y

	if ( (leftPaletteArea.has_point(ballPos) and direction.x < 0) or (rightPaletteArea.has_point(ballPos) and direction.x > 0)):
		direction.x=-direction.x
		ballSpeed*=1.1
		direction.y=randf()*2.0-1
		direction = direction.normalized()
		
	if (ballPos.x<0 or ballPos.x>screenSize.x):
		ballPos=screenSize*0.5 #ball goes to screen center
		ballSpeed=200
		direction=Vector2(-1,0)
		
	get_node("Ball").set_pos(ballPos)
	
	#move left pad  
	var leftPos = get_node("LeftPalette").get_pos()

	if (leftPos.y > 0 and Input.is_action_pressed("ui_up")):
		leftPos.y+=-PAD_SPEED*delta
		
	if (leftPos.y < screenSize.y and Input.is_action_pressed("ui_down")):
		leftPos.y+=PAD_SPEED*delta

	get_node("LeftPalette").set_pos(leftPos)

	#move right pad 
	var rightPos = get_node("RightPalette").get_pos()

	if (rightPos.y > 0 and Input.is_action_pressed("ui_left")):
		rightPos.y+=-PAD_SPEED*delta
		
	if (rightPos.y < screenSize.y and Input.is_action_pressed("ui_right")):
		rightPos.y+=PAD_SPEED*delta

	get_node("RightPalette").set_pos(rightPos)