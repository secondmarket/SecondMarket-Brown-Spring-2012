package webapp;

import org.codehaus.jackson.annotate.JsonProperty;

public abstract class FundingRoundMixIn extends FundingRound {
	@JsonProperty("raised_amount") public abstract double getRaisedAmount();
	@JsonProperty("round_code") public abstract String getRoundCode();
	
	@JsonProperty("raised_amount") protected abstract void setRaisedAmount(double raisedAmount);
	@JsonProperty("round_code") protected abstract void setRoundCode(String roundCode);
}
