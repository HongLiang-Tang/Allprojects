import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Scanner;

public class Game
{
    private String playerName;
    private int gameTotal;
    private ArrayList<Buffer> multipleList;

    public Game(String playName, int gameTotal, ArrayList<Buffer> multipleList) {
        this.playerName = playName;
        this.gameTotal = gameTotal;
        this.multipleList = multipleList;
    }

    /**
     * default constructor
     */
    public Game()
    {
        playerName = "";
        gameTotal = 0;
        this.multipleList = new ArrayList<>();
    }

    public void initiateGame()
    {
        Input input = new Input();
        boolean switcher = true;
        while (switcher)
        {
        displayMenu();
        String menuChoice = input.acceptStringInput("Please select from the given options only");
        switcher = playerSelectionResponder(menuChoice);
        }

        //a = 0||1||2

    }

    public void executeGame()
    {
        Input input = new Input();
        int[] multiplesTile = readMultiples();
        Buffer buffer = new Buffer();
        boolean continuePlay = true;
        while (continuePlay)
        {
            //play game
            //{ , , , , , }
            if (gameTotal == 0)
            {
            int randomMultiple = multiplesTile[initiateRandomNumber(2,0)];
            gameTotal = randomMultiple;
            }
            System.out.println(buffer.displayBuffer() + "\n" + "\n" + "\n");
            System.out.println("Randomly Generated Number(gameTotal): " + gameTotal + "\n" + "\n");
            //gameTotal: x
            displayActions();
            String option = playOptionHandler();
            enterToContinue();
            if (option.equals("1"))
            {
                //split
                boolean isSplitSuccessful = buffer.split(gameTotal);
                if (isSplitSuccessful)
                {
                    System.out.println("the value is added to buffer");
                    gameTotal = 0;
                }
                else
                    System.out.println("split failed");

            }
            else
            {
                //merge
                boolean isMergeSuccessful = buffer.merge(gameTotal);
                if (isMergeSuccessful)
                {
                    gameTotal *= 2;
                    System.out.println("Merge successful, gameTotal updated");
                }
                else
                    System.out.println("Sorry, I cannot find the corresponding value in Buffer, Please try other options");
            }
            //game ends when t >= 256
            //when buffer reach the limited size of 5 and cannot merge
            continuePlay = checkGameStatus(gameTotal, buffer);
            if (!continuePlay)
            {
                writeToFile(buffer,gameTotal);
            }
        }
    }

    public void writeToFile(Buffer buffer, int score)
    {
        try
        {   PrintWriter printWriter = new PrintWriter("outcome.txt");
            try
            {
                printWriter.println(playerName + " has won the game, with the highest achieved score of " + buffer.findLargestMultiple(score));
            }
            finally
            {
                printWriter.close();
            }
        }
        catch (IOException e)
        {
            System.out.printf("catch checked exception: IOException");
        }
    }

    public boolean checkGameStatus(int score, Buffer buffer)
    {
        boolean flag = true;
        if (score >= 256)
        {
            System.out.println("Congratulations! you win the game");
            flag = false;
        }
        else if (buffer.getList().size() == 5 && buffer.mergePossible(score))
        {
            System.out.println("you lose this game");
            flag = false;
        }

        return flag;
    }

    public String playOptionHandler()
    {
        Input input = new Input();
        String option = "";
        boolean flag = true;
        while (flag)
        {
            option = input.acceptStringInput("Please select an option: ");
            if (option.equals("1") || option.equals("2"))
            {
                System.out.println("you have selected " + option);
                flag = false;
            }
            else
                System.out.println(" you need to choose 1 or 2");
        }
        return option;
    }

//    public String menuOptionHandler()
//    {
//        Input input = new Input();
//        String option = "";
//        boolean flag = true;
//        while (flag)
//        {
//            option = input.acceptStringInput("Please select an option: ");
//            if (option.equals("1") || option.equals("2") || option.equals("3"))
//            {
//                System.out.println("you have selected " + option);
//                flag = false;
//            }
//            else
//                System.out.println(" you need to choose 1, 2, 3 or 4");
//        }
//        return option;
//    }

    public int initiateRandomNumber(int max, int min)
    {
        RNG rng = new RNG(max,min);
        int randomNumber = rng.randomNumberGenerator();
        return randomNumber;
    }

    public int[] arrayStringToInt(String[] array)
    {
        int[] integerMultiples = new int[array.length];
        for (int i = 0; i < array.length; i++)
        {
            integerMultiples[i] = Integer.parseInt(array[i]);
        }
        return integerMultiples;
    }

    public int[] readMultiples()
    {
        String fileName = ("HDmultiples.txt");
        String[] multiplesArray = new String[3];
        try
        {
            FileReader file = new FileReader(fileName);
            try
            {
            Scanner scan = new Scanner(file);
            String content = scan.nextLine();
            multiplesArray = content.split(",");
            }
            finally
            {
                file.close();
            }
        }
        catch (FileNotFoundException e)
        {
            System.out.println(fileName + " not found");
        }
        catch (IOException e)
        {
            System.out.println("Unexpected I/O exception occurs");
        }
        return arrayStringToInt(multiplesArray);
    }

