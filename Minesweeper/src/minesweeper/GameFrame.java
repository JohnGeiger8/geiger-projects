/* 
 * Frame of the Minesweeper window.
 *   Handles placement of view objects.
 */
package minesweeper;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JPanel;

/*
 * @author JohnGeiger
 */
public class GameFrame extends JFrame {
    private final JPanel mainPanel;
    private final JPanel menuPanel;
    private final JPanel gamePanel;
    private final JButton resetButton;    // use to start game over
    private final JButton flagButton;     // use flag to indicate suspected bomb
    private final JComboBox diffList;     // difficulty drop-down list
    private MineField minefield;
    
    public GameFrame()
    {   
        super("Minesweeper"); 
     
        mainPanel = new JPanel(new GridBagLayout());
        menuPanel = new JPanel(new GridBagLayout());
        gamePanel = new JPanel(new GridBagLayout());
        resetButton = new JButton("Reset");
        flagButton = new JButton("Flag");
        String[] difficulties = new String[]{"Easy", "Medium", "Hard"};
        diffList = new JComboBox(difficulties);
                                
        // add components to menu with appropriate gridbag constraints
        GridBagConstraints menuConstraints = new GridBagConstraints();
        menuConstraints.gridwidth = 3;
        menuConstraints.fill = GridBagConstraints.HORIZONTAL;
        menuConstraints.anchor = GridBagConstraints.LINE_START;
        menuPanel.add(resetButton, menuConstraints);
        menuConstraints.gridwidth = 2;
        menuPanel.add(diffList, menuConstraints);
        menuConstraints.gridwidth = 3;
        menuConstraints.anchor = GridBagConstraints.LINE_END;
        menuPanel.add(flagButton, menuConstraints);
        menuConstraints.gridwidth = 8;
        mainPanel.add(menuPanel, menuConstraints);
        
        resetButton.addActionListener(new ActionListener()
        {
            @Override
            public void actionPerformed(ActionEvent event)
            {
                gamePanel.removeAll();      // Reset game tiles
                initMinefield();
                pack();                     // Resize window
                setMinimumSize(getSize());
            }
        }
        );
        
        flagButton.addActionListener(new ActionListener()
        {
            @Override
            public void actionPerformed(ActionEvent event)
            {
                if (minefield.getFlag() == true)
                {
                    flagButton.setSelected(false);
                    minefield.setFlag(false);
                }
                else
                {
                    flagButton.setSelected(true);
                    minefield.setFlag(true);
                }
            }
        }
        );
      
        initMinefield();
    }
    
    private void initMinefield() 
    {
        String difficulty = diffList.getSelectedItem().toString();
        MineField minefield = new MineField(difficulty);   
        
        /* Construct gamePanel */
        JButton[][] field = minefield.getField();
        GridBagConstraints constraints = new GridBagConstraints();
        for (int i = 0; i < minefield.getHeight(); i++)
        {
            for (int j=0; j < minefield.getWidth(); j++)
            {         
                constraints.gridx = j;
                constraints.gridy = i+1;
                constraints.gridwidth = 1;
                gamePanel.add(field[i][j], constraints);
            }
        }
        
        // Add gamePanel to the main Panel layout
        constraints.gridx = 0;
        constraints.gridy = 1;
        constraints.gridwidth = 8;
        constraints.anchor = GridBagConstraints.CENTER;
        mainPanel.add(gamePanel, constraints);
        
        setContentPane(mainPanel);
        
        this.minefield = minefield;
        pack();
    }
}
