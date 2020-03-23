/*
 */
package minesweeper;
import javax.swing.JFrame;

/** Minesweeper project
 *
 * @author JohnGeiger
 */
public class Minesweeper {
    public static void main(String[] args)
    {
        GameFrame msweeper = new GameFrame();
        msweeper.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        msweeper.setLocationByPlatform(true);
        msweeper.setMinimumSize(msweeper.getSize());
        msweeper.setVisible(true);
    }
}
