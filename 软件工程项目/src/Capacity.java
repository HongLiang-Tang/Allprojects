public class Capacity {
    private String payLoadCapacity;
    private String passengerCapacity;
    private String cargoCapacity;

    public Capacity(String payLoadCapacity, String passengerCapacity, String cargoCapacity) {
        this.payLoadCapacity = payLoadCapacity;
        this.passengerCapacity = passengerCapacity;
        this.cargoCapacity = cargoCapacity;
    }

    public Capacity() {
    }


    public String getPayLoadCapacity() {
        return payLoadCapacity;
    }

    public void setPayLoadCapacity(String payLoadCapacity) {
        this.payLoadCapacity = payLoadCapacity;
    }

    public String getPassengerCapacity() {
        return passengerCapacity;
    }

    public void setPassengerCapacity(String passengerCapacity) {
        this.passengerCapacity = passengerCapacity;
    }

    public String getCargoCapacity() {
        return cargoCapacity;
    }

    public void setCargoCapacity(String cargoCapacity) {
        this.cargoCapacity = cargoCapacity;
    }
}
