import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.InputMismatchException;
import java.util.Scanner;

public class MissionToMarsSystem {
    public static void main(String[] args) {

        MissionToMarsSystem missionToMarsSystem = new MissionToMarsSystem();



        missionToMarsSystem.startProject();



    }

    public void startProject()
    {
        String indicator; //type of user
        boolean isPasswordCorrect; //check password correct or not
        //establish a mission database
        ArrayList<Mission> missionDatabase = new ArrayList<Mission>();

        String username = loginUserName();
        System.out.println("username entered: " + username);

        String password = loginUserPassword();
        System.out.println("password entered: " + password);
        System.out.println("Verifying your username and password, please wait...");
        indicator = determineUserType(username);
        isPasswordCorrect = checkPassword(username,password,indicator);

        if (indicator.equals("Coordinator") && isPasswordCorrect)
        {
            coordinatorOperation(missionDatabase);
        }else if(indicator.equals("Administrator") && isPasswordCorrect)
        {
            administratorOperation(missionDatabase);;
        }

    }




    public void administratorOperation(ArrayList<Mission> missionDatabase)
    {
        boolean switcher = true;
        while (switcher)
        {
            UserInterface.DisplayAdministrator();
            String menuChoice = acceptStringInput("Please select from the given options only");
            switcher = administratorSelectionResponder(menuChoice,missionDatabase);
        }

    }


    //你们往这里放东西
    private boolean administratorSelectionResponder(String option, ArrayList<Mission> missionDatabase)
    {
        String content;

        boolean flag = true;
        switch (option)
        {

            case "1":
                //你的方法和东西放这儿
                if (missionDatabase.size() == 0)
                {
                    System.out.println("we currently don't have any mission, you cannot edit an empty mission, try create a mission first");
                } else // we have at least 1 mission in our database
                {
                    System.out.println("we have" + missionDatabase.size() + "number of missions available");
                    System.out.println("you can choose number 1 to " + missionDatabase.size() + " to select the mission you want to edit");
                    String warning = "enter integer number 1 to " + missionDatabase.size();
                    int selected;
                    selected = acceptMoreThanOneInt(warning,missionDatabase.size());
                    editMission(missionDatabase.get(selected - 1));
                    content = collectEmploymentRequirementInfo(missionDatabase.get(selected -1));
                    writeToFile("src/missionRequirement.txt",content);

                }


                enterToContinue();
                flag = true;
                //refresh page
                System.out.print('\u000C');

                break;

            case "2":

                //选项2的东西放这
                System.out.println("asdasdasdasd");


                enterToContinue();
                flag = true;
                break;

            case "3":

                //选项3的东西放这

                System.out.println("asdasdd");

                enterToContinue();
                flag = true;
                break;

            case "4":

                //选项4的东西放这

                System.out.println("这个是4");

                flag = true;
                break;
            case "5":

                //选五出

                System.out.println("closing");
                enterToContinue();
                flag = false;
                break;

            default:
                System.out.println("Please enter a valid option");
                enterToContinue();
                flag = true;
        }
        return flag;
    }

    public void coordinatorOperation(ArrayList<Mission> missionDatabase)
    {

        boolean switcher = true;
        while (switcher)
        {
            UserInterface.DisplayCoordinatorPanel();
            String menuChoice = acceptStringInput("Please select from the given options only");
            switcher = coordinatorSelectionResponder(menuChoice, missionDatabase);
        }



    }

