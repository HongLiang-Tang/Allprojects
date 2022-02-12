//Import libraries here
import java.util.Scanner;

/**
 * Input Class which creates a scanner object and accept input from the user
 * in different formats
 *
 * @author <<INSERT NAME>>
 * @version <<INSERT DATE>>
 */
public class Input
{
    /**
     * Constructor for objects of class Input
     */
    public Input()
    {
        
    }
    
    /**
     * Method which displays a message to the user to enter a CHARACTER input
     * which is read from the keyboard using the Scanner object and then passed 
     * to the calling method 
     * 
     * @param displayMessage A string message telling the user what input is expected
     * @param index          An integer representing the index of the character in the string to be returned
     * @return               A single character value which is entered by the user
     */
    public char acceptCharInput(String displayMessage, int index)
    
    {
        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        char usrinput = console.nextLine().charAt(index);
        return usrinput;
        //return console.nextLine().charAt(index);
            
    }
   
    /**
     * Method which displays a message to the user to enter an DOUBLE input
     * which is read from the keyboard using the Scanner object and then passed 
     * to the calling method 
     * 
     * @param displayMessage A string message telling the user what input is expected
     * @return               A single double value which is entered by the user
     */
    public double acceptDoubleInput(String displayMessage)
    {
        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        double usrinput = console.nextDouble();
        return usrinput;
        //return console.nextDouble();
        
    }

    /**
     * Method which displays a message to the user to enter an INTEGER input
     * which is read from the keyboard using the Scanner object and then passed 
     * to the calling method 
     * 
     * @param displayMessage A string message telling the user what input is expected
     * @return               A single integer value which is entered by the user
     */
    public int acceptIntegerInput(String displayMessage)
    {
        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        return console.nextInt();
    }
    
    /**
     * Method which displays a message to the user to enter a STRING input
     * which is read from the keyboard using the Scanner object and then passed 
     * to the calling method 
     * 
     * @param displayMessage A string message telling the user what input is expected
     * @return               A single string object which is entered by the user
     */
    public String acceptStringInput(String displayMessage)
    
    {
        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        return console.nextLine();
    }
}
