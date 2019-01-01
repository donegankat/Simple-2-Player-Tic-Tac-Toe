/// *********
/// Variables
/// *********

private Board _board;

// We'll treat the window width & height as a bit smaller than we actually make it so that we have a border around the game board 
int windowWidth = 840;
int windowHeight = 840;
int windowPadding = 40;

int squarePadding = 20; // The space between the square edges and the shapes we're going to draw in them

int currentPlayer = 1; // 1 is X, 2 is O

int shapeWidth = windowWidth/3 - windowPadding - squarePadding;
int shapeHeight = windowHeight/3 - windowPadding - squarePadding;

boolean isGameOver; // Indicates if a player has won.


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
  
  isGameOver = false;
  
  _board = new Board();
  _board.Setup();
}

void draw() // This doesn't need to do anything but it can be called if we need to refresh the screen
{
  
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
  
  // Evaluate which column was clicked
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
  
  // Evaluate which row was clicked
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
    int currentSquareIndex = _board.getSquareIndex(row, column); // Figure out which square was clicked on
    
    TakeTurn(currentSquareIndex);
  }
  else // The click wasn't in a square so let the player know they had a bad click & need to try again
  {
    _printMessage("INVALID CLICK", false); // Print on the screen for the player to see
  }
}

// Takes a turn and draws the current player's shape on the screen.
void TakeTurn(int currentSquareIndex)
{
  if (!isGameOver)
  {
    int currentSquareStatus = _board.getSquareStatus(currentSquareIndex); // Check to see if the square that was clicked was already occupied
    
    if (currentSquareStatus == 0) // If the square is empty then we can fill it in.
    {
      _board.setSquareStatus(currentSquareIndex, currentPlayer); // Mark that this square is now filled by the current player
          
      isGameOver = _board.checkPlayerWon(); // Check to see if the player won the game
      if (isGameOver) // Winner
      {
        _printMessage("PLAYER " + currentPlayer + " WON", true); // Print on the screen for the player to see
        println("PLAYER", currentPlayer, "WON"); // Print to the console window
      }
      else
      {
        _eraseMessage(); // Clear any previous text from below the board
      }
      
      if (currentPlayer == 1) // Player 1 is playing, so draw an X
      {
        _board.DrawX(currentSquareIndex);
        currentPlayer = 2; // Switch from X to O next time
      }
      else // Player 2 is playing, so draw an O
      {
        _board.DrawO(currentSquareIndex);
        currentPlayer = 1; // switch from O to X next time
      }
    }
  }
} //<>// //<>//



/// *********
/// Helpers
/// *********
 //<>//
// Prints a message on the screen below the board.
// TODO: If I ever feel like making this a better game, the redFill parameter should be changed to a fancier way of defining the text color.
// TODO: I should also add an x and y parameter to let the text position be customizable.
private void _printMessage(String message, boolean redFill) // The redFill boolean is just a lazy, shitty way for me to indicate if the text should be red. Otherwise have the text be white.
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
private void _eraseMessage()
{
  fill(0);
  noStroke();
  rect(0, 900 - 24, windowWidth, windowPadding);
}
