  var canvasWidth = 300;
  var canvasHeight = 500;
  var black = new Color(0,0,0);
  var white = new Color(255, 255, 255);
  var red = new Color(255, 0, 0);
  var paddle = new Paddle(white);
  var ball = new Ball(red);
  
  int scoreCount = 0;
  int lives = 4;
  boolean inPlay = false;
  
  //Arraylist of bricks
  ArrayList bricks = new ArrayList();
  int numBricks = 5;
  int brickXVAL = 0;
  int brickYVAL = 50;
  int levelDistance = 70;
  int brickHeight = 30;
  int numLevels=2;
  int ballSpeedPlus = 0.1;
  
  int rangeHit = 5;
  int gameCount = 0;
  
  boolean reachTen = false;
  void setup() {
    size(300, 500);
    noStroke();
    fillBricks();
    alert("Click to begin. Press any key to use a life");
  };
  
  void fillBricks() {
    //making brick array
    brickYVAL = 50;
    brickXVAL = 0;
    
    for (int p=0; p<numLevels; p++){
      for (int i = 0; i<numBricks; i++){
        bricks.add(new Brick(brickXVAL, brickYVAL, canvasWidth/numBricks, brickHeight));
        brickXVAL += bricks.get(i).brickW;
      }
      brickXVAL = 0;
      brickYVAL += levelDistance;
    }
  }
  void draw() {
    background(black.red, black.green, black.blue);
    for (int i = 0; i < lives; i++) {
      fill(255, 0, 0);
      ellipse(275 - i * 27, 480, 25, 25);
    }
    paddle.drawPaddle();
    if (keyPressed && lives > 0 && !inPlay){
      inPlay = true;
      ball.x = 150;
      ball.y = 440;
      ball.dx = 3;
      ball.dy = -3;
      lives--;
      gameCount = 0;
    }
    gameCount++;
    if (inPlay){
      ball.drawBall();
      ball.move();
    }
    //drawing bricks
    for (int i = 0; i<bricks.size(); i++){
      if (bricks.get(i).checkTouch(ball)){
          bricks.remove(i);
      }
      else{
      bricks.get(i).drawBrick();
      }
    }
    
    if (ball.y>500){
      inPlay = false;
    }
    fill(255);
    text("Score: " + scoreCount, 10, 490);
    if (gameCount % 75 == 0){
      if (ball.dx > 0){
        ball.dx += ballSpeedPlus;
      }
      else{
        ball.dx -= ballSpeedPlus;
      }
      if (ball.dy > 0){
        ball.dy += ballSpeedPlus;
      }
      else{
        ball.dy -= ballSpeedPlus;
      }
    }
    
    /*if (scoreCount % 10 == 0 && scoreCount!=0 && !reachTen){
      reachTen = true;
      for (int j = 0; j < 10; j++) {
          bricks.add(new Brick(random(0, 300 - canvasWidth/numBricks), random(0, 405), canvasWidth/numBricks, brickHeight));
      }
    }
    else if (! scoreCount%10 ==0){
      reachTen = false;
    }*/
    if (bricks.size() == 0) {
      fillBricks();
    }
  }
  class Color {
    int red;
    int green;
    int blue;
    Color(int r, int g, int b) {
      red = r;
      green = g;
      blue = b;
    }
    void setColor() {
      fill(red, green, blue);
    }
  }
  class Ball {
    var diameter = 25;
    var x = 150;
    var y = 440;
    var dx = 3;
    var dy = -3;
    Color col;
    Ball(Color c) {
      col = c;
    }
    var drawBall() {
      col.setColor();
      ellipse(x + diameter/2, y + diameter/2, diameter, diameter);
    }
    void move() {
      // update the ball's location
      x += dx;
      y += dy;
      // if it just hit the top of the canvas, bounce in the y direction
      if (y <= 0) {
        dy = -dy;
      } else if (inPaddleRange(paddle)) { // if it hit the paddle, go up
        dy = -abs(dy);
      } else if (x + diameter >= canvasWidth || x <= 0) { // if it hit a side, bounce x
        dx = -dx;
      }
    }
    boolean inPaddleRange(Paddle paddle) {
      return (y + diameter >= paddle.y) && (y < paddle.y)
        && (x + diameter >= paddle.x) && (x <= paddle.x + paddle.width);
    }
  }
  class Paddle {
    var y = 445;
    var width = 50;
    var height = 20;
    var x = 0;
    var c;
    Paddle(Color col) {
      c = col;
    }
    void drawPaddle() {
      x = mouseX - width/2;
      if (x + width > canvasWidth) {
        x = canvasWidth - width;
      }
      if (x < 0) {
        x = 0;
      }
      c.setColor();
      rect(x, y, width, height);
    }
  }
  
  class Brick{
    int brickW;
    int brickH;
    int brickX;
    int brickY;
    
    Brick(int x, int y, int w, int h){
      brickW = w;
      brickH = h;
      brickX = x;
      brickY = y;
    }
    
    boolean checkTouch(Ball b){
      
      //top of ball touching bottom of brick
      if ((abs((b.y-b.diameter/2) - (brickY + brickH)) <= rangeHit)&& ((brickX<= b.x) && (b.x<= brickX+brickW))){
        b.dy = -(b.dy);
        scoreCount++;
        return true;
      }
      //bottom of ball touching top of brick
      else if ((abs((b.y+b.diameter/2) - (brickY)) <= rangeHit)&& ((brickX<= b.x) && (b.x<= brickX+brickW))){
        b.dy = -abs(b.dy);
        scoreCount++;
        return true;
      }
      //left touching touching right of brick
      else if ((abs((b.x-b.diameter/2) - (brickX+brickW)) <= rangeHit)&& ((brickY>= b.y) && (b.y<= brickY+brickH))){
        b.dx = -(b.dx);
        scoreCount++;
        return true;
      }
      else if ((abs((b.x+b.diameter/2) - (brickX)) <= rangeHit)&& ((brickY>= b.y) && (b.y<= brickY+brickH))){
        b.dx = -(b.dx);
        scoreCount++;
        return true;
      }
      else{
        return false;
      }
    }
    
    void drawBrick(){
      fill (160, 160, 160);
      stroke();
      fill(232, 115, 72);
      rect(brickX, brickY, brickW, brickH);
      noStroke();
    }
  }


