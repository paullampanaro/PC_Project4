import processing.serial.*;

// arduino variables
String val; // Data received from the serial port
String val2;
Serial com1;
Serial com2;
boolean firstContact = false;
boolean firstContact2 = false;
boolean collision = false;

// pong variables
float ballX = 400;
float ballY = 350;
float ballRadius = 10;
float ballSpeedX = random(3, 5);
float ballSpeedY = random(-3, 3);

// paddle variables
float paddleX = 900;
float paddleY = 350;
float paddleWidth = 10;
float paddleHeight = 50; 
float paddleSpeed = 0;
float paddleSpeedCap = 5;
float paddleSpeedFriction = 0.93;

// paddle 2 variables
float paddle2X = 100;
float paddle2Y = 350;
float paddle2Width = 10;
float paddle2Height = 50; 
float paddle2Speed = 0;
float paddle2SpeedCap = 5;
float paddle2SpeedFriction = 0.93;

// game variables
int score = 0;
int score2 = 0;

void setup()
{
  size(1000,700);
  
  com1 = new Serial(this, Serial.list()[1], 9600);
  com2 = new Serial(this, Serial.list()[2], 9600);
  
  com1.bufferUntil('\n');
  com2.bufferUntil('\n');
}


void draw()
{ 
  background(255,255,255);
  
  String s = "Score: " + score;
  fill(50);
  textSize(14);
  text(s, 25, 25);
  
  String s2 = "Score: " + score;
  fill(50);
  textSize(14);
  text(s, 800, 25);
  
  // paddleX = mouseX;
  // paddleY = mouseY;
  if(paddleSpeed > paddleSpeedCap)
  {
    paddleSpeed = paddleSpeedCap;
  }
  
  if(paddle2Speed > paddle2SpeedCap)
  {
    paddle2Speed = paddle2SpeedCap;
  }
  
  if(paddleSpeed < -paddleSpeedCap)
  {
    paddleSpeed = -paddleSpeedCap;
  }
  
  if(paddle2Speed < -paddle2SpeedCap)
  {
    paddle2Speed = -paddle2SpeedCap;
  }
  
  paddleY += paddleSpeed;
  paddleSpeed *= paddleSpeedFriction;
  
  paddle2Y += paddle2Speed;
  paddle2Speed *= paddle2SpeedFriction;
  
  if(paddleY - paddleHeight < 0)
  {
    paddleY = paddleHeight;
  }
  
  if(paddle2Y - paddle2Height < 0)
  {
    paddle2Y = paddle2Height;
  }
  
  if(paddleY + paddleHeight > height)
  {
    paddleY = height - paddleHeight;
  }
  
  if(paddle2Y + paddle2Height > height)
  {
    paddle2Y = height - paddle2Height;
  }
  
  rectMode(RADIUS);
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
  rect(paddle2X, paddle2Y, paddle2Width, paddle2Height);
  
  ellipseMode(RADIUS);
  ellipse(ballX,ballY,ballRadius,ballRadius);
  
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  if(ballX - ballRadius < 0)
  {
    score2 += 100;
    ballX = width / 2;
    ballY = height / 2;
    ballSpeedX = random(3, 5);
    ballSpeedY = random(-3, 3);
  }
  
  if(ballX + ballRadius > width)
  {
    score += 100;
    ballX = width / 2;
    ballY = height / 2;
    ballSpeedX = random(-3, -5);
    ballSpeedY = random(-3, 3);
  }
  
  if(ballY + ballRadius > height || ballY - ballRadius < 0)
  {
    ballSpeedY = -ballSpeedY;
    ballY += ballSpeedY;
    collision = true;
  }
  
  if((ballX + ballRadius > paddleX - paddleWidth) && (ballX - ballRadius < paddleX + paddleWidth) &&
    (ballY + ballRadius > paddleY - paddleHeight) && (ballY - ballRadius < paddleY + paddleHeight))
    {
      ballSpeedX = -ballSpeedX;
      ballX += ballSpeedX;
      collision = true;
      score += 100;
    }
    
  if((ballX + ballRadius > paddle2X - paddle2Width) && (ballX - ballRadius < paddle2X + paddle2Width) &&
    (ballY + ballRadius > paddle2Y - paddle2Height) && (ballY - ballRadius < paddle2Y + paddle2Height))
    {
      ballSpeedX = -ballSpeedX;
      ballX += ballSpeedX;
      collision = true;
      score += 100;
    }
}


void serialEvent(Serial port)
{
  val = port.readStringUntil('\n');
  
  if(val != null)
  {
    val = trim(val);
    println(val);
    
    if(firstContact == false || firstContact2 == false)
    {
      if(val.equals("A"))
      {
        port.clear();
        firstContact = true;
        port.write("A");
        println("contact");
      }
      if(val.equals("B"))
      {
        port.clear();
        firstContact2 = true;
        port.write("B");
        println("contact");
      }
    }
    else
    {
      println(val);
      
      if(val.equals("up"))
      {
        paddleSpeed = -5;
      }
      
      if(val.equals("down"))
      {
        paddleSpeed = 5;
      }
      
      if(val.equals("up2"))
      {
        paddle2Speed = -5;
      }
      
      if(val.equals("down2"))
      {
        paddle2Speed = 5;
      }
      
      if(collision == true)
      {
        port.write('1');
        println("1");
        collision = false;
      }
      
      // port.write("A");
    }   
  }
}

void keyPressed()
{
}