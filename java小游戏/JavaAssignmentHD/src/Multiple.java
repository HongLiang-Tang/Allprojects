public class Multiple
{
    private int value;

    /**
     * default constructor
     */
    public Multiple()
    {
        value = 1;
    }

    /**
     * non-default constructor
     * @param value integer value for variable value
     */
    public Multiple(int value) {
        this.value = value;
    }

    /**
     * accessor method for value
     * @return integer value
     */
    public int getValue()
    {
        return value;
    }

    /**
     * mutator method for value
     * @param value the integer value
     */
    public void setValue(int value)
    {
        this.value = value;
    }
}
