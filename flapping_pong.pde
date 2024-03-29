/********* VARIABLES *********/

// We control which screen is active by settings / updating
// gameScreen variable. We display the correct screen according
// to the value of this variable.
// 
// 0: Initial Screen
// 1: Game Screen
// 2: Game-over Screen 

int gameScreen = 0;

// gameplay settings
float gravity = .3;
float airfriction = 0.00001;
float friction = 0.1;
boolean goEast = true;

// ball settings
float ballX, ballY;
float ballSpeed = 4;
float ballYSpeed = 0;
float ballSize = 20;
color ballColor = color(0);

// padels settings
float padelLeftX = 0;
float padelLeftY = 600/2 - 75;
float padelLeftHeight = 150;

float padelRightX = 1000-10;
float padelRightY = 600/2 - 75;
float padelRightHeight = 150;

// pipes settings
float pipeX;
float pipeCenter = 300;
float pipeHeight = 200;


// scoring
int score = 0;
int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;

PImage photo;

PImage photo1;


/********* SETUP BLOCK *********/

void setup() {
  size(1000, 600);
  ballX=width/2;
  ballY=height/2;
  smooth();
  photo = loadImage("game.jpg");
  photo.resize(1000,600);

  photo1 = loadImage("home.jpg");
  photo1.resize(1000,600);

}

/********* DRAW BLOCK *********/

void draw() {
  // Display the contents of the current screen

  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
    applyGravity();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

/********* INPUTS *********/

public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    startGame();
  }

  if(gameScreen == 1) {
    ballYSpeed = -8;
  }

  if (gameScreen==2) {
    restart();
  }
}

/********* SCREEN CONTENTS *********/

void initScreen() {
  background(236, 240, 241);
  image(photo1, 0, 0);
  textAlign(CENTER);
  fill(255);
  textSize(70);
  text("Click to start", width/2, height-30);
}
void gameScreen() {
  background(236, 240, 241);
  image(photo, 0, 0);
  drawBall();
  drawLeftPadel();
  drawRightPadel();
  drawBottomPipe();
  drawTopPipe();

  touchRightWall();
  touchLeftWall();
  touchBottom();
  touchSky();

  touchLeftPadel();
  touchRightPadel();

  touchBottomPipe();
  touchTopPipe();

  if(goEast)
  {
     goRight();
  }
  else
  {
    goLeft();
  }

  // Display the score during the game
  textAlign(LEFT);
  fill(52, 73, 94);
  textSize(20);
  text("Score: " + score/5, 20, 30);
}
void gameOverScreen() {
  background(44, 62, 80);
  textAlign(CENTER);
  fill(236, 240, 241);
  textSize(12);
  text("Your Score", width/2, height/2 - 120);
  textSize(130);
  text(score/5, width/2, height/2);
  textSize(15);
  text("Click to Restart", width/2, height-30);
}

/********* MOVEMENT *********/
void goLeft() {
   ballX -= ballSpeed;
}

void goRight() {
   ballX += ballSpeed;
}

void applyGravity() {
  ballYSpeed += gravity;
  ballY += ballYSpeed;
}
/********* OTHER FUNCTIONS *********/

// This method sets the necessery variables to start the game
void startGame() {
  gameScreen=1;
}
void gameOver() {
  gameScreen=2;
  ballYSpeed = 0; // reset vertical speed on game over

}

void restart() {
  score = 0;
  health = maxHealth;
  ballX=width/4;
  ballY=height/2;
  gameScreen = 1;
}

void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void drawLeftPadel(){
  fill(ballColor);
  rect(padelLeftX, padelLeftY, 10, padelLeftHeight);
}


void drawRightPadel(){
  fill(ballColor);
  rect(padelRightX, padelRightY, 10, padelRightHeight);
}

void drawBottomPipe() {
  fill(0, 255, 0);
  rect(500 - 75, pipeCenter + pipeHeight / 2, 150 , pipeCenter + pipeHeight / 2);
  rect(500 - 90, pipeCenter + pipeHeight / 2, 180 , 25);
}


void drawTopPipe() {
  fill(0, 255, 0);
  rect(500 - 75, 0, 150 , pipeCenter - pipeHeight / 2);
  rect(500 - 90, pipeCenter - pipeHeight / 2, 180 ,25);
}

void updatePipePosition() {
  pipeCenter += random(-25, 25);

  // Ensure the pipes stay within the screen bounds
  pipeCenter = constrain(pipeCenter, pipeHeight / 2, height - pipeHeight / 2);
}

/********* COLLISIONS *********/

void touchRightWall(){
  if (ballX + ballSize/2 > width) {
    gameOver();
  }
}

void touchLeftWall(){
  if (ballX - ballSize/2 < 0) {
    gameOver();
  }
}

void touchBottom(){
  if (ballY + ballSize/2 > height) {
    gameOver();
    ballY = height - ballSize / 2; // ensure the ball doesn't go below the floor
  }
}

void touchSky() {
  if (ballY - ballSize/2 < 0 &&
      ballX + ballSize / 2 > 500 - 90 && ballX - ballSize / 2 < 500 + 90
  ) {
    gameOver();
  }

    if (ballX > 500 && ballX < 500 + ballSize && gameScreen == 1) {
    score++;
  }
}

void touchLeftPadel() {
  if (ballX - ballSize/2 < padelLeftX + 10 &&
      ballY > padelLeftY &&
      ballY < padelLeftY + padelLeftHeight) {
    goEast = true;
    goRight();
    updatePipePosition();
    int randomDirection = int(random(2)); // 0 for up, 1 for down
    if (randomDirection == 0 && padelLeftY > 0) {
      padelLeftY -= 60;
    } else if (randomDirection == 1 && padelLeftY + padelLeftHeight < height) {
      padelLeftY += 60;
    }  }
  }

void touchRightPadel() {
  if (ballX + ballSize/2 > padelRightX &&
      ballY > padelRightY &&
      ballY < padelRightY + padelRightHeight) {
    goEast = false;
    goLeft();
    updatePipePosition();


    int randomDirection = int(random(2)); // 0 for up, 1 for down
    if (randomDirection == 0 && padelRightY > 0) {
      padelRightY -= 60;
    } else if (randomDirection == 1 && padelRightY + padelRightHeight < height) {
      padelRightY += 60;
    }
  }
}

void touchBottomPipe() {
  if (ballX + ballSize / 2 > 500 - 90 && ballX - ballSize / 2 < 500 + 90 &&
      ballY + ballSize / 2 > pipeCenter + pipeHeight / 2) {
    gameOver();
  }
}

void touchTopPipe() {
  if (ballX + ballSize / 2 > 500 - 90 && ballX - ballSize / 2 < 500 + 90 &&
      ballY - ballSize / 2 < pipeCenter - pipeHeight / 2) {
    gameOver();
    ballY = pipeCenter - pipeHeight / 2 + ballSize / 2; // adjust ball position on collision
  }
}