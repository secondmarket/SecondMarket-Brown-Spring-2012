package webapp;

import com.google.code.morphia.annotations.Embedded;

/*
 * Holds data for a single funding round
 */
@Embedded
public class FundingRound {	
	private double _raisedAmount;
	private String _roundCode;
	
	public double getRaisedAmount() { return _raisedAmount; }
	protected void setRaisedAmount(double raisedAmount) { _raisedAmount = raisedAmount; }

	public String getRoundCode() { return _roundCode; }
	protected void setRoundCode(String roundCode) { _roundCode = roundCode; }
}
