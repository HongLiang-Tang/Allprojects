 

import java.util.Scanner;

/**
 * The Game class will manage the playing of a game
 *
 * @author Hongliang Tang
 * @version 1.0 (04.September.2019)
 */
public class Game
{
    //this Class has no fields.
    public Game()
    {

    }

    /**
     * Method to start the game
     */
    public void initiateGame()
    {
        //we first need a player
        Player player = new Player();
        // if name ="", show displayMenu recursively.
        boolean switcher = true; //this will allow us to get into the while loop first(initialization).
        while (switcher)
        {
            System.out.print('\u000C');
            displayMenu();
            int playerOptionChoice = acceptIntegerInput("Please select from the given options only");
            //response to user
            switcher = playerSelectionResponder(playerOptionChoice, player);
        }
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

    /**
     * Method which displays a message to the user to enter an INTEGER input
     * which is read from the keyboard using the Scanner object and then passed
     * to the calling method
     * (from my tutorial code)
     *
     * @param displayMessage A string message telling the user what input is expected
     * @return               A single integer value which is entered by the user
     */
    private int acceptIntegerInput(String displayMessage)
    {
        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        return console.nextInt();
    }

    /**
     * This Method acts as a Responder to player's choice on a certain option,
     * it is used to support the Method startGame() to perform interaction with player.
     *
     * @param option the options player choose to select from game menu
     * @param player the player object from Player Class
     */
    private boolean playerSelectionResponder(int option, Player player)
    {
        boolean flag = true;
        switch (option)
        {
            case 1:
                //register user
                registerPlayerName(player);
                System.out.println("Player registered" + "\n" + "\n"  + "Welcome " + player.getName());
                enterToContinue();
                flag = true;
                //refresh page
                System.out.print('\u000C');
                break;

            case 2:
                if (player.getName().equals(""))
                {
                    System.out.println("Please register a player first.");
                    enterToContinue();
                    flag = true;
                    //refresh page
                    System.out.print('\u000C');
                }
                else
                {
                    System.out.println("Let's set up rounds!");
                    //Menu --> response--> game formally start -->....
                    startGameRounds(player);
                    flag = false;
                }
                break;

            case 3:
                menuHelper();
                System.out.println("\n" + "Press enter to exit Help Menu");
                enterToContinue();
                flag = true;
                break;

            case 4:
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

    /**
     * Method to display the help menu.
     */
    private void menuHelper()
    {
        System.out.println("Welcome to the 21WithPrime help Menu...");
        System.out.println("In this game, you are required to compete with computer by making decision in turns");
        System.out.println("you are given 5 tiles value which are 1, 2, 3, 5, 7");
        System.out.println("tile value 1 associate with score 5"
                + "\n" + "tile value 2 associate with score 4"
                + "\n" + "tile value 3 associate with score 3"
                + "\n" + "tile value 5 associate with score 2"
                + "\n" + "tile value 7 associate with score 1");
        System.out.println("your goal is to accumulate as many scores as you can to compete with computer");
        System.out.println("Once the total value accumulated by player and computer reaches or is over 21 , " +
                "this particular round is finished");
        System.out.println("Be aware! If tile value 5 has not been selected at the end of each round"
                + "\n" + "you will suffer a -3 score penalty before announcing the winner of the round");
        System.out.println("The winner of each round will get an extra 5 marks as a bonus");
        System.out.println("After all rounds finished, the final winner will be displayed by comparing "
                + "\n" + "the number of rounds won by you to that of computer");
        System.out.println("it is possible to draw in rounds or in final winner");
        enterToContinue();
    }

    /**
     * This Method is to register the player name with length between 3 to 10 characters.
     *
     * @param player the player object in the Player Class
     */
    private void registerPlayerName(Player player)
    {
        String playerInput = "";
        boolean isLegalName = false;
        while (!isLegalName)
        {
            playerInput = acceptStringInput("Please enter the player name");
            isLegalName = stringLengthWithinRange(playerInput,3,10);
            if (!isLegalName)
                System.out.println("The player’s name must be between 3 and 10 characters long.");
        }
        player.setName(playerInput);
        System.out.println("your name is " + playerInput);
    }

    /**
     * Method which displays a message to the user to enter a STRING input
     * which is read from the keyboard using the Scanner object and then passed
     * to the calling method
     * (from my tutorial code)
     *
     * @param displayMessage A string message telling the user what input is expected
     * @return               A single string object which is entered by the user
     */
    private String acceptStringInput(String displayMessage)

    {
        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        return console.nextLine();
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

    /**
     * Method to start the rounds.
     * @param player a object of the Player Class
     */
    private void startGameRounds(Player player)
    {
        // 1. define the number of rounds the player wishes to play(0,10)
        int rounds = numOfRounds();
        int roundsNumber = 1;

        Player computer = new Player();
        // 2. play matches.loop
        while (rounds >= roundsNumber)
        {
            // initialization : score，lastTilePlayed�?
            computer.roundsReset();
            player.roundsReset();
            System.out.println("Now playing Round " + roundsNumber + "\n" + "\n" + "");

            // play a match
            matchStart(player, computer);

            roundsNumber++;
        }
        //  winner born
        compareFinalRoundsWon(player,computer);
    }

    /**
     * Method to announce the final winner.
     *
     * @param player player object of the Player Class
     * @param computer computer object of the Player Class
     */
    private void compareFinalRoundsWon(Player player, Player computer)
    {
        System.out.println("All rounds finished.. Final results...");
        System.out.println("Human Player has won " + player.getRoundsWon()
                + ", " + "Computer Player has won " + computer.getRoundsWon() + "...");
        if (player.getRoundsWon() > computer.getRoundsWon())
            System.out.println("Congratulations....!!! Human Player WINS!!!");
        else if (computer.getRoundsWon() > player.getRoundsWon())
            System.out.println("Congratulations....!!! Computer Player WINS!!!"
                    + "\n" + "Oops... " + player.getName() + " try harder next time :D");
        enterToContinue();
    }

    /**
     * Method to display who goes first.
     *
     * @param whoPlayFirst a string tells the method who is the first player.
     */
    private void displayWhoPlayFirst(String whoPlayFirst)
    {
        boolean flag = true;
        while (flag)
        {
            switch (whoPlayFirst)
            {
                case "Human first":
                    System.out.println("Human player goes first...");
                    flag = false;
                    break;
                case "Computer first":
                    System.out.println("Computer player goes first...");
                    flag = false;
                    break;
                default:
                    // prevent programme crash if the random process goes wrong
                    System.out.println("game error, press enter to reload this part");
                    enterToContinue();
                    flag = true;
            }
        }
    }

    /**
     * Method for one match round, player and computer take turns
     *
     * @param player player object of the Player Class
     * @param computer computer object of the Player Class
     */
    private void matchStart(Player player, Player computer)
    {
        //random choose the first player
        String firstPlayer = drawFirstPlayer();
        displayWhoPlayFirst(firstPlayer);

        int gameTotal = 0;
        //record how many turn in a round this computer played
        int compturn = 0;
        //record turns player got
        int playturn = 0;
        while (gameTotal < 21)
        {
            System.out.println("Game total is : " + gameTotal + "\n" + "\n" + "");
            if (firstPlayer.equals("Human first"))
            {
                //human turn
                System.out.println("Player turn...");
                playturn++;
                gameTotal = playerTurn(gameTotal,player);
                //swap
                firstPlayer = "Computer first";
            }
            else
            {
                 //computer turn
                System.out.println("computer turn");
                compturn++;
                gameTotal = computerTurn(computer,gameTotal,compturn,player,playturn);
                enterToContinue();
                //refresh page
                System.out.print('\u000C');
                //swap
                firstPlayer = "Human first";
            }
        }
        // game summary
        System.out.println("21!!! Round Over!!!" + "\n" + "Calculating Final Scores...");
        //score deduction
        scoreReduction(player,"Human player has not used the tile with value of 5. Penalty Applied",
                "Human player ");
        scoreReduction(computer,"Computer player has not used the tile with value of 5. Penalty Applied",
                "Computer Player ");
        //higher score bonus
        scoreBonus(player,computer);
        //winner check
        updateRoundsWon(player, computer);
    }

    /**
     * Method to update the number of rounds won by each player after each match round.
     *
     * @param player player object of the Player Class
     * @param computer computer object of the Player Class
     */
    private void updateRoundsWon(Player player, Player computer)
    {
        if (player.getScore() > computer.getScore())
            player.setRoundsWon(player.getRoundsWon() + 1);
        else if (player.getScore() < computer.getScore())
            computer.setRoundsWon(computer.getRoundsWon() + 1);
    }

    /**
     * Method to deal with some score bonus occasions.
     *
     * @param player player object of the Player Class
     * @param computer computer object of the Player Class
     */
    private void scoreBonus(Player player, Player computer)
    {
        //check higher score
        if (player.getScore() > computer.getScore())
        {
            System.out.println("Human Player has WON this round!! congratulations. Bonus Points added ");
            player.setScore(player.getScore() + 5);
        }
        else if (player.getScore() == computer.getScore())
        {
            System.out.println("It's a draw!!! NO Bonus Points for both Player. ");
        }
        else
        {
            System.out.println("Computer Player has WON this round!! congratulations. Bonus Points added ");
            computer.setScore(computer.getScore() + 5);
        }
        System.out.println("Final Scores :" + "\n" + "Human Player : " + player.getScore()
                + "\n" + "Computer Player : " + computer.getScore());
    }

    /**
     * Method to deduct score at the each of each round if tile 5 is not used.
     * @param player player object of Player class.
     * @param comment a string to pass in a comment to remind player they didn't choose tile 5
     * @param identity a string to pass in identity(player/computer) to the output
     */
    private void scoreReduction(Player player, String comment,String identity)
    {
        if (player.getTiles()[1] != null)
        {
            System.out.println(comment);
            player.setScore(player.getScore()-3);
            System.out.println(identity + "final round score : " + player.getScore());
        }
        else
            System.out.println(identity + "final round score : " + player.getScore());
    }

    /**
     * Method to conduct a player turn
     *
     * @param gameTotal the game total value, an integer.
     * @param player the player object of the Player Class
     * @return gameTotal
     */
    private int playerTurn(int gameTotal, Player player)
    {
        System.out.println("Selecting from the following tiles = [" + player.displayTileChoice() + "]");
        //choose tile and validate it.
        int tilePicked = 0;
        boolean flag = true;
        while (flag)
        {
            System.out.println("Please choose a valid tile value");
            tilePicked = acceptIntegerInput("Please enter the tile value you wish to play from the above list: ");
            for (int i = 0; i < player.getTiles().length; i++)
            {
                if ( player.getTiles()[i] != null)
                    if (tilePicked == player.getTiles()[i].getValue())
                    {
                        flag = false;
                        System.out.println("Player has played tile " + tilePicked + "\n" + "\n" + "");
                    }
            }
        }
        //accumulate value
        gameTotal += tilePicked;
        //determine score
        // if gameTotal > 21 ->not add score
        //else gameTotal <= 21 -> add score
        if (gameTotal <= 21)
        {
            System.out.println("Player current score is " + player.getScore());
            player.newScoreUpdate(tilePicked);
            System.out.println("Player new score is " + player.getScore());
            //deleted picked tile
            player.deletePickedTile(tilePicked);
        }
        return gameTotal;
    }

    /**
     * Method to decide the computer strategy
     *
     * @param computer computer object of the Player Class
     * @param gameTotal game total value
     * @return gameTotal
     */
    private int computerTurn(Player computer, int gameTotal, int compturn, Player player, int playturn)
    {
        System.out.println("Selecting from the following tiles = [" + computer.displayTileChoice() + "]");
        int tilePicked = 0;
        if (compturn <= 1)
        {
            int temp = randomNumberGenerator(3, 1);
            for (int i = 0; i < computer.getTiles().length; i++)
            {
                if (computer.getTiles()[i] != null)
                    if (temp == computer.getTiles()[i].getValue())
                    {
                        tilePicked = temp;
                        System.out.println("Computer picked " + tilePicked + "\n" + "\n" + "");
                    }
            }
        }

        //boom
        else if (compturn > playturn)
        {
            if (computer.getScore() - 3 > player.getScore() && gameTotal >= 14)
            {
                if (computer.getTiles()[0] != null)
                {
                    tilePicked = 7;
                    System.out.println("Computer picked 7" + "\n" + "\n" + "");
                }
            }
        }

        //best choice
        else if (computer.getTiles()[1] != null)
        {
            tilePicked = 5;
            System.out.println("Computer picked 5" + "\n" + "\n" + "");
        }
        
        else if (computer.getTiles()[4] != null)
        {
            tilePicked = 1;
            System.out.println("Computer picked 1" + "\n" + "\n" + "");
        }
        
        else if (computer.getTiles()[3] != null && computer.getTiles()[2] != null)
        {
            if (gameTotal <= 18) {
                tilePicked = 3;
                System.out.println("Computer picked 3" + "\n" + "\n" + "");
            }
        }
        
        else if (computer.getTiles()[2] != null)
        {
            tilePicked = 2;
            System.out.println("Computer picked 2" + "\n" + "\n" + "");
        }
        
        else
        {
            tilePicked = 7;
            System.out.println("Computer picked 7" + "\n" + "\n" + "");
        }

        gameTotal += tilePicked;

        if (gameTotal <= 21)
        {
            System.out.println("Computer current score is " + computer.getScore());
            computer.newScoreUpdate(tilePicked);
            System.out.println("Computer new score is " + computer.getScore());
            computer.deletePickedTile(tilePicked);
        }
        return gameTotal;
    }

    /**
     * This method return number 0 or 1 with equal chance.
     */
    private int drawZeroOne()
    {
        RNG rng = new RNG(1,0);
        return rng.randomNumberGenerator();
    }

    /**
     * This method decide who (player or computer) play first.
     */
    private String drawFirstPlayer()
    {
        //1 stands for player, 0 stands for computer.
        int randomValue = drawZeroOne();
        if (randomValue == 1)
            return "Human first";
        else
            return "Computer first";
    }

    /**
     * This Method store the number of rounds inputted by player, limit rounds to be greater than 0 and
     * less than 10 inclusively.
     *
     * @return the number of rounds is going to be played.
     */
    private int numOfRounds()
    {
        int rounds;
        for (rounds = 0; rounds <= 0 || rounds >= 10; rounds = acceptIntegerInput("Please enter the number of rounds"))
        {
            System.out.println("Please enter rounds greater than 0 and less than 10.");
        }
        enterToContinue();
        //refresh page
        System.out.print('\u000C');
        return rounds;
    }

    /**
     * Method to generate random number with discretion
     * @param maximumValue maximum limit integer
     * @param minimumValue minimum limit integer
     * @return an integer number randomly generated
     */
    private int randomNumberGenerator(int maximumValue, int minimumValue)
    {
        int randomOutcome = (int)(Math.random() * ((maximumValue - minimumValue)+1) + minimumValue);
        return randomOutcome;
    }
}