    public Mission createMission()
    {
        Job job = new Job();
        EmploymentRequirement employmentRequirement = new EmploymentRequirement();
        CargoRequirement cargoRequirement = new CargoRequirement();
        StatusOfMission statusOfMission = new StatusOfMission();
        Mission mission = new Mission();

        //mission attributes
        String missionName = acceptStringInput("please enter mission name");
        String missionDescription = acceptStringInput("please enter mission description");
        String countryOfOrigin = acceptStringInput("please enter country of origin");
        String countriesAllowed = acceptStringInput("please enter countries allowed");
        String coordinatorName = acceptStringInput("please enter coordinator name");
        String coordinatorContactInformation = acceptStringInput("please enter the coordinator contact information");
        String launchDate = acceptStringInput("please enter launch date");
        String locationOfTheDestination = acceptStringInput("please enter the destination");
        String durationOfTheMission = acceptStringInput("please enter the mission duration");
        //update the value in mission
        mission.setMissionName(missionName);
        mission.setMissionDescription(missionDescription);
        mission.setCountryOfOrigin(countryOfOrigin);
        mission.setCountriesAllowed(countriesAllowed);
        mission.setCoordinatorName(coordinatorName);
        mission.setCoordinatorContactInformation(coordinatorContactInformation);
        mission.setLaunchDate(launchDate);
        mission.setLocationOfTheDestination(locationOfTheDestination);
        mission.setDurationOfTheMission(durationOfTheMission);

        //job attributes
        String jobName = acceptStringInput("please enter job name");
        String jobDescription = acceptStringInput("please enter job description");
        //update job value and mission value
        job.setJobName(jobName);
        job.setJobDescription(jobDescription);
        mission.setJob(job);

        //Employ requirement attribute
        String title = acceptStringInput("please enter title");
        int numberOfEmployees = acceptIntInput("please enter employees number, enter integer only");
        //update employment requirement and mission value
        employmentRequirement.setTitle(title);
        employmentRequirement.setNumberOfEmployees(numberOfEmployees);
        mission.setEmploymentRequirement(employmentRequirement);

        //Cargo requirement attribute
        String journey = acceptStringInput("please enter cargo requirement for the journey");
        String cargoRequirementMission = acceptStringInput("please enter cargo requirement for the mission");
        String otherMissions = acceptStringInput("please enter cargo requirement for other missions");
        cargoRequirement.setJourney(journey);
        cargoRequirement.setMission(cargoRequirementMission);
        cargoRequirement.setOtherMissions(otherMissions);
        mission.setCargoRequirement(cargoRequirement);


        //Status of the mission attribute
        boolean planningPhase = acceptBooleanInput("Is it in planning phase? type true if yes, false if no");
        boolean departedEarth = acceptBooleanInput("Does it departed from earth? type true if yes, false if no");
        boolean landedOnMars = acceptBooleanInput("has it landed on Mars? type true if yes, false if no");
        boolean missionInProgress = acceptBooleanInput("is this mission in progress? type true if yes, false if no");
        boolean missionCompleted = acceptBooleanInput("is this mission completed? type true if yes, false if no");
        statusOfMission.setPlanningPhase(planningPhase);
        statusOfMission.setDepartedEarth(departedEarth);
        statusOfMission.setLandedOnMars(landedOnMars);
        statusOfMission.setMissionInProgress(missionInProgress);
        statusOfMission.setMissionCompleted(missionCompleted);
        mission.setStatusOfMission(statusOfMission);




        return mission;
    }

    public Mission editMission(Mission mission)
    {
        //mission attributes
        String missionName = acceptStringInput("please update mission name");
        String missionDescription = acceptStringInput("please update mission description");
        String countryOfOrigin = acceptStringInput("please update country of origin");
        String countriesAllowed = acceptStringInput("please update countries allowed");
        String coordinatorName = acceptStringInput("please update coordinator name");
        String coordinatorContactInformation = acceptStringInput("please update the coordinator contact information");
        String launchDate = acceptStringInput("please update launch date");
        String locationOfTheDestination = acceptStringInput("please update the destination");
        String durationOfTheMission = acceptStringInput("please update the mission duration");
        //update the value in mission
        mission.setMissionName(missionName);
        mission.setMissionDescription(missionDescription);
        mission.setCountryOfOrigin(countryOfOrigin);
        mission.setCountriesAllowed(countriesAllowed);
        mission.setCoordinatorName(coordinatorName);
        mission.setCoordinatorContactInformation(coordinatorContactInformation);
        mission.setLaunchDate(launchDate);
        mission.setLocationOfTheDestination(locationOfTheDestination);
        mission.setDurationOfTheMission(durationOfTheMission);

        //job attributes
        String jobName = acceptStringInput("please update job name");
        String jobDescription = acceptStringInput("please update job description");
        mission.getJob().setJobName(jobName);
        mission.getJob().setJobDescription(jobDescription);

        //Employ requirement attribute
        String title = acceptStringInput("please update title");
        int numberOfEmployees = acceptIntInput("please update employees number, enter integer only");
        mission.getEmploymentRequirement().setTitle(title);
        mission.getEmploymentRequirement().setNumberOfEmployees(numberOfEmployees);

        //Cargo requirement attribute
        String journey = acceptStringInput("please update cargo requirement for the journey");
        String cargoRequirementMission = acceptStringInput("please update cargo requirement for the mission");
        String otherMissions = acceptStringInput("please update cargo requirement for other missions");
        mission.getCargoRequirement().setJourney(journey);
        mission.getCargoRequirement().setMission(cargoRequirementMission);
        mission.getCargoRequirement().setOtherMissions(otherMissions);

        //Status of the mission attribute
        boolean planningPhase = acceptBooleanInput("Is it in planning phase? type true if yes, false if no");
        boolean departedEarth = acceptBooleanInput("Does it departed from earth? type true if yes, false if no");
        boolean landedOnMars = acceptBooleanInput("has it landed on Mars? type true if yes, false if no");
        boolean missionInProgress = acceptBooleanInput("is this mission in progress? type true if yes, false if no");
        boolean missionCompleted = acceptBooleanInput("is this mission completed? type true if yes, false if no");

        mission.getStatusOfMission().setPlanningPhase(planningPhase);
        mission.getStatusOfMission().setDepartedEarth(departedEarth);
        mission.getStatusOfMission().setLandedOnMars(landedOnMars);
        mission.getStatusOfMission().setMissionInProgress(missionInProgress);
        mission.getStatusOfMission().setMissionCompleted(missionCompleted);





        return mission;
    }

