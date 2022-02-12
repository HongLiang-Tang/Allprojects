public class User {
    private String userName;
    private String userPassWord;
    private int userID;
    private String userContactNumber;

    public User() {
    }

    public User(String userName, String userPassWord, int userID, String userContactNumber) {
        this.userName = userName;
        this.userPassWord = userPassWord;
        this.userID = userID;
        this.userContactNumber = userContactNumber;
    }


    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPassWord() {
        return userPassWord;
    }

    public void setUserPassWord(String userPassWord) {
        this.userPassWord = userPassWord;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUserContactNumber() {
        return userContactNumber;
    }

    public void setUserContactNumber(String userContactNumber) {
        this.userContactNumber = userContactNumber;
    }
}
