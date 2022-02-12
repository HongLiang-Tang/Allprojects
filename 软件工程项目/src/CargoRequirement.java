public class CargoRequirement
{
    private String journey;
    private String mission;
    private String otherMissions;

    public CargoRequirement(String journey, String mission, String otherMissions) {
        this.journey = journey;
        this.mission = mission;
        this.otherMissions = otherMissions;
    }

    public CargoRequirement() {
    }


    public String getJourney() {
        return journey;
    }

    public void setJourney(String journey) {
        this.journey = journey;
    }

    public String getMission() {
        return mission;
    }

    public void setMission(String mission) {
        this.mission = mission;
    }

    public String getOtherMissions() {
        return otherMissions;
    }

    public void setOtherMissions(String otherMissions) {
        this.otherMissions = otherMissions;
    }
}