    public ArrayList<String> handleReadFile()
    {
        FileIO file = new FileIO("multiples.txt");
        ArrayList<String> temp = new ArrayList<>();
        try
        {
            temp = file.readFile();
        }
        catch (IOException e)
        {
            System.out.println("Unexpected I/O exception occurs");
        }
        return temp;
    }

    public int[] readMultiplesTest()
    {

        String[] multiplesFromFIle = new String[handleReadFile().size()];
        String[] separatedMultiples = new String[3];
        for (int i = 0; i < handleReadFile().size();i++)
        {
            multiplesFromFIle[i] = handleReadFile().get(i);
            System.out.println(multiplesFromFIle[i]);
        }
        separatedMultiples = multiplesFromFIle[0].split(",");
        return arrayStringToInt(separatedMultiples);
    }

    public void test()
    {
        int[] testing = readMultiples();
        for (int a : testing)
        {
            System.out.println(a);
        }
    }

    private void helpMenu()
    {
        System.out.println("Welcome to the 256 with ArrayList help Menu...");
        System.out.println("You will be given a random number every time after you make a decision");
        System.out.println("The decisions you can make are : split and merge");
        System.out.println("when you choose to split, you will store the random number on your screen to your Buffer");
        System.out.println("when you choose to merge, This allows the player to merge the number in the game total " +
                "\n" + " box with a matching number in the arraylist at any position. The total is then put in the" +
                "\n" + "game total box and the number which is added is then removed from the arraylist." +
                "\n" + "After the total is added, the game total (t) now shows the new number");
        System.out.println("");
        System.out.println("Repeat the process, until you cannot merge and split again due to your Buffer list full " +
                "\n" + "Buffer can store up to 5 number");
        System.out.println("you will win this game if you reach the goal score you set for yourself");
    }



    /**
     * This Method will display selection menu to player
     */
    private void displayMenu()
    {
        System.out.println("Please select from the following options"
                + "\n" + "Press 1 to register a player"
                + "\n" + "Press 2 to start a new game"
                + "\n" + "Press 3 to view a help menu"
                + "\n" + "press 4 to exit");
    }

    private void displayActions()
    {
        System.out.println("The following are the actions which can be performed: " + "\n" +
                 "Press 1 to Split" + "\n" +
                 "Press 2 to Merge");
    }

    private void registerPlayerName()
    {
        String playerInput = "";
        boolean isLegalName = false;
        Input input = new Input();
        while (!isLegalName)
        {
            playerInput = input.acceptStringInput("Please enter the player name").trim();
            isLegalName = stringLengthWithinRange(playerInput,3,10);
            if (!isLegalName)
                System.out.println("The player’s name must be between 3 and 10 characters long.");

        }
        playerName = playerInput;
        System.out.println("your name is " + playerInput);
    }

    private boolean playerSelectionResponder(String option)
    {
        boolean flag = true;
        switch (option)
        {
            case "1":
                //register user
                registerPlayerName();
                System.out.println("Player registered" + "\n" + "\n"  + "Welcome " + playerName);
                enterToContinue();
                flag = true;
                //refresh page
                break;

            case "2":
                if (playerName.equals(""))
                {
                    System.out.println("Please register a player first.");
                    enterToContinue();
                    flag = true;
                    //refresh page
                }
                else
                {
                    System.out.println("game start");
                    //Menu --> response--> game formally start -->....
                    executeGame();
                    flag = false;
                }
                break;

            case "3":
                helpMenu();
                System.out.println("\n" + "Press enter to exit Help Menu");
                enterToContinue();
                flag = true;
                break;

            case "4":
                System.out.println("Exit Game");
                flag = false;
                break;

            default:
                System.out.println("Please enter a valid option");
                enterToContinue();
                flag = true;
        }
        return flag;
    }


    public String getPlayerName()
    {
        return playerName;
    }

    public void setPlayerName(String playerName)
    {
        this.playerName = playerName;
    }

    public int getGameTotal()
    {
        return gameTotal;
    }

    public void setGameTotal(int gameTotal)
    {
        this.gameTotal = gameTotal;
    }

    public ArrayList<Buffer> getMultipleList()
    {
        return multipleList;
    }

    public void setMultipleList(ArrayList<Buffer> multipleList)
    {
        this.multipleList = multipleList;
    }

    /**
     * Method to check if the string length is between a range
     * (from my tutorial code)
     */
    private boolean stringLengthWithinRange(String value, int min, int max)
    {
        boolean withinRange = false;
        if ((value.trim().length() >= min) && (value.trim().length() <= max))
            withinRange = true;
        return withinRange;
    }

    /**
     * This Method is mainly for user experience, so they can press enter to continue.
     */
    private void enterToContinue()
    {
        System.out.print("Please press enter to continue");
        Scanner console = new Scanner(System.in);
        console.nextLine();
    }

}
