/**
 * An object of the RNG class will generate a random number from a minimum value to a maximum value
 *
 * @author Hongliang Tang
 * @version 1.0 (15.October.2019)
 */
public class RNG
{
    //fields below
    private int maximumValue;
    private int minimumValue;

    /**
     * default constructor for RNG Class
     */
    public RNG()
    {
        maximumValue = 0;
        minimumValue = 0;
    }

    /**
     * non-default constructor for RNG Class
     *
     * @param maximumValue maximum value of the random number
     * @param minimumValue minimum value of the random number
     */
    public RNG(int maximumValue, int minimumValue)
    {
        this.maximumValue = maximumValue;
        this.minimumValue = minimumValue;
    }

    public int randomNumberGenerator()
    {
        //algorithm, random value starts from minimumValue and arrive at the max value
        //1*(max-min+1)+min = max -min +1 +min = max + 1, I use max +1 to include max in the random outcome.
        //0*......+minimumValue to ensure minimumValue is the actual minimum random outcome.
        int randomOutcome = (int)(Math.random() * ((maximumValue - minimumValue)+1) + minimumValue);
        return randomOutcome;
    }

    /**
     * Accessor Method to return maximum value
     *
     * @return maximum value
     */
    public int getMaximumValue()
    {
        return maximumValue;
    }

    /**
     * Mutator Method to set maximum value
     *
     * @param maximumValue An integer which contains maximum value
     */
    public void setMaximumValue(int maximumValue)
    {
        this.maximumValue = maximumValue;
    }

    /**
     * Accessor Method to return minimum value
     *
     * @return the minimum value
     */
    public int getMinimumValue()
    {
        return minimumValue;
    }

    /**
     * Mutator Method to set minimum value
     *
     * @param minimumValue An integer which contains minimum value
     */
    public void setMinimumValue(int minimumValue)
    {
        this.minimumValue = minimumValue;
    }


}
