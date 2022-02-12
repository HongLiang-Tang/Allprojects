public class Coordinator extends User{

    private boolean isReceived;


    public Coordinator(String userName, String userPassWord, int userID, boolean isReceived, String userContactNumber) {
        super(userName,userPassWord,userID,userContactNumber);
        this.isReceived = isReceived;

    }

    public boolean isReceived() {
        return isReceived;
    }

    public void setReceived(boolean received) {
        isReceived = received;
    }
}
