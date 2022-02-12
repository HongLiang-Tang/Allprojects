public class Mission
{
    private String missionName;
    private String missionDescription;
    private String countryOfOrigin;
    private String countriesAllowed;
    private String coordinatorName;
    private String coordinatorContactInformation;
    private String launchDate;
    private String locationOfTheDestination;
    private String DurationOfTheMission;
    private CargoRequirement cargoRequirement;
    private StatusOfMission statusOfMission;
    private Job job;
    private EmploymentRequirement employmentRequirement;


    public Mission() {
    }

    public Mission(String missionName, String missionDescription, String countryOfOrigin, String countriesAllowed, String coordinatorName, String coordinatorContactInformation, String launchDate, String locationOfTheDestination, String durationOfTheMission, CargoRequirement cargoRequirement, StatusOfMission statusOfMission, Job job, EmploymentRequirement employmentRequirement) {
        this.missionName = missionName;
        this.missionDescription = missionDescription;
        this.countryOfOrigin = countryOfOrigin;
        this.countriesAllowed = countriesAllowed;
        this.coordinatorName = coordinatorName;
        this.coordinatorContactInformation = coordinatorContactInformation;
        this.launchDate = launchDate;
        this.locationOfTheDestination = locationOfTheDestination;
        DurationOfTheMission = durationOfTheMission;
        this.cargoRequirement = cargoRequirement;
        this.statusOfMission = statusOfMission;
        this.job = job;
        this.employmentRequirement = employmentRequirement;
    }


    public String getMissionName() {
        return missionName;
    }

    public void setMissionName(String missionName) {
        this.missionName = missionName;
    }

    public String getMissionDescription() {
        return missionDescription;
    }

    public void setMissionDescription(String missionDescription) {
        this.missionDescription = missionDescription;
    }

    public String getCountryOfOrigin() {
        return countryOfOrigin;
    }

    public void setCountryOfOrigin(String countryOfOrigin) {
        this.countryOfOrigin = countryOfOrigin;
    }

    public String getCountriesAllowed() {
        return countriesAllowed;
    }

    public void setCountriesAllowed(String countriesAllowed) {
        this.countriesAllowed = countriesAllowed;
    }

    public String getCoordinatorName() {
        return coordinatorName;
    }

    public void setCoordinatorName(String coordinatorName) {
        this.coordinatorName = coordinatorName;
    }

    public String getCoordinatorContactInformation() {
        return coordinatorContactInformation;
    }

    public void setCoordinatorContactInformation(String coordinatorContactInformation) {
        this.coordinatorContactInformation = coordinatorContactInformation;
    }

    public String getLaunchDate() {
        return launchDate;
    }

    public void setLaunchDate(String launchDate) {
        this.launchDate = launchDate;
    }

    public String getLocationOfTheDestination() {
        return locationOfTheDestination;
    }

    public void setLocationOfTheDestination(String locationOfTheDestination) {
        this.locationOfTheDestination = locationOfTheDestination;
    }

    public String getDurationOfTheMission() {
        return DurationOfTheMission;
    }

    public void setDurationOfTheMission(String durationOfTheMission) {
        DurationOfTheMission = durationOfTheMission;
    }

    public CargoRequirement getCargoRequirement() {
        return cargoRequirement;
    }

    public void setCargoRequirement(CargoRequirement cargoRequirement) {
        this.cargoRequirement = cargoRequirement;
    }

    public StatusOfMission getStatusOfMission() {
        return statusOfMission;
    }

    public void setStatusOfMission(StatusOfMission statusOfMission) {
        this.statusOfMission = statusOfMission;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }

    public EmploymentRequirement getEmploymentRequirement() {
        return employmentRequirement;
    }

    public void setEmploymentRequirement(EmploymentRequirement employmentRequirement) {
        this.employmentRequirement = employmentRequirement;
    }
}
