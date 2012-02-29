package webapp;

import org.bson.types.ObjectId;

import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;

/*
 * Holds data for a single funding round
 */
@Entity
public class FundingRound {
	@Id ObjectId _id;
	
	private double _raisedAmount;
	private String _roundCode;
	
	public double getRaisedAmount() { return _raisedAmount; }
	protected void setRaisedAmount(double raisedAmount) { _raisedAmount = raisedAmount; }

	public String getRoundCode() { return _roundCode; }
	protected void setRoundCode(String roundCode) { _roundCode = roundCode; }
}