    public String collectEmploymentRequirementInfo(Mission mission)
    {
        String employeeTitles;
        int numberOfEmployeeRequired;
        String info;
        employeeTitles = mission.getEmploymentRequirement().getTitle();
        numberOfEmployeeRequired = mission.getEmploymentRequirement().getNumberOfEmployees();
        info = " for this mission we need " + employeeTitles + " and " + numberOfEmployeeRequired + " number of employees";
        return info;
    }

    public void writeToFile (String fileName, String fileContent) {
        try {
            PrintWriter outputFile = new PrintWriter(fileName);
            outputFile.println(fileContent);
            outputFile.close();
        }
        catch (IOException e){
            System.out.println("Unexpected I/O exception occurs");
        }
    }

    private boolean coordinatorSelectionResponder(String option, ArrayList<Mission> missionDatabase)
    {
        String content;


        boolean flag = true;
        switch (option)
        {

            case "1":
                //create new mission
                Mission mission = createMission();
                //write mission requirement to txt file
                content = collectEmploymentRequirementInfo(mission);
                writeToFile("src/missionRequirement.txt",content);
                System.out.println("mission created successfully");
                //add the newly created mission to database
                missionDatabase.add(mission);
                System.out.println("it is the " + missionDatabase.size() +"th mission created");
                enterToContinue();
                flag = true;
                //refresh page
                System.out.print('\u000C');

                break;

            case "2":

                if (missionDatabase.size() == 0)
                {
                    System.out.println("we currently don't have any mission, you cannot edit an empty mission, try create a mission first");
                } else // we have at least 1 mission in our database
                {
                    System.out.println("we have" + missionDatabase.size() + "number of missions available");
                    System.out.println("you can choose number 1 to " + missionDatabase.size() + " to select the mission you want to edit");
                    String warning = "enter integer number 1 to " + missionDatabase.size();
                    int selected;
                    selected = acceptMoreThanOneInt(warning,missionDatabase.size());
                    editMission(missionDatabase.get(selected - 1));
                    content = collectEmploymentRequirementInfo(missionDatabase.get(selected -1));
                    writeToFile("src/missionRequirement.txt",content);

                }


                flag = true;
                break;

            case "3":

                System.out.println("closing");
                enterToContinue();
                flag = false;
                break;

            default:
                System.out.println("Please enter a valid option");
                enterToContinue();
                flag = true;
        }
        return flag;
    }

    private int acceptMoreThanOneInt(String message, int max)
    {
        int acceptedValue = 0;
        boolean flag = true;
        while (flag)
        {
            acceptedValue = acceptIntInput(message);
            if (acceptedValue >= 1 && acceptedValue <= max)
            {
                flag = false;
            }

        }
        return acceptedValue;

    }

    private void enterToContinue()
    {
        System.out.print("Please press enter to continue");
        Scanner console = new Scanner(System.in);
        console.nextLine();
    }

    public String loginUserName()
    {
        System.out.println("Please Login using your userName and PassWord");
        System.out.println("Enter username: ");
        String username = generalInput();
        return username;
    }

    public String loginUserPassword()
    {
        System.out.println("Enter password: ");
        String password = generalInput();
        return password;
    }



    public boolean checkPassword (String username, String password, String indicator)
    {
        boolean isPasswordCorrect;
        String adm = "Administrator";
        String coordinator = "Coordinator";
        String candidate = "Candidate";
        ArrayList<String> typeList = new ArrayList<String>();
        HashMap<String, String> credentialSet = new HashMap<String, String>();


        //initialize the relevant database
        if (indicator.equals(adm))
        {
            typeList = readMultiples("src/Administrator.txt");
            credentialSet = extractUserCredentialInfo(typeList);


        } else if (indicator.equals(candidate))
        {
            typeList = readMultiples("src/Candidates.txt");
            credentialSet = extractUserCredentialInfo(typeList);

        } else if (indicator.equals(coordinator))
        {
            typeList = readMultiples("src/Coordinator.txt");
            credentialSet = extractUserCredentialInfo(typeList);
        }


        //compare password entered and true password
        String correctPwd = credentialSet.get(username);

        if (password.equals(correctPwd))
        {
            System.out.println("Password correct");
            isPasswordCorrect = true;
        } else
        {
            System.out.println("Password wrong");
            isPasswordCorrect = false;
        }

        return isPasswordCorrect;





    }

