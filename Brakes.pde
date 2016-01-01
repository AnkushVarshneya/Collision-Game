//building variables
int xBuildingGap, WindowGap, WindowsDimention, DoorHeight, DoorWidth;
float Angle;

//road variables
int RoadLaneSize, RoadLane1X, RoadLane1Y, RoadLane2X, RoadLane2Y;

//Vehicles
Vehicle FrontVehicle, BackVehicle;

//pedestrian
Person pedestrian;

class Vehicle 
{
  int x, y, direction, TheWidth;
  float speed, acceleration;
  boolean Type; //True = Car, False = Truck
  color Color1, Color2;
  int StopX; //decelerating distance
  float OriginalSpeed;

  Vehicle (int pX, int pY, int pDirection, float pSpeed, boolean pType, int pColor1, int pColor2) 
  {
    acceleration = 0; //initially 0
    x = pX;
    y = pY;
    direction = pDirection;
    speed = pSpeed; // speed will be from 3 to 8
    OriginalSpeed = speed; //this will help the vehicle get make to its original speed after its changed speed.
    //colors the car a random color
    Type = pType; // true = car, false = truck
    Color1 = pColor1; 
    Color2 = pColor2;
  }
}

class Person
{
  int x;
  int y;
}


void setup()
{
  size(1024, 600);

  xBuildingGap=35;
  WindowGap=5;
  WindowsDimention=15;
  DoorHeight = 30;
  DoorWidth = 15;
  Angle = PI/4;
  RoadLaneSize = 75;
  RoadLane1X = 0;
  RoadLane1Y = 300 + 40;
  RoadLane2X = 0;
  RoadLane2Y = RoadLane1Y + RoadLaneSize + 10;

  BackVehicle = new Vehicle(width, RoadLane1Y + RoadLaneSize - 10, -1, 
  (int)(random(6)+3), // random speed from 3 to 8.
  (((int)(random(2)+1))==2)? true:false, //random number (1 or 2) is generated. 2=true=car, 1=false=truck, 
  color ((int) random(150), (int) random(150), (int) random(150)), //random color1
  color ((int) random(150), (int) random(150), (int) random(150)));//random color1

  FrontVehicle = new Vehicle(0, RoadLane2Y + RoadLaneSize - 10, 1, 
  (int)(random(6)+3), // random speed from 3 to 8.
  (((int)(random(2)+1))==2)? true:false, //random number (1 or 2) is generated. 2=true=car, 1=false=truck, 
  color ((int) random(150), (int) random(150), (int) random(150)), //random color1
  color ((int) random(150), (int) random(150), (int) random(150)));//random color1

  pedestrian = new Person();
}

void draw()
{
  background(135, 206, 250);
  MakeSideWalk();
  MakeRoad();
  MakeGrass(); 

  int xOffSet =  0; 

  //drawBuilding(current xOffSet, place to start drawing the building, Number Of Floors, Number Of Rooms Per Floor)
  //the xOffSet is increased every time so the buldings dont overlap.

  stroke (0);//makes black outlines around everything black
  //draws buildings
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 7, 4, 100, 10, 10);// Building #1.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 10, 3, 100, 100, 100);// Building #2.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 4, 2, 255, 0, 136);// Building #3.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 7, 2, 200, 0, 0);// Building #4.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 3, 4, 0, 200, 0);// Building #5.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 5, 2, 0, 0, 150);// Building #6.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 3, 2, 255, 200, 0);// Building #7.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 9, 4, 100, 100, 0);// Building #8.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 8, 3, 0, 100, 200);// Building #9.
  xOffSet = xOffSet + xBuildingGap + drawBuilding(xOffSet, height/2, 3, 6, 0, 100, 200);// Building #10.

  if (PersonOnRoad())
  {
    //this will draw pedestrian at the location of the mouse pointer
    pedestrian.x = mouseX;
    pedestrian.y = mouseY;
    drawPerson(pedestrian);

    // Repeatedly draw and move each Vehicle
    ChooseVehicle (BackVehicle);
    ChooseVehicle (FrontVehicle);
    BackLaneTrafic(BackVehicle);
    FrontLaneTrafic(FrontVehicle);
  }
  else
  {    
    // Repeatedly draw and move each Vehicle
    ChooseVehicle (BackVehicle);
    ChooseVehicle (FrontVehicle);
    BackLaneTrafic(BackVehicle);
    FrontLaneTrafic(FrontVehicle);

    //this will draw pedestrian at the location of the mouse pointer
    pedestrian.x = mouseX;
    pedestrian.y = mouseY;
    drawPerson(pedestrian);
  }
}

