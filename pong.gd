extends Node2D

var screenSize
var padSize
var ballPos
var ballSpeedInPixelsPerSecond = 300
var ballDirection = Vector2(-1,0)
const PADDLE_SPEED_IN_PIXELS_PER_SECOND = 250

func _ready():
	screenSize = get_viewport_rect().size
	getPadSizeFromPaddleTextureSize()
	putBallInScreenCenter()
	set_process(true)

func _process(delta):
	updateBallPosition(delta)	
	drawSprites(delta)

func getPadSizeFromPaddleTextureSize():
	padSize = get_node("LeftPaddle").get_texture().get_size()

func updateBallPosition(delta):
	ballPos = get_node("Ball").get_pos()
	ballPos+=ballDirection*ballSpeedInPixelsPerSecond*delta

func drawSprites(delta):
	get_node("Ball").set_pos(ballPos)
	movePaddle("LeftPaddle", delta)
	movePaddle("RightPaddle", delta)

func resolveCollisions():
	resolveCollisionUpDown()
	resolveCollisionPlayer()
	resolveCollisionScoring()

func resolveCollisionUpDown():
	if ( (ballPos.y<0 and ballDirection.y <0) or (ballPos.y>screenSize.y and ballDirection.y>0)):
    	ballDirection.y = -ballDirection.y

func resolveCollisionPlayer():
	var leftPaddleArea = Rect2( get_node("LeftPaddle").get_pos() - padSize/2, padSize )
	var rightPaddleArea = Rect2( get_node("RightPaddle").get_pos() - padSize/2, padSize )
	if ( (leftPaddleArea.has_point(ballPos) and ballDirection.x < 0) or (rightPaddleArea.has_point(ballPos) and ballDirection.x > 0)):
		ballDirection.x=-ballDirection.x
		ballSpeedInPixelsPerSecond*=1.1
		ballDirection.y=randf()*2.0-1
		ballDirection = ballDirection.normalized()

func resolveCollisionScoring():
	if (ballPos.x<0 or ballPos.x>screenSize.x):
		putBallInScreenCenter()

func updatePaddles(delta):
	updatePaddle("LeftPaddle", delta)
	updatePaddle("RightPaddle", delta)

func updatePaddle(paddleName, delta):
	var pos = get_node(paddleName).get_pos()

	if (pos.y > 0 and Input.is_action_pressed(paddleName + "Up")):
		pos.y+=-PADDLE_SPEED_IN_PIXELS_PER_SECOND*delta

	if (pos.y < screenSize.y and Input.is_action_pressed(paddleName + "Down")):
		pos.y+=PADDLE_SPEED_IN_PIXELS_PER_SECOND*delta

	return pos

func drawPaddle(paddleName, delta):
	get_node(paddleName).set_pos(pos)

func putBallInScreenCenter():
	ballPos=screenSize*0.5
	ballSpeedInPixelsPerSecond=300
	ballDirection=Vector2(-1,0)