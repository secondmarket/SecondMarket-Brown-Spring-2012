package webapp;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.google.code.morphia.annotations.Embedded;

/*
 * Holds data for a single funding round
 */
@Embedded
public class FundingRound {
	public static enum InvestorType {
		COMPANY, PERSON, FINANCIAL_ORG, NONE
	}
	
	private String _roundCode;
	private double _raisedAmount;
	private int _year;
	private List<InvestorType> _investorTypes;
	private List<String> _investorPermalinks;

	public FundingRound() {
		_investorTypes = new ArrayList<InvestorType>();
		_investorPermalinks = new ArrayList<String>();
	}
	
	public String getRoundCode() { return _roundCode; }
	protected void setRoundCode(String roundCode) { _roundCode = roundCode; }
	
	public double getRaisedAmount() { return _raisedAmount; }
	protected void setRaisedAmount(double raisedAmount) { _raisedAmount = raisedAmount; }

	public int getYear() { return _year; }
	protected void setYear(int year) { _year = year; }
	
	public List<InvestorType> getInvestorTypes() { return _investorTypes; }
	
	public List<String> getInvestorPermalinks() { return _investorPermalinks; }
	protected void setInvestorPermalinks(List<Map<String, Map<String, Object>>> investors) { 
		for (Map<String, Map<String, Object>> i : investors) {
			Map<String, Object> investor;
			InvestorType investorType;
			// investors always have company, financial_org and person fields
			if (i.get("company") != null) {
				investor = i.get("company");
				investorType = InvestorType.COMPANY;
			} else if (i.get("financial_org") != null) {
				investor = i.get("financial_org");
				investorType = InvestorType.FINANCIAL_ORG;
			} else if (i.get("person") != null) {
				investor = i.get("person");
				investorType = InvestorType.PERSON;
			} else {
				// Empty investor data, don't throw exception in case of bad data
				investor = null;
				investorType = InvestorType.NONE;
			}

			String investorPermalink;
			if (investor != null && investor.containsKey("permalink")) {
				investorPermalink = (String) investor.get("permalink");
			} else {
				investorPermalink = null;
				investorType = InvestorType.NONE;
			}
			
			// insert into list of investors
			if (investorType != InvestorType.NONE) {
				_investorTypes.add(investorType);
				_investorPermalinks.add(investorPermalink);
			}
		}
	}
}
