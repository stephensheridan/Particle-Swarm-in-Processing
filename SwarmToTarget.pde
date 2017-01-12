//////////////////////////////////////////////////////////////////////////////////////////
// Particle Swarm Optimisation (PSO) using Eberhart and Kennedy's velocity update equation
// Author: Stephen Sheridan
//////////////////////////////////////////////////////////////////////////////////////////

// Global Constants
final int NUM_BOIDS = 40; // Size of the swarm
final int MAX_FITNESS = 1000; // Start the fitness off really high
final int MAX_VELOCITY = 250; // To the particles from flying to fast

// Global Variables
Particle[] p; // Array of Particle objects
int TARGETX = 0; // Will se the initial target pos to the middle 
int TARGETY = 0; // of the screen in the setup func
float gBest;  // Global best
int gBestIndex; // Index of global best

void setup(){
  // Window size
  size(640, 480);
  TARGETX = width/2;
  TARGETY = height/2;
  // Initialise the swarm
  init();
}

void draw(){
  // Clear and set the background to black
  background(0);
  text("Particle Swarm - Using Eberhart and Kennedy's Equation. Click the mouse to change the target position.", 20, 450);
    
  // Check to see of the mouse has been pressed
  // and reset the TARGET position and global best
  if (mousePressed) {
    TARGETX = mouseX;
    TARGETY = mouseY;
    gBest = MAX_FITNESS;
  }
  
  // Uupdate the swarm based on the
  // TARGET position
  updateSwarm();
  
  // Draw the TARGET
  fill(color(204, 102, 0));
  rect(TARGETX - 25, TARGETY - 25, 50, 50);
  
  // Draw the swarm
  fill(255);
  for(int i = 0; i < NUM_BOIDS; i++){
    rect((int)p[i].x, (int)p[i].y, 5, 5);
  }
}

void init(){
    p = new Particle[NUM_BOIDS];
    gBest = MAX_FITNESS;
    
    for(int i = 0; i <NUM_BOIDS; i++){
      p[i] = new Particle();
      p[i].initialise((int)(Math.random() * (width * 0.25)), (int)(Math.random() * (height * 0.25)));
    }
}

void updateSwarm(){
  // Calculate fitness for swarm
  for(int i = 0; i< NUM_BOIDS; i++){
    p[i].calcFitness(TARGETX, TARGETY);
  }
  // Store gBest
  for(int i = 0; i < NUM_BOIDS; i++){
    if (p[i].pBest < gBest){
      gBest = p[i].pBest;
      gBestIndex = i;
    }
  }
  // Update velocity
  for(int i = 0; i < NUM_BOIDS; i++){
    if (i != gBestIndex)
      p[i].update(p[gBestIndex]);
  }
}

class Particle{
  float x,y;                   // current x,y pos
  float pBestX, pBestY;        // best x and y pos 
  float velocityX, velocityY;  // current velocity change to x and y
  float pBest;                 // pBest fitness value
  float fitness;               // current fitness value
  int tx, ty;                  // target x and y pos
  int MAX_FITNESS = 1000;
  
  Particle(){
  }
  
  public void initialise(int mx, int my){
    pBest = MAX_FITNESS; 
    fitness = MAX_FITNESS;
    velocityX = (float)(Math.random());
    velocityY = (float)(Math.random());
    x = (float)(mx+velocityX);
    y = (float)(my+velocityY);
  }
  
  public void calcFitness(int tx, int ty){
    
    // Standard distance equation between two points
    float xcomp = (x - tx) * (x - tx);
    float ycomp = (y - ty) * (y - ty);
    fitness = (float) Math.sqrt(xcomp + ycomp); 
    
    // Check fitness value against pBest value
    if (this.tx == tx && this.ty == ty){
      // Target is same as before
      if (fitness < pBest){
        pBest = fitness;
        pBestX = x;
        pBestY = y;
      }
    }
    else{
      // Target has changed
      this.tx = tx;
      this.ty = ty;
      pBest = fitness;
    }
  }
  
  public void update(Particle gBest){
    
    // Constants 
    int c1 = 2;
    int c2 = 2;
    
    
    // Implement Eberhart and Kennedy standard velocity change equation
    
    // Calculate new velocity change for X
    velocityX = (float) (velocityX + (c1 * Math.random() * (pBestX - x)) + 
            (c2 * Math.random() * (gBest.x - pBestX)));
    
    // Calculate new velocity change for y
    velocityY = (float) (velocityY + (c1 * Math.random() * (pBestY - y)) + 
            (c2 * Math.random() * (gBest.y - pBestY)));
        
    // Rather then checking the bounds
    // we can implement a MAX velocity
    // particles will go off screen but 
    // will be brought back to the target 
    // by the PSO algorithm
    
    if (velocityX >= MAX_VELOCITY)
      velocityX =+ -1;
    if (velocityY >= MAX_VELOCITY)
      velocityY =+ -1;
    
    // Change x and y pos based on velocity
    // Scale change to fit our work of 640 X 480
    x = x + (velocityX * 0.02f);
    y = y + (velocityY * 0.02f);
  }
  
}