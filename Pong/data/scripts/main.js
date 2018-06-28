let Application = PIXI.Application, //różne moduły PIXI
    Container = PIXI.Container,
    loader = PIXI.loader,
    resources = PIXI.loader.resources,
    TextureCache = PIXI.utils.TextureCache,
    Sprite = PIXI.Sprite
    Text = PIXI.Text,
    TextStyle = PIXI.TextStyle

let app = new Application({ //obiekt aplikacji
    width: 800, 
    height: 600,                       
    antialiasing: true, 
    transparent: false, 
    resolution: 1
})

document.body.appendChild(app.view) //dodaje widok aplikacji do dokumentu

loader
  .add("data/gfx/Ball.png")
  .add("data/gfx/Paddle.png")
  .load(setup) //wczytuje zasoby i inicjalizuje

function setup() {
	let up = keyboard(38), //przypisanie różnych klawiszy
		left = keyboard(37),
		down = keyboard(40),
		W = keyboard(87),
		D = keyboard(68),
		S = keyboard(83)
	
	ball = new Sprite(resources["data/gfx/Ball.png"].texture) //obiekt piłki
	app.stage.addChild(ball) //dodaje obiekt do sceny
	ball.x = 100 //ustawienia wartości piłki
	ball.y = 290
	ball.vx = 0
	ball.vy = 0

	rightPaddle = new Sprite(resources["data/gfx/Paddle.png"].texture) //prawa palekta
	app.stage.addChild(rightPaddle)
	rightPaddle.tint = 0x00FFFF //zmiana koloru paletki
	rightPaddle.x = 720
	rightPaddle.y = 260
	rightPaddle.vy = 0

	up.press = () => {rightPaddle.vy = -4} //sterowanie paletką
	up.release = () => {if (rightPaddle.vy < 0) rightPaddle.vy = 0}

	down.press = () => {rightPaddle.vy = 4}
	down.release = () => {if (rightPaddle.vy > 0) rightPaddle.vy = 0}
	
	left.press = () => {if (ball.owner == rightPaddle) { //wypuszczanie piłki
		ball.owner = null //usuwa "właściciela" piłki
		ball.vx = -4 //ustawie prędkość początkową piłki
		ball.vy = rightPaddle.vy
	}}
	
	rightScore = new Text("0", new TextStyle({ //wynik gracza po prawej
		align: "right", //wyrównuje do prawej
		fontFamily: "sans-serif", //czcionka
		fontSize: 18, //rozmiar czcionki
		fill: "cyan", //kolor czcionki
	}))
	rightScore.position.set(780, 291) //pozycja tekstu
	app.stage.addChild(rightScore)

	leftPaddle = new Sprite(resources["data/gfx/Paddle.png"].texture) //druga paletka
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
	
	leftScore = new Text("0", new TextStyle({
		fontFamily: "sans-serif",
		fontSize: 18,
		fill: "red",
	}))
	leftScore.position.set(20, 291)
	app.stage.addChild(leftScore)

	app.ticker.add(delta => gameLoop(delta)) //ustawienie pętli gry
}

function gameLoop(delta) {
	rightPaddle.y = Math.min(Math.max(rightPaddle.y + rightPaddle.vy, 0), 520) //poruszanie paletką
	leftPaddle.y = Math.min(Math.max(leftPaddle.y + leftPaddle.vy, 0), 520)
	
	if (ball.owner) { //jeśli piłka ma właściciela
		ball.tint = ball.owner.tint //przyjmuje jego kolor
		ball.x = ball.owner == leftPaddle ? ball.owner.x + 20 : ball.owner.x - 20 //i ustawia się na odpowiedniej pozycji
		ball.y = ball.owner.y + 30
	} else {
		ball.x += ball.vx
		ball.y += ball.vy
	}
	
	if ((ball.vy < 0 && ball.y <= 0) || (ball.vy > 0 && ball.y >= 580)) ball.vy = -ball.vy //kolizje z brzegami ekranu
	
	if (ball.vx > 0 && testHit(ball, rightPaddle)) { //kolizja z prawą paletką
		ball.vx = -ball.vx //odbija prędkosć w poziomie
		ball.vy = ((ball.y + 10) - (rightPaddle.y + 40))/10 + rightPaddle.vy //ustawia pionową prędkość w zależności od tego gdzie uderzyło i jak porusza się paletka
		ball.tint = rightPaddle.tint //przyjmuje kolor paletki
	}
	if (ball.vx < 0 && testHit(ball, leftPaddle)) { //to co wyżej, ale lewa
		ball.vx = -ball.vx
		ball.vy = ((ball.y + 10) - (leftPaddle.y + 40))/10 + leftPaddle.vy
		ball.tint = leftPaddle.tint
	}
	
	if (ball.x < -20) { //jeśli piłka wileci poza ekran
		ball.owner = leftPaddle //ustawia właściciela jako gracza, któremu wpadła piłka
		rightScore.text = String(parseInt(rightScore.text)+1) //zmienia wynik przeciwnika
	} else if (ball.x > 800) { //to samo z drugiej strony
		ball.owner = rightPaddle
		leftScore.text = String(parseInt(leftScore.text)+1)
	}
}

function testHit(col1, col2) { //sprawdza, czy obiekty na siebie nachodzą
	return (col1.x < col2.x + col2.width && col1.x + col1.width > col2.x && col1.y < col2.y + col2.height && col1.y + col1.height > col2.y)
}

function keyboard(keyCode) { //kod obsługi klawiatury z programu przykładowego pixi.js
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