    public HashMap<String, String> extractUserCredentialInfo(ArrayList<String> multipleArray)
    {
        HashMap<String, String> CredentialPairs = new HashMap<String, String>();
        String[] lines;
        String key;
        String value;
        int length = multipleArray.size();
        for (int i = 0; i < length; i++)
        {
            lines = multipleArray.get(i).split(",");
            key = lines[0];
            value = lines[1];
            CredentialPairs.put(key,value);
        }
        return CredentialPairs;

    }




    public String determineUserType(String username)
    {
        String indicator;
        boolean isAdm = false;
        boolean isCandidate = false;
        boolean isCoordinator = false;

        //read 3 data sets
        ArrayList<String> administratorList = new ArrayList<String>();
        administratorList = readMultiples("src/Administrator.txt");
        ArrayList<String> candidateList = new ArrayList<String>();
        candidateList = readMultiples("src/Candidates.txt");
        ArrayList<String> coordinatorList = new ArrayList<String>();
        coordinatorList = readMultiples("src/Coordinator.txt");

        //extract username and password from data sets
        HashMap<String, String> CredentialAdm;
        CredentialAdm = extractUserCredentialInfo(administratorList);
        HashMap<String, String> CredentialCandi;
        CredentialCandi = extractUserCredentialInfo(candidateList);
        HashMap<String, String> CredentialCoordinator;
        CredentialCoordinator = extractUserCredentialInfo(coordinatorList);

        //check username exist or not
        isAdm = detectUsernameType(username,CredentialAdm);
        isCandidate = detectUsernameType(username,CredentialCandi);
        isCoordinator = detectUsernameType(username, CredentialCoordinator);

        //decide what kind of user it is
        if (isAdm)
        {
            System.out.println("It's an Administrator account");
            indicator = "Administrator";
            CredentialAdm.get(username);
        } else if (isCandidate)
        {
            System.out.println("It's an Candidate account");
            indicator = "Candidate";
        } else if (isCoordinator)
        {
            System.out.println("It's an Coordinator account");
            indicator = "Coordinator";
        } else
        {
            System.out.println("username doesn't exist");
            indicator = "Error";
        }


        return indicator;


    }



    public boolean detectUsernameType(String username, HashMap<String, String> credentialsPair)
    {
        boolean flag = false;
        for (String i: credentialsPair.keySet())
        {
            if (username.equals(i))
            {
                flag = true;
            }
        }

        return flag;
    }




    public ArrayList<String> readMultiples(String path)
    {
        ArrayList<String> differentMultiples = new ArrayList<>();
        try
        {
            FileReader file = new FileReader(path);
            try
            {
                Scanner scan = new Scanner(file);
                while (scan.hasNextLine())
                {
                    differentMultiples.add(scan.nextLine());
                }
            }
            finally
            {
                file.close();
            }
        }
        catch
        (FileNotFoundException e)
        {
            System.out.println("File not found");
        }
        catch (IOException e)
        {
            System.out.println("Unexpected I/O exception occurs");
        }
        return differentMultiples;
    }



    public String generalInput()
    {
        Scanner myObj = new Scanner(System.in);  // Create a Scanner object

        String input = myObj.nextLine();  // Read user input

        return input;
    }

    private int acceptIntInput(String message)
    {
        System.out.println(message);
        boolean flag = true;
        int input = 0;
        while(flag)
        {
            try
            {
                Scanner scan = new Scanner(System.in);
                input = scan.nextInt();
                flag = false;
            }
            catch (InputMismatchException e)
            {
                System.out.println("Please enter an integer");
            }
        }
        return input;
    }

    private boolean acceptBooleanInput(String message)
    {
        System.out.println(message);
        boolean flag = true;
        boolean inputConvert = true;

        while (flag)
        {
            try
            {
                Scanner scan = new Scanner(System.in);
                inputConvert = scan.nextBoolean();
                flag = false;
            }catch (InputMismatchException e)
            {
                System.out.println("please enter true if yes, enter false if no");
            }
        }
        return inputConvert;
    }

    public static String acceptStringInput(String displayMessage)

    {

        Scanner console = new Scanner(System.in);
        System.out.println(displayMessage);
        return console.nextLine();
    }
}
