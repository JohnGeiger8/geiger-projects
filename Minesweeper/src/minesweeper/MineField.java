/*
 *  MineField class
 *      Represents the actual Minefield the user will interact with in the GUI
 *
 */
package minesweeper;
import java.awt.Image;
import java.awt.Point;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Random;
import java.util.ArrayList;
import javax.swing.ImageIcon;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import java.net.URL;
import javax.swing.JOptionPane;

/**
 *
 * @author JohnGeiger
 */
public class MineField {
    /* 
    Difficulty Levels:
        Easy: 14x8 grid with 16 mines
        Medium: 18x10 grid with 40 mines
        Hard: 24x13 grid with 80 mines
    */
    private int width, height, bomb_count;
    private int numberOfTiles;                    // Count of number tiles to reveal
    private String diff;                          // difficulty level
    private JButton[][] field;                    // the minefield itself
    private ImageIcon flagIcon;
    private ImageIcon bombIcon;
    private ImageIcon unpressedTileIcon;
    private ImageIcon pressedTileIcon;
    private final boolean[][] bombs;              // keeps track of where the bombs are
    private final boolean[][] exposedPoints;      // keeps track of points that have been exposed
    static private boolean flag;                  // indicates if flag button is pushed

    
    public MineField(String difficulty)
    {
        setDiff(difficulty);
        setDims(difficulty);
        setNumberOfTiles();
        bombs = new boolean[height][width];
        exposedPoints = new boolean[height][width];
        setIcons();
        initField();
        setBombs();
        setFlag(false);
    }
    
    // setters and getters
    public void setDiff(String diff)
    {
        this.diff = diff;
    }
    public void setBombsArr(int height, int width, boolean t)
    {
        bombs[height][width] = t;
    }
    public void setExpPoints(int height, int width, boolean t)
    {
        JButton[][] field = getField();
        JButton currentTile = field[height][width];
        int tileNumber = countBombs(height, width);
        
        if (getExposedPoints()[height][width])
            return;
        
        if (!getBombsArr()[height][width]) // If not a bomb tile
        {
            field[height][width].setIcon(pressedTileIcon);

            // Exposed points should have bomb count showing on top of icon
            currentTile.setText(Integer.toString(tileNumber));
            currentTile.setHorizontalTextPosition(JButton.CENTER);
            currentTile.setVerticalTextPosition(JButton.CENTER);
            
            // Decrease number of tiles left to reveal
            numberOfTiles -= 1; 
        }
        else
            field[height][width].setIcon(bombIcon);
        
        exposedPoints[height][width] = t;
    }
    public void setDims(String diff)
    {
        if (diff == "Easy")
        {
            width = 8;
            height = 14;
            bomb_count = 16;
        }
        else if (diff == "Medium")
        {
            width = 10;
            height = 18;
            bomb_count = 40;
        }
        else if (diff == "Hard")
        {
            width = 13;
            height = 24;
            bomb_count = 80;
        }
        else
        {
            width = 0;
            height = 0;
            bomb_count = 0;
        }
    }
    public void setNumberOfTiles()
    {
        this.numberOfTiles = width * height - bomb_count;
    }
    public void setFlag(boolean isPressed)
    {
        flag = isPressed;
    }
    public void setIcons() 
    {
        URL flagURL = getClass().getResource("Images/flag.jpg");
        Image flagImage = Toolkit.getDefaultToolkit().getImage(flagURL);
        flagIcon = new ImageIcon(flagImage);
        
        URL bombURL = getClass().getResource("Images/bomb.jpg");
        Image bombImage = Toolkit.getDefaultToolkit().getImage(bombURL);
        bombIcon = new ImageIcon(bombImage);
        
        URL tileURL = getClass().getResource("Images/unpressedTile.jpg");
        Image tileImage = Toolkit.getDefaultToolkit().getImage(tileURL);
        unpressedTileIcon = new ImageIcon(tileImage);
        
        URL pressedTileURL = getClass().getResource("Images/pressedTile.jpg");
        Image pressedTileImage = Toolkit.getDefaultToolkit().getImage(pressedTileURL);
        pressedTileIcon = new ImageIcon(pressedTileImage);
    }
    public String getDiff()
    {
        return diff;
    }
    public JButton[][] getField()
    {
        return field;
    }
    public boolean[][] getBombsArr()
    {
        return bombs;
    }
    public boolean[][] getExposedPoints()
    {
        return exposedPoints;
    }
    public int getWidth()
    {
        return width;
    }
    public int getHeight()
    {
        return height;
    }
    public int getBombCount()
    {
        return bomb_count;
    }          
    public boolean getFlag()
    {
        return flag;
    }
    
    public void initField()
    {
        ButtonHandler buttonHandler = new ButtonHandler();
        field = new JButton[getHeight()][getWidth()];
        int count = 0;
        for (int i = 0; i < getHeight(); i++)
        {
            for (int j = 0; j < getWidth(); j++)
            {
                // Each button should have default tile icon and no border
                field[i][j] = new JButton(unpressedTileIcon);
                field[i][j].setBorder(BorderFactory.createEmptyBorder());
                field[i][j].addActionListener(buttonHandler);
            }
        }
    }
    
