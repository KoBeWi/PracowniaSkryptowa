let Application = PIXI.Application,
    Container = PIXI.Container,
    loader = PIXI.loader,
    resources = PIXI.loader.resources,
    TextureCache = PIXI.utils.TextureCache,
    Sprite = PIXI.Sprite

let app = new Application({
    width: 800, 
    height: 600,                       
    antialiasing: true, 
    transparent: false, 
    resolution: 1
  }
)

document.body.appendChild(app.view)

loader
  .add("data/gfx/Ball.png")
  .add("data/gfx/Paddle.png")
  .load(setup)

let ball
let leftPaddle
let rightPaddle

function setup() {
	let up = keyboard(38),
		left = keyboard(37),
		down = keyboard(40),
		W = keyboard(87),
		D = keyboard(68),
		S = keyboard(83)
	
	ball = new Sprite(resources["data/gfx/Ball.png"].texture)
	app.stage.addChild(ball)
	ball.x = 100
	ball.y = 290
	ball.vx = 0
	ball.vy = 0

	rightPaddle = new Sprite(resources["data/gfx/Paddle.png"].texture)
	app.stage.addChild(rightPaddle)
	rightPaddle.tint = 0x00FFFF
	rightPaddle.x = 720
	rightPaddle.y = 260
	rightPaddle.vy = 0

	up.press = () => {rightPaddle.vy = -4}
	up.release = () => {if (rightPaddle.vy < 0) rightPaddle.vy = 0}

	down.press = () => {rightPaddle.vy = 4}
	down.release = () => {if (rightPaddle.vy > 0) rightPaddle.vy = 0}
	
	left.press = () => {if (ball.owner == rightPaddle) {
		ball.owner = null
		ball.vx = -4
		ball.vy = rightPaddle.vy
	}}

	leftPaddle = new Sprite(resources["data/gfx/Paddle.png"].texture)
	app.stage.addChild(leftPaddle)
	leftPaddle.tint = 0xFF0000
	leftPaddle.x = 80
	leftPaddle.y = 260
	leftPaddle.vy = 0
	
	ball.owner = leftPaddle

	W.press = () => {leftPaddle.vy = -4}
	W.release = () => {if (leftPaddle.vy < 0) leftPaddle.vy = 0}

	S.press = () => {leftPaddle.vy = 4}
	S.release = () => {if (leftPaddle.vy > 0) leftPaddle.vy = 0}
	
	D.press = () => {if (ball.owner == leftPaddle) {
		ball.owner = null
		ball.vx = 4
		ball.vy = leftPaddle.vy
	}}

	app.ticker.add(delta => gameLoop(delta))
}

function gameLoop(delta){
	rightPaddle.y = Math.min(Math.max(rightPaddle.y + rightPaddle.vy, 0), 520)
	leftPaddle.y = Math.min(Math.max(leftPaddle.y + leftPaddle.vy, 0), 520)
	
	if (ball.owner) {
		ball.tint = ball.owner.tint
		ball.x = ball.owner == leftPaddle ? ball.owner.x + 20 : ball.owner.x - 20
		ball.y = ball.owner.y + 30
	} else {
		ball.x += ball.vx
		ball.y += ball.vy
	}
	
	if ((ball.vy < 0 && ball.y <= 0) || (ball.vy > 0 && ball.y >= 580)) ball.vy = -ball.vy
	
	if (ball.vx > 0 && testHit(ball, rightPaddle)) {
		ball.vx = -ball.vx
		ball.vy = ((ball.y + 10) - (rightPaddle.y + 40))/10 + rightPaddle.vy
		ball.tint = rightPaddle.tint
	}
	if (ball.vx < 0 && testHit(ball, leftPaddle)) {
		ball.vx = -ball.vx
		ball.vy = ((ball.y + 10) - (leftPaddle.y + 40))/10 + leftPaddle.vy
		ball.tint = leftPaddle.tint
	}
	
	if (ball.x < -20) {
		ball.owner = leftPaddle
	} else if (ball.x > 800) {
		ball.owner = rightPaddle
	}
}

function testHit(col1, col2) {
	return (col1.x < col2.x + col2.width && col1.x + col1.width > col2.x && col1.y < col2.y + col2.height && col1.y + col1.height > col2.y)
}

function keyboard(keyCode) {
	var key = {}
	key.code = keyCode
	key.isDown = false
	key.isUp = true
	key.press = undefined
	key.release = undefined
	
	key.downHandler = event => {
		if (event.keyCode === key.code) {
			if (key.isUp && key.press) key.press()
			key.isDown = true
			key.isUp = false
		}
		event.preventDefault()
	}

	key.upHandler = event => {
		if (event.keyCode === key.code) {
			if (key.isDown && key.release) key.release()
			key.isDown = false
			key.isUp = true
		}
		event.preventDefault()
	}

	window.addEventListener("keydown", key.downHandler.bind(key), false)
	window.addEventListener("keyup", key.upHandler.bind(key), false)
	return key
}