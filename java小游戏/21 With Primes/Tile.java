 

/**
 * The tile class will store each individual tile which can be used by the player to play the game
 *
 * @author Hongliang Tang
 * @version 1.0 (31.August.2019)
 */
public class Tile
{
    //fields below
    private int score;
    private int value;

    /**
     * non-default constructor for Tile
     *
     * @param score the score gained by the player from playing that tile during a round
     * @param value the face value of the tile which is used to calculate the round total while playing the game
     */
    public Tile(int score, int value)
    {
        this.score = score;
        this.value = value;
    }

    /**
     * default constructor for Tile
     */
    public Tile()
    {
        score = 0;
        value = 0;
    }

    /**
     * Accessor Method to get the score of the tile
     *
     * @return the score gained by the player from playing that tile during a round.
     */
    public int getScore()
    {
        return score;
    }

    /**
     * Mutator Method to set the score of the tile
     *
     * @param score the score gained by the player from playing that tile during a round.
     */
    public void setScore(int score)
    {
        this.score = score;
    }

    /**
     * Accessor Method to get the value of the tile
     *
     * @return the face value of the tile which is used to calculate the round total while playing the game.
     */
    public int getValue()
    {
        return value;
    }

    /**
     * Mutator Method to set the value of the tile
     *
     * @param value the face value of the tile which is used to calculate the round total while playing the game.
     */
    public void setValue(int value)
    {
        this.value = value;
    }
}