    // set up length x height minefield with bomb_count bombs in it
    public void setBombs()
    {
        // use pseudo-random number generator to place bombs
        Random rand = new Random();
        int x, y;
        
        // bombs list to store bombs
        int numberOfBombs = getBombCount();
        
        Point bomb;
        
        // loop through and create bomb_count bombs at random locations
        for (int i = 0; i < numberOfBombs; i++)
        {
            bomb = new Point(rand.nextInt(getHeight()), rand.nextInt(getWidth()));
            setBombsArr(bomb.x, bomb.y, true);
        }
    }
    
    public int countBombs(int row, int column)
    {
        /* Count the number of bombs surrounding the point
        
        Does extra checks in case we're at an edge

        */
        int count = 0;
        
        if (getBombsArr()[row][column])
            return -1;
        if (row != 0 && column != 0) 
            if (getBombsArr()[row - 1][column - 1])
                count++;
        if (row != 0) 
            if (getBombsArr()[row - 1][column])
                count++;
        if (row != 0 && column != getWidth()-1) 
            if (getBombsArr()[row - 1][column + 1])
                count++;
        if (column != 0) 
            if (getBombsArr()[row][column - 1])
                count++;
        if (column != getWidth()-1) 
            if (getBombsArr()[row][column + 1])
                count++;
        if (row != getHeight()-1 && column != 0) 
            if (getBombsArr()[row + 1][column - 1])
                count++;                
        if (row != getHeight()-1) 
            if (getBombsArr()[row + 1][column])
                count++;                
        if (row != getHeight()-1 && column != getWidth()-1) 
            if (getBombsArr()[row + 1][column + 1])
                count++;
        
        return count;
    }
    
    private void exposeAllPoints() 
    {        
        for (int i = 0; i < getHeight(); i++)
        {
            for (int j = 0; j < getWidth(); j++)
            {
                setExpPoints(i, j, true);
            }
        }
    }
    
    private void revealZeros(int rowPosition, int columnPosition) 
    {
        /* Reveal tiles surrounding specified position, and all tiles around 
            other zeros that are revealed.
        */
        
        // Check that positions are in range
        if (rowPosition < 0 || rowPosition > getHeight()-1 || columnPosition < 0
                || columnPosition > getWidth()-1)
        {
            return;
        }
        
        JButton currentTile = field[rowPosition][columnPosition];
        int tileNumber = countBombs(rowPosition, columnPosition);
        
        // Base case
        if (getExposedPoints()[rowPosition][columnPosition]) 
        {
            return;
        }
        else if (tileNumber != 0) 
        {
            setExpPoints(rowPosition, columnPosition, true);
            currentTile.setText(Integer.toString(tileNumber));
            currentTile.setHorizontalTextPosition(JButton.CENTER);
            currentTile.setVerticalTextPosition(JButton.CENTER);
            return;
        }
        // Recursive case
        else if (tileNumber == 0) 
        {
            setExpPoints(rowPosition, columnPosition, true);
            currentTile.setText(Integer.toString(tileNumber));
            currentTile.setHorizontalTextPosition(JButton.CENTER);
            currentTile.setVerticalTextPosition(JButton.CENTER);
            
            // Reveal surrounding squares
            revealZeros(rowPosition - 1, columnPosition);
            revealZeros(rowPosition - 1, columnPosition - 1);
            revealZeros(rowPosition - 1, columnPosition + 1);
            revealZeros(rowPosition + 1, columnPosition);
            revealZeros(rowPosition + 1, columnPosition - 1);
            revealZeros(rowPosition + 1, columnPosition + 1);
            revealZeros(rowPosition, columnPosition - 1);
            revealZeros(rowPosition, columnPosition + 1);
        }
        
    }
    
    private boolean isGameWon() 
    {
        // Check if game was won
        if (this.numberOfTiles == 0)
            return true;
        else
            return false;
    }
    
    private void displayWinningMessage() 
    {
        JOptionPane.showMessageDialog(null, "You Won!", "Minesweeper", 
                JOptionPane.INFORMATION_MESSAGE);
    }
        
    private class ButtonHandler implements ActionListener
    {
        /* Listens for mouse clicks on field buttons
        
        If a button's clicked, figure out which one, then take appropriate action
        
        */
        @Override
        public void actionPerformed(ActionEvent event)
        {
            Object buttonClicked = event.getSource();
            for (int i = 0; i < getHeight(); i++)
            {
                for (int j = 0; j < getWidth(); j++)
                {
                    if (buttonClicked.equals(getField()[i][j]))
                    {                        
                        if (!getExposedPoints()[i][j])
                        {
                            if (getFlag() && field[i][j].getIcon() == flagIcon) 
                            {
                                // Remove flag from button
                                field[i][j].setIcon(unpressedTileIcon);
                                return;
                            }
                            else if (getFlag() && field[i][j].getIcon() != flagIcon)
                            {
                                // Add flag to button
                                field[i][j].setIcon(flagIcon);
                                return;
                            }
                            else if (!getFlag() && field[i][j].getIcon() == flagIcon) 
                            {
                                // Don't reveal if tile is flagged
                                return;
                            }
                            else // Flag isn't pressed so just reveal tile
                            {
                                if (getBombsArr()[i][j])
                                {
                                    exposeAllPoints(); // Game over
                                }
                                
                                else // Didn't press a bomb
                                {
                                    int count = countBombs(i,j);
                                    
                                    if (count == 0)
                                        revealZeros(i,j);
                                }
                                
                                setExpPoints(i, j, true);
                                
                                if (isGameWon()) {
                                    displayWinningMessage();
                                }
                                return;
                            }
                        }
                    }
                }
            }
        }    
    }
}
