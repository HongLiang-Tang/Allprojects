public class SpaceShuttle {
    private String name;
    private String manufacturingYear;
    private String fuelCapacity;
    private String travelSpeed;

    public SpaceShuttle(String name, String manufacturingYear, String fuelCapacity, String travelSpeed) {
        this.name = name;
        this.manufacturingYear = manufacturingYear;
        this.fuelCapacity = fuelCapacity;
        this.travelSpeed = travelSpeed;
    }

    public SpaceShuttle() {
    }


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getManufacturingYear() {
        return manufacturingYear;
    }

    public void setManufacturingYear(String manufacturingYear) {
        this.manufacturingYear = manufacturingYear;
    }

    public String getFuelCapacity() {
        return fuelCapacity;
    }

    public void setFuelCapacity(String fuelCapacity) {
        this.fuelCapacity = fuelCapacity;
    }

    public String getTravelSpeed() {
        return travelSpeed;
    }

    public void setTravelSpeed(String travelSpeed) {
        this.travelSpeed = travelSpeed;
    }
}
