public class StatusOfMission
{
    private boolean planningPhase;
    private boolean departedEarth;
    private boolean landedOnMars;
    private boolean missionInProgress;
    private boolean returnedToEarth;
    private boolean missionCompleted;

    public StatusOfMission(boolean planningPhase, boolean departedEarth, boolean landedOnMars, boolean missionInProgress, boolean returnedToEarth, boolean missionCompleted) {
        this.planningPhase = planningPhase;
        this.departedEarth = departedEarth;
        this.landedOnMars = landedOnMars;
        this.missionInProgress = missionInProgress;
        this.returnedToEarth = returnedToEarth;
        this.missionCompleted = missionCompleted;
    }

    public StatusOfMission() {
    }

    public boolean isPlanningPhase() {
        return planningPhase;
    }

    public void setPlanningPhase(boolean planningPhase) {
        this.planningPhase = planningPhase;
    }

    public boolean isDepartedEarth() {
        return departedEarth;
    }

    public void setDepartedEarth(boolean departedEarth) {
        this.departedEarth = departedEarth;
    }

    public boolean isLandedOnMars() {
        return landedOnMars;
    }

    public void setLandedOnMars(boolean landedOnMars) {
        this.landedOnMars = landedOnMars;
    }

    public boolean isMissionInProgress() {
        return missionInProgress;
    }

    public void setMissionInProgress(boolean missionInProgress) {
        this.missionInProgress = missionInProgress;
    }

    public boolean isReturnedToEarth() {
        return returnedToEarth;
    }

    public void setReturnedToEarth(boolean returnedToEarth) {
        this.returnedToEarth = returnedToEarth;
    }

    public boolean isMissionCompleted() {
        return missionCompleted;
    }

    public void setMissionCompleted(boolean missionCompleted) {
        this.missionCompleted = missionCompleted;
    }
}