void BackLaneTrafic(Vehicle aVehicle)
{
  aVehicle.StopX = aVehicle.x + (aVehicle.TheWidth + 50)*aVehicle.direction;

  if ( (aVehicle.StopX - pedestrian.x) < 400)
  {
    if ( (pedestrian.y > RoadLane1Y) && (pedestrian.y < (RoadLane1Y + RoadLaneSize)) && ((aVehicle.StopX - pedestrian.x) > 0) ) 
    {
      aVehicle.acceleration = 10*aVehicle.speed*aVehicle.direction / (aVehicle.StopX - pedestrian.x);
    }
    else
    {
      aVehicle.acceleration = 0;
      aVehicle.speed = aVehicle.OriginalSpeed; // it the vehicle is out of the way make the speed back to normal
    }
  }
  moveVehicle(aVehicle);
}

void FrontLaneTrafic(Vehicle aVehicle)
{
  aVehicle.StopX = aVehicle.x + (aVehicle.TheWidth + 50)*aVehicle.direction;

  if ( (pedestrian.x - aVehicle.StopX) < 400)
  {
    if ( (pedestrian.y > RoadLane2Y) && (pedestrian.y < (RoadLane2Y + RoadLaneSize)) && ((pedestrian.x - aVehicle.StopX) > 0) ) 
    {
      aVehicle.acceleration = -10*aVehicle.speed*aVehicle.direction / (pedestrian.x - aVehicle.StopX);
    }
    else
    {
      aVehicle.acceleration = 0;
      aVehicle.speed = aVehicle.OriginalSpeed; // it the vehicle is out of the way make the speed back to normal
    }
  }
  moveVehicle(aVehicle);
}

boolean PersonOnRoad()
{
  boolean ReturnValue = false;
  if ( (pedestrian.y > RoadLane1Y) && (pedestrian.y < (RoadLane1Y + RoadLaneSize)) ) 
  {
    ReturnValue = true;
    //print("lane 1");
  }
  else
  {
    if ( (pedestrian.y > RoadLane2Y) && (pedestrian.y < (RoadLane2Y + RoadLaneSize)) )
    {
      ReturnValue = true;
      //print("lane 2");
    }
  }
  return ReturnValue;
}

// Draw a person at the given location
void drawPerson(Person aPerson) 
{
  // Draw shirt/pants 
  fill(0, 255, 30);
  rect(aPerson.x-5, aPerson.y-27, 10, 15); 


  // Draw legs and arms and head
  fill(216, 207, 162);
  rect(aPerson.x-5, aPerson.y-12, 3, 12);
  rect(aPerson.x+2, aPerson.y-12, 3, 12);
  rect(aPerson.x-8, aPerson.y-25, 3, 10); 
  rect(aPerson.x+5, aPerson.y-25, 3, 10); 
  ellipse(aPerson.x, aPerson.y-32, 8, 10);
}

void ChooseVehicle(Vehicle aVehicle)
{
  if (aVehicle.Type)// true = car
  {
    drawCar (aVehicle);
    aVehicle.TheWidth = 100; // width for a car
  }
  else // false = truck
  {
    drawTruck (aVehicle);
    aVehicle.TheWidth = 230; // width for a truck
  }
}

//moves the vehicle
void  moveVehicle (Vehicle aVehicle)
{  
  if ((aVehicle.direction<0)&&((aVehicle.x + (aVehicle.TheWidth*aVehicle.direction))<0))
  {
    BackVehicle = new Vehicle(width, RoadLane1Y + RoadLaneSize - 10, -1, 
    (int)(random(6)+3), // random speed from 3 to 8.
    (((int)(random(2)+1))==2)? true:false, //random number (1 or 2) is generated. 2=true=car, 1=false=truck, 
    color ((int) random(150), (int) random(150), (int) random(150)), //random color1
    color ((int) random(150), (int) random(150), (int) random(150)));//random color1
  }
  else 
  {
    if ((aVehicle.direction>0)&&((aVehicle.x + (aVehicle.TheWidth*aVehicle.direction))>width))
    {
      FrontVehicle = new Vehicle(0, RoadLane2Y + RoadLaneSize - 10, 1, 
      (int)(random(6)+3), // random speed from 3 to 8.
      (((int)(random(2)+1))==2)? true:false, //random number (1 or 2) is generated. 2=true=car, 1=false=truck, 
      color ((int) random(150), (int) random(150), (int) random(150)), //random color1
      color ((int) random(150), (int) random(150), (int) random(150)));//random color1
    }
    else
    {
      aVehicle.speed = aVehicle.speed + aVehicle.acceleration;
      aVehicle.x = (int) (aVehicle.x + aVehicle.speed*aVehicle.direction);
    }
  }
}

