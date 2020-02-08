/*
 */
package minesweeper;
import java.util.Random;
import java.util.ArrayList;
import javax.swing.JFrame;
import java.io.*;
import java.util.*;

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
