package webapp;

import com.google.code.morphia.annotations.Embedded;

/*
 * Holds data for a single funding round
 */
@Embedded
public class Investment {
	public static enum InvestorType {
		COMPANY, PERSON, FINANCIAL_ORG, NONE
	}
	
	private String _roundCode;
	private double _investmentAmount;
	private int _year;
	private String _company;

	public Investment() {
	}
	
	public String getRoundCode() { return _roundCode; }
	protected void setRoundCode(String roundCode) { _roundCode = roundCode; }
	
	public double getInvestmentAmount() { return _investmentAmount; }
	protected void setInvestmentAmount(double investment) { _investmentAmount = investment; }
	
	public int getYear() {return _year; }
	public void setYear(int year) {_year = year;}
	
	public String getCompany() {return _company;}
	public void setCompany(String company) {_company = company;}
	
	
}
