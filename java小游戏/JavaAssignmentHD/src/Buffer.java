import java.util.ArrayList;

public class Buffer {
    //fields
    private ArrayList<Multiple> list;
    private int maxElements;

    /**
     * non-default constructor
     * @param list the object of the ArrayList of the Multiple class type
     * @param maxElements an integer variable
     */
    public Buffer(ArrayList<Multiple> list, int maxElements)
    {
        // [num1,num2,num3,num4,num5]
        this.list = list;
        this.maxElements = maxElements;
    }

    /**
     * Default constructor
     */
    public Buffer()
    {
        maxElements = 5;
        list = new ArrayList<>();
    }

    /**
     * accessor method for list.
     * @return return An ArrayList object of type Multiple
     */
    public ArrayList<Multiple> getList()
    {
        return list;
    }

    /**
     * accessor method for maxElements
     * @return return an integer value
     */
    public int getMaxElements()
    {
        return maxElements;
    }

    /**
     * mutator method to set the list
     * @param list the object of the ArrayList of the Multiple class type
     */
    public void setList(ArrayList<Multiple> list)
    {
        this.list = list;
    }

    /**
     * mutator method to set the maxElements
     * @param maxElements an integer variable
     */
    public void setMaxElements(int maxElements)
    {
        this.maxElements = maxElements;
    }

    public String displayBuffer()
    {
        String output = "";
        StringBuffer buffer = new StringBuffer();
        for ( int i = 0; i < maxElements; i++)
        {
            if (i < list.size())
                buffer.append(list.get(i).getValue() + " .");
            output = buffer.toString();
            output = "This Buffer has a maximum of " + maxElements + "elements"
                    + "Buffer Elements: " + "{ " + output + " }";
        }
        return output;
    }

    public boolean split(int gameTotal)
    {
        boolean flag;
        if (list.size() < maxElements)
        {
            Multiple multiple = new Multiple(gameTotal);
            list.add(multiple);
            flag = true;
        }
        else
            flag = false;
        return flag;
    }

    public boolean merge(int gameTotal)
    {
        boolean isSuccessful = false;
        for (Multiple listEach : list)
        {
            if (listEach.getValue() == gameTotal)
            {
                list.remove(listEach);
                isSuccessful = true;
                break;
            }
        }
        return isSuccessful;
    }

    public boolean mergePossible(int gameTotal)
    {
        boolean isSuccessful = false;
        for (Multiple listEach : list)
        {
            if (listEach.getValue() == gameTotal)
            {
                isSuccessful = true;
                break;
            }
        }
        return isSuccessful;
    }

    public int findLargestMultiple(int gameTotal)
    {
        int maxValue = 0;
        for (Multiple multiple: list)
        {
            if (multiple.getValue() > maxValue)
                maxValue = multiple.getValue();
        }

        if (maxValue > gameTotal)
            return maxValue;
        else
            return gameTotal;
    }








}
