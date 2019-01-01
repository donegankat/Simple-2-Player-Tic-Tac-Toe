/// *********
/// Variables
/// *********

// We'll treat the window width & height as a bit smaller than we actually make it so that we have a border around the game board 
int windowWidth = 840;
int windowHeight = 840;
int windowPadding = 40;

int squarePadding = 20; // The space between the square edges and the shapes we're going to draw in them

int currentPlayer = 1; // 1 is X, 2 is O

int shapeWidth = windowWidth/3 - windowPadding - squarePadding;
int shapeHeight = windowHeight/3 - windowPadding - squarePadding;

int[] boardSquares;


/// *********
/// Setup
/// *********

void setup() // Pretty sure all Processing projects need this void setup()
{
  size(880,920); // This is the actual window size: (x:880, y:920), so it's quite a bit bigger than what we've accounted for with in windowWidth and int windowHeight.
  noStroke();
  background(0);
  
  PFont f = createFont("Arial", 24);
  textFont(f);
  
  setupBoard();
}

void draw() // This doesn't need to do anything but it can be called if we need to refresh the screen
{
  
}

void setupBoard()
{
  boardSquares = new int[9];
  
  for (int i = 0; i < 9; i++)
  {
    boardSquares[i] = 0; // Start with a fresh, empty board. 0 indicates that a space is free.
  }
  
  stroke(255, 255, 255);
  strokeWeight(5);  // Thicker
  
  // I don't know why but both the horizontal and vertical lines need to have windowPadding/2 added whenever we do anything with windowWidth/3 or windowHeight/3
  // If we don't add the windowPadding/2, then the squares come out unevenly sized.
  
  // Horizontal lines
  line(windowPadding, windowHeight/3 + windowPadding/2, windowWidth, windowHeight/3 + windowPadding/2);
  line(windowPadding, windowHeight - windowHeight/3 + windowPadding/2, windowWidth, windowHeight - windowHeight/3 + windowPadding/2);
  
  // Vertical Lines
  line(windowWidth/3 + windowPadding/2, windowPadding, windowWidth/3 + windowPadding/2, windowHeight);
  line(windowWidth - windowWidth/3 + windowPadding/2, windowPadding, windowWidth - windowWidth/3 + windowPadding/2, windowHeight);
}



/// *********
/// Events
/// *********

void mouseClicked()
{
  boolean validClick = true;
  
  int row = 0;
  int column = 0;
  
  // Make sure the click was in a valid area. If the user clicked outside of the game board, don't do anything.
  // If the click was valid, calculate which square was clicked.
  if (mouseX >= windowPadding && mouseX <= windowWidth/3) // Click was in the left column
  {
    column = 0;
  }
  else if (mouseX > windowWidth/3 && mouseX <= windowWidth - windowWidth/3) // Click was in the middle column
  {
    column = 1;
  }
  else if (mouseX > windowWidth - windowWidth/3 && mouseX < windowWidth - windowPadding) // Click was in the right column
  {
    column = 2;
  }
  else // The click was off the board somewhere
  {
    validClick = false;
  }
  
  
  if (mouseY >= windowPadding && mouseY <= windowHeight/3) // Click was in the top row
  {
    row = 0;
  }
  else if (mouseY > windowHeight/3 && mouseY <= windowHeight - windowHeight/3) // Click was in the middle row
  {
    row = 1;
  }
  else if (mouseY > windowHeight - windowHeight/3 && mouseY < windowHeight - windowPadding) // Click was in the bottom row
  {
    row = 2;
  }
  else // The click was off the board somewhere
  {
    validClick = false;
  }
    
  if (validClick) // The click was in a valid area
  {
    int currentSquareIndex = getSquareIndex(row, column); // Figure out which square was clicked on
    
    takeTurn(currentSquareIndex); //<>//
  }
  else // The click wasn't in a square so let the player know they had a bad click & need to try again
  {
    printMessage("INVALID CLICK", false); // Print on the screen for the player to see
  }
}

void takeTurn(int currentSquareIndex)
{
  int currentSquareStatus = getSquareStatus(currentSquareIndex); // Check to see if the square that was clicked was already occupied //<>//
  
  if (currentSquareStatus == 0) // If the square is empty then we can fill it in.
  {
    setSquareStatus(currentSquareIndex, currentPlayer); // Mark that this square is now filled by the current player
        
    boolean playerWon = checkPlayerWon(); // Check to see if the player won the game
    if (playerWon) // Winner
    {
      printMessage("PLAYER " + currentPlayer + " WON", true); // Print on the screen for the player to see
      println("PLAYER", currentPlayer, "WON"); // Print to the console window
    }
    else
    {
      eraseMessage(); // Clear any previous text from below the board
    }
    
    if (currentPlayer == 1) // Player 1 is playing, so draw an X
    {
      drawX(currentSquareIndex);
      currentPlayer = 2; // Switch from X to O next time
    }
    else // Player 2 is playing, so draw an O
    {
      drawO(currentSquareIndex);
      currentPlayer = 1; // switch from O to X next time
    }
  }
}



/// *********
/// Helpers
/// *********