// Draw the car that is passed in as a parameter
void drawCar(Vehicle aCar) 
{ 
  fill(aCar.Color1);

  rect(aCar.x, aCar.y - 30, (aCar.direction * 100), 20);

  quad(aCar.x + (aCar.direction * 20), aCar.y - 30, 
  aCar.x + (aCar.direction * 30), aCar.y - 45, 
  aCar.x + (aCar.direction * 55), aCar.y - 45, 
  aCar.x + (aCar.direction * 70), aCar.y - 30);

  fill(0, 0, 0); // black  
  ellipse(aCar.x + (aCar.direction * 20), aCar.y - 10, 20, 20);
  ellipse(aCar.x + (aCar.direction * 75), aCar.y - 10, 20, 20);

  fill(255, 255, 255); // white
  ellipse(aCar.x + (aCar.direction * 20), aCar.y - 10, 10, 10);
  ellipse(aCar.x + (aCar.direction * 75), aCar.y - 10, 10, 10);
}

// Draw a Truck that is passed in as a parameter
void drawTruck(Vehicle aTruck) {
  // Draw trailor
  noStroke();
  fill(aTruck.Color1);
  rect(aTruck.x, aTruck.y - 55, (aTruck.direction * 170), 45); 

  // Draw tractor part
  fill(aTruck.Color2);
  quad(aTruck.x + (aTruck.direction * 175), aTruck.y - 55, 
  aTruck.x + (aTruck.direction * 205), aTruck.y - 55, 
  aTruck.x + (aTruck.direction * 215), aTruck.y - 37, 
  aTruck.x + (aTruck.direction * 175), aTruck.y - 37); 
  rect(aTruck.x + (aTruck.direction * 175), aTruck.y - 37, (aTruck.direction * 55), 23); 
  rect(aTruck.x + (aTruck.direction * 128), aTruck.y - 18, (aTruck.direction * 102), 8); 

  //Draw black borders
  stroke(0);
  line(aTruck.x, aTruck.y - 55, aTruck.x + (aTruck.direction * 170), aTruck.y - 55);
  line(aTruck.x + (aTruck.direction * 170), aTruck.y - 55, aTruck.x + (aTruck.direction * 170), aTruck.y - 55 + 37);
  line(aTruck.x + (aTruck.direction * 170), aTruck.y - 18, aTruck.x + (aTruck.direction * 128), aTruck.y - 18);
  line(aTruck.x + (aTruck.direction * 128), aTruck.y - 18, aTruck.x + (aTruck.direction * 128), aTruck.y - 10);
  line(aTruck.x + (aTruck.direction * 128), aTruck.y - 10, aTruck.x, aTruck.y - 10);
  line(aTruck.x, aTruck.y - 10, aTruck.x, aTruck.y - 55);
  line(aTruck.x + (aTruck.direction * 175), aTruck.y - 55, aTruck.x + (aTruck.direction * 205), aTruck.y - 55);
  line(aTruck.x + (aTruck.direction * 205), aTruck.y - 55, aTruck.x + (aTruck.direction * 215), aTruck.y - 37);
  line(aTruck.x + (aTruck.direction * 215), aTruck.y - 37, aTruck.x + (aTruck.direction * 230), aTruck.y - 37);
  line(aTruck.x + (aTruck.direction * 230), aTruck.y - 37, aTruck.x + (aTruck.direction * 230), aTruck.y - 11);
  line(aTruck.x + (aTruck.direction * 230), aTruck.y - 11, aTruck.x + (aTruck.direction * 128), aTruck.y - 11);
  line(aTruck.x + (aTruck.direction * 175), aTruck.y - 55, aTruck.x + (aTruck.direction * 175), aTruck.y - 18);
  line(aTruck.x + (aTruck.direction * 175), aTruck.y - 18, aTruck.x + (aTruck.direction * 170), aTruck.y - 18);

  // Draw the wheels
  fill(0);
  ellipse(aTruck.x + (aTruck.direction * 20), aTruck.y-10, (aTruck.direction * 20), 20);
  ellipse(aTruck.x + (aTruck.direction * 42), aTruck.y-10, (aTruck.direction * 20), 20);
  ellipse(aTruck.x + (aTruck.direction * 138), aTruck.y-10, (aTruck.direction * 20), 20);
  ellipse(aTruck.x + (aTruck.direction * 160), aTruck.y-10, (aTruck.direction * 20), 20);
  ellipse(aTruck.x + (aTruck.direction * 215), aTruck.y-10, (aTruck.direction * 20), 20);
  fill(255);
  ellipse(aTruck.x + (aTruck.direction * 20), aTruck.y-10, (aTruck.direction * 10), 10);
  ellipse(aTruck.x + (aTruck.direction * 42), aTruck.y-10, (aTruck.direction * 10), 10);
  ellipse(aTruck.x + (aTruck.direction * 138), aTruck.y-10, (aTruck.direction * 10), 10);
  ellipse(aTruck.x + (aTruck.direction * 160), aTruck.y-10, (aTruck.direction * 10), 10);
  ellipse(aTruck.x + (aTruck.direction * 215), aTruck.y-10, (aTruck.direction * 10), 10);
}

