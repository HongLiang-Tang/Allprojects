public class EmploymentRequirement
{
    private String title;
    private int numberOfEmployees;

    public EmploymentRequirement(String title, int numberOfEmployees) {
        this.title = title;
        this.numberOfEmployees = numberOfEmployees;
    }

    public EmploymentRequirement() {
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getNumberOfEmployees() {
        return numberOfEmployees;
    }

    public void setNumberOfEmployees(int numberOfEmployees) {
        this.numberOfEmployees = numberOfEmployees;
    }
}