// Returns the index that a particular square is stored in boardSquares[]
int getSquareIndex(int row, int column)
{
  return (row * 3) + column;
}

// Returns the current status of the given board index. Not actually strictly necessary because this functionality is easy enough to just do
int getSquareStatus(int index)
{
  return boardSquares[index];
}

// Sets the status of a board index
void setSquareStatus(int index, int status)
{
  boardSquares[index] = status;
}

// Checks to see if a player has won the game yet
boolean checkPlayerWon()
{
  boolean playerWon = false; 
  int horizontalCombo = 0;
  
  // Possible winning game states
  // Horizontal:
  // 0, 1, 2
  // 3, 4, 5
  // 6, 7, 8

  // Vertical:
  // 0, 3, 6
  // 1, 4, 7
  // 2, 5, 8

  // Diagonal:
  // 0, 4, 8
  // 2, 4, 6
  
  for (int i = 0; i < 9; i++)
  {
    // Vertical check
    if (i < 3) // Only need to check if i is 0, 1, or 2 because we'll look at the other squares in the if statement
    {
      if (boardSquares[i] == currentPlayer && boardSquares[i + 3] == currentPlayer && boardSquares[i + 6] == currentPlayer)
      {
        playerWon = true;
        break;
      }
    }
    
    // Horizontal check
    if (i % 3 == 0) // We're on a new row so reset the horizontal combo to 0
    {
      horizontalCombo = 0;
    }
    
    if (boardSquares[i] == currentPlayer)
    {
      horizontalCombo ++;
    }
    
    if (horizontalCombo >= 3)
    {
      playerWon = true;
      break;
    }
  }
  
  // Diagonal check
  if ((boardSquares[0] == currentPlayer && boardSquares[4] == currentPlayer && boardSquares[8] == currentPlayer)
  || (boardSquares[2] == currentPlayer && boardSquares[4] == currentPlayer && boardSquares[6] == currentPlayer))
  {
    playerWon = true;
  }
  
  return playerWon;
}


// Draw an X in the given square
void drawX(int squareIndex)
{
  int row = (int)squareIndex / 3;
  int column = squareIndex % 3;
  
  drawX(row, column); //<>//
}

// Draw an X in the given square
void drawX(int row, int column)
{
  int startDrawX = getStartDrawX(column);
  int startDrawY = getStartDrawY(row);
  
  stroke(0, 100, 255); // Set the stroke to blue for X's
  
  line(startDrawX, startDrawY, startDrawX + shapeWidth, startDrawY + shapeHeight);
  line(startDrawX, startDrawY + shapeHeight, startDrawX + shapeWidth, startDrawY);
}

// Draw an O in the given square
void drawO(int squareIndex)
{
  int row = (int)squareIndex / 3;
  int column = squareIndex % 3;
  
  drawO(row, column); //<>//
}

// Draw an O in the given square
void drawO(int row, int column)
{
  int startDrawX = getStartDrawX(column); //<>//
  int startDrawY = getStartDrawY(row);
  
  stroke(0, 255, 50); // Set the stroke to green for O's
  
  ellipseMode(CORNER);
  fill(0);
  ellipse(startDrawX, startDrawY, shapeWidth, shapeHeight);
}

// Gets the X coordinate at which to start drawing the shape.
int getStartDrawX(int currentColumn)
{
  int drawX = 0; //<>//
  
  switch (currentColumn)
  {
    case 0:
      drawX = windowPadding;
      break;
    case 1: 
      drawX = windowWidth/3 + windowPadding/2;
      break;
    case 2: 
      drawX = windowWidth - windowWidth/3 + windowPadding/2;
      break;
  }
  
  return drawX + squarePadding; // Pad each square a little bit
}

// Gets the Y coordinate at which to start drawing the shape. //<>//
int getStartDrawY(int currentRow)
{
  int drawY = 0;
  
  switch (currentRow)
  {
    case 0:
      drawY = windowPadding;
      break;
    case 1: 
      drawY = windowHeight/3 + windowPadding/2;
      break;
    case 2: 
      drawY = windowHeight - windowHeight/3 + windowPadding/2;
      break;
  }
  
  return drawY + squarePadding; // Pad each square a little bit
}

// Prints a message on the screen below the board.
// TODO: If I ever feel like making this a better game, the redFill parameter should be changed to a fancier way of defining the text color.
// TODO: I should also add an x and y parameter to let the text position be customizable.
void printMessage(String message, boolean redFill) // The redFill boolean is just a lazy, shitty way for me to indicate if the text should be red. Otherwise have the text be white.
{
  if (redFill) // Red is used when a player has won the game
  {
    fill(255, 0, 0);
  }
  else // All other notifications are white.
  {
    fill(255, 255, 255); 
  }
  
  text(message, windowPadding, 900); // Print on the screen for the player to see
}

// This is just a super hacky, shitty way to erase any text we've previously printed below the board. I'm being lazy so I'm just going to cover it up rather than redraw the canvas or anything.
// TODO: If I ever actually do anything with this game, make this better.
// TODO: I should also add an x and y parameter to let the text position be customizable.
void eraseMessage()
{
  fill(0);
  noStroke();
  rect(0, 900 - 24, windowWidth, windowPadding);
}