void MakeSideWalk()
{
  fill(220);//light grey
  rect(0, (height/2) - 50, width, 80);
  fill(180);//grey
  rect(0, (height/2) + 30, width, 10);
}

void MakeRoad()
{
  fill(100);//dark grey
  rect(RoadLane1X, RoadLane1Y, width, RoadLaneSize);
  rect(RoadLane2X, RoadLane2Y, width, RoadLaneSize);
  fill(255, 255, 0);//yellow
  rect(0, RoadLane2Y - 10, width, 10);
}

void MakeGrass()
{
  fill(0, 100, 0);//green
  rect(0, RoadLane2Y + RoadLaneSize, width, 100);
}

int drawBuilding(int xPosition, int yPosition, int NumberOfFloors, int NumberOfRoomsPerFloor, int cRed, int cGreen, int cBlue)
{ 
  fill (cRed, cGreen, cBlue); //paint the building some inputed color.

  int BuildingWidth = (NumberOfRoomsPerFloor * WindowsDimention) + ((NumberOfRoomsPerFloor + 1) * WindowGap);
  // this includes the width of all the windows and the gap to the right and left of each window.

  int BuildingHeight = ((NumberOfFloors -1) * WindowsDimention) + (NumberOfFloors * WindowGap) + DoorHeight;
  // this includes the height off all the windows, the gap above and below each windows and the door.

  yPosition = yPosition -  BuildingHeight;  
  // the y axis starts at the top not the bottom, so we can to subtract Building hight from 
  // yPosition so yPosition can be used to draw buildings upright, rather than upside down.

  rect (xPosition, yPosition, BuildingWidth, BuildingHeight);
  //Draws the actual building

  drawWindows(NumberOfFloors - 1, NumberOfRoomsPerFloor, xPosition, yPosition);
  //the amount of windows draws will be (NumberOfFloors - 1 * NumberOfRoomsPerFloor) this 
  //allows every room above floor one to have its own windows.  x & y position of the buildings 
  //are passed so the windows can bew drawn with reference to the position of the building

  drawDoor(xPosition, BuildingWidth, height/2);

  drawRoof(xPosition, yPosition, BuildingWidth, cRed + 75, cGreen + 75, cBlue + 75);
  //We sent the X & Y position to make a reference point for the roof. we sent the width to make 
  //the roof width X width large, and we sent a lighter version of the color to the roof function 

  drawSideWall(xPosition + BuildingWidth, yPosition, BuildingWidth, BuildingHeight, cRed - 75, cGreen - 75, cBlue - 75);
  //We sent the X Position+ building width & Y position to make a reference point for the side wall. 
  //we sent building width & height to make a side wall  width X height Big.
  //and we sent a darker version of the color to the sideWall function 

  drawSideWindows(NumberOfFloors - 1, NumberOfRoomsPerFloor, xPosition + BuildingWidth, yPosition);
  //the amount of windows draws will be (NumberOfFloors - 1 * NumberOfRoomsPerFloor) this 
  //allows every room above floor one to have its own windows.  x & y position of the buildings 
  //are passed so the windows can bew drawn with reference to the position of the building

  return BuildingWidth;
}

