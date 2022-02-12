public class Administrator extends User{


    private boolean isSent;


    public Administrator() {
    }

    public Administrator(String userName, String userPassWord, int userID, boolean isSent, String userContactNumber) {
        super(userName,userPassWord,userID,userContactNumber);
        this.isSent = isSent;

    }

    public boolean isSent() {
        return isSent;
    }

    public void setSent(boolean sent) {
        isSent = sent;
    }
}
