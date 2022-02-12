import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class FileIO
{
    private String fileName;

    /**
     * Default constructor to initialize the object of the FileIO class
     *
     */
    public FileIO()
    {
        fileName = "";
    }

    /**
     * Non default constructor to initialize the object of the FileIO class
     *
     * @param newFileName Name of the file to be read or written to
     */
    public FileIO(String newFileName)
    {
        fileName = newFileName;
    }

    /**
     * Accessor Method to get the filename
     *
     * @return A single string which represents the file name being read or written to
     */
    public String getFileName()
    {
        return fileName;

    }

    public ArrayList<String> readFile()
            throws IOException
    {
        FileReader fileContent = new FileReader(fileName);
        ArrayList<String> multiplesBuffer = new ArrayList<>();
        Scanner scan = new Scanner(fileContent);
        while (scan.hasNextLine())
        {
            String content = scan.nextLine();
            multiplesBuffer.add(content);
        }
        fileContent.close();
        return multiplesBuffer;
    }
//
//    public String[] getMultipleArray()
//            throws IOException
//    {
//        String content = readMultiples();
//        String[] multiplesArray = content.split(",");
//        return multiplesArray;
//    }




}