void drawWindows(int WindowsRow, int WindowsColoumn, int X, int Y)
{
  fill (255); //makes white windows.

  int WindowXPosition = X + WindowGap;
  int WindowYPosition = Y + WindowGap;

  for (int i=0; i<WindowsColoumn; i++)
  {
    for (int j=0; j<WindowsRow; j++)
    {
      rect(WindowXPosition, WindowYPosition, WindowsDimention, WindowsDimention);     
      WindowYPosition = WindowYPosition + WindowsDimention +  WindowGap;
    }
    WindowYPosition = Y + WindowGap;
    WindowXPosition = WindowXPosition + WindowsDimention +  WindowGap;
  }
}

void drawDoor(int X, int BWidth, int BHeight)
{
  fill (255); //makes white doors.

  float CenterOfBuilding = BWidth/2 + X;
  //we find the center of the first floor of the building and used the point as a reference to draw the door.

  rect (CenterOfBuilding-DoorWidth, BHeight-DoorHeight, DoorWidth, DoorHeight); //door #1
  rect (CenterOfBuilding, BHeight-DoorHeight, DoorWidth, DoorHeight); //door #2
  line (CenterOfBuilding-5, BHeight-15, CenterOfBuilding-5, BHeight-10); //door handle #1
  line (CenterOfBuilding+5, BHeight-15, CenterOfBuilding+5, BHeight-10); //door handle #2
}

void  drawRoof(int X, int Y, int BWidth, int R, int G, int B)
{
  fill (R, G, B); //paint the roof a lighter color than the building.

  int BWidthY = (int)(BWidth * sin(Angle)); // get the y component of BWidth.
  int BWidthX = (int)(BWidth * cos(Angle)); // get the x component of BWidth.

  quad (X, Y, 
  X + BWidth, Y, 
  X + BWidth + BWidthX, Y - BWidthY, 
  X + BWidthX, Y - BWidthY);
}

void drawSideWall(int X, int Y, int BWidth, int BHeight, int R, int G, int B)
{
  fill (R, G, B); //paint the sidewall a darder color than the building.

  int BWidthY = (int)(BWidth * sin(Angle)); // get the y component of BWidth.
  int BWidthX = (int)(BWidth * cos(Angle)); // get the x component of BWidth.

  quad (X, Y, 
  X + BWidthX, Y - BWidthY, 
  X + BWidthX, Y - BWidthY + BHeight, 
  X, Y + BHeight);
}

void drawSideWindows(int WindowsRow, int WindowsColoumn, int X, int Y)
{
  fill (200); //makes light grey windows.

  int WindowGapX = (int)(WindowGap * sin(Angle)); // get the X component of WindowGap.
  int WindowGapY = (int)(WindowGap - (WindowGap * cos(Angle))); // get the Y component of WindowGap.

  int WindowXPosition = X + WindowGapX;
  int WindowYPosition = Y + WindowGapY;

  int WindowsDimentionX = (int)(WindowsDimention * sin(Angle)); // get the X component of WindowsDimention.
  int WindowsDimentionY = (int)(WindowsDimention * cos(Angle)); // get the Y component of WindowsDimention.

  for (int i=0; i<WindowsColoumn; i++)
  {
    for (int j=0; j<WindowsRow; j++)
    {
      quad (WindowXPosition, WindowYPosition, 
      WindowXPosition + WindowsDimentionX, WindowYPosition - WindowsDimentionY, 
      WindowXPosition + WindowsDimentionX, WindowYPosition - WindowsDimentionY + WindowsDimention, 
      WindowXPosition, WindowYPosition + WindowsDimention);  

      WindowYPosition = WindowYPosition + WindowsDimention + WindowGap;
    }
    WindowXPosition = WindowXPosition + WindowsDimentionX + WindowGapX;
    WindowYPosition = Y + WindowGapY - ((i+1)*(WindowsDimentionY + ((int)(WindowGap * cos(Angle))))); //- ((i+1) * (WindowsDimention +  WindowGapY));
  }
}

