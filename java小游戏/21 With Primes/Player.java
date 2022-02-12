 

/**
 * The Player class will specify the attributes and behaviours of a player.
 *
 * @author Hongliang Tang
 * @version 1.0 (30.August.2019)
 */
public class Player
{
    //Class fields are here
    private String name;
    private int score;
    private Tile[] tiles;
    private Tile lastTilePlayed;
    private int roundsWon;

    /**
     * Create a Player with 5 elements in tiles. All other details are set to default values.
     */
    public Player()
    {
        name = "";
        score = 0;
        tiles = new Tile[5];
        lastTilePlayed = new Tile();
        roundsWon = 0;
    }

    /**
     *  non-default constructor for objects of class Player
     *
     * @param newName A single string which contains the player name
     * @param newScore An integer which contains the player score currently
     * @param newTiles An array of tile objects which are used to play the game.
     * @param newLastTilePlayed An tile object representing the last tile which was played by the player
     * @param newRoundsWon The number of rounds won by the player during the game.
     *
     */
    public Player(String newName, int newScore, Tile[] newTiles, Tile newLastTilePlayed, int newRoundsWon)
    {
        name = newName;
        score = newScore;
        tiles = newTiles;
        lastTilePlayed = newLastTilePlayed;
        roundsWon = newRoundsWon;
    }

    /**
     * Accessor Method to get the name of the player
     *
     * @return A single string which contains the name of the player
     */
    public String getName()
    {
        return name;
    }

    /**
     * Mutator Method to set the name of the player
     *
     * @param newName String to define the new name for the player
     */
    public void setName(String newName)
    {
        name = newName;
    }

    /**
     * Accessor Method to get the score of the player
     *
     * @return An integer which contains the score of the player for the current round.
     */
    public int getScore()
    {
        return score;
    }

    /**
     * Mutator Method to set the score of the player
     *
     * @param score An integer which contains the Score
     */
    public void setScore(int score)
    {
        this.score = score;
    }

    /**
     * Accessor method to access the tiles object
     *
     * @return the tiles object
     */
    public Tile[] getTiles()
    {
        return tiles;
    }

    /**
     *  Mutator Method to set the tiles array
     *
     * @param tiles A single object of the Tile Class
     */
    public void setTiles(Tile[] tiles)
    {
        this.tiles = tiles;
    }

    /**
     * Accessor method to get the lastTilePlayed object
     *
     * @return A single object of the Tile Class
     */
    public Tile getLastTilePlayed()
    {
        return lastTilePlayed;
    }

    /**
     * Mutator method to set the lastTilePlayed object
     *
     * @param lastTilePlayed A single object of the Tile Class
     */
    public void setLastTilePlayed(Tile lastTilePlayed)
    {
        this.lastTilePlayed = lastTilePlayed;
    }

    /**
     * Accessor Method to get the roundsWon of the player
     *
     * @return The number of rounds won by the player during the game.
     */
    public int getRoundsWon()
    {
        return roundsWon;
    }

    /**
     * Mutator method to set the roundsWon for the player
     *
     * @param roundsWon The number of rounds won by the player during the game.
     */
    public void setRoundsWon(int roundsWon)
    {
        this.roundsWon = roundsWon;
    }

    public void resetTiles()
    {
        Tile newTile;
        for (int index = 0; index < tiles.length; index++)
        {
            newTile = new Tile((index+1),indexAlgorithm(index));
            tiles[index] = newTile;
        }
    }

    /**
     * Method return correct value for a certain index.
     *
     * @param index the index 0 1 2 3 4
     * @return the correlated value for each index
     */
    public int indexAlgorithm(int index)
    {
        //1 2 3 5 7 (value)
        //5 4 3 2 1 (score)
        //4 3 2 1 0 (index)
        //5 5 5 6 7 （value + index) 0 0 1 1
        //-3 -1 1 4 7 (value - index) 2 2 3 3
        int indexToValue = 0;
        if (index >= 0 && index <= 2)
        indexToValue = 7 - 2*index;
        else if (index >= 3 && index <= 4)
        indexToValue = 5 - index;
        return indexToValue;
    }

    /**
     * Method to reset values for each rounds
     */
    public void roundsReset()
    {
        resetTiles();
        lastTilePlayed = new Tile();
        setScore(0);
    }

    /**
     * Method to display tile list
     * @return a string contains tile list
     */
    public String displayTileChoice()
    {
        String display = "";
        for (int i = 0; i < tiles.length; i++)
        {
            if (tiles[i] != null)
            display += tiles[i].getValue() + " ";
        }
        return display;
    }

    /**
     * Method to update score after tile choosed
     * @param tilePicked integer value of the tile player decide to pick
     */
    public void newScoreUpdate(int tilePicked)
    {
        for (Tile tile : tiles)
        {
            if (tile != null && tile.getValue() == tilePicked)
                score = tile.getScore() + score;
        }
    }

    /**
     * Method to delete the tile picked
     * @param tilePicked integer value of the tile player decide to pick
     */
    public void deletePickedTile(int tilePicked)
    {
        for (int i = 0; i < tiles.length; i++)
        {
            if (tiles[i] != null)
                if (tilePicked == tiles[i].getValue())
                {
                    tiles[i] = null;
                }
        }
    }
}
