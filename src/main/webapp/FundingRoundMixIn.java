package webapp;

import java.util.List;
import java.util.Map;

import org.codehaus.jackson.annotate.JsonProperty;

public abstract class FundingRoundMixIn extends FundingRound {
	@JsonProperty("raised_amount") public abstract double getRaisedAmount();
	@JsonProperty("round_code") public abstract String getRoundCode();
	@JsonProperty("funded_year") public abstract int getYear();
	@JsonProperty("investorTypes") public abstract List<InvestorType> getInvestorTypes();
	@JsonProperty("investments") public abstract List<String> getInvestorPermalinks();
	
	@JsonProperty("raised_amount") protected abstract void setRaisedAmount(double raisedAmount);
	@JsonProperty("round_code") protected abstract void setRoundCode(String roundCode);
	@JsonProperty("funded_year") protected abstract void setYear(int year);
	@JsonProperty("investments") protected abstract void setInvestorPermalinks(List<Map<String, Map<String, Object>>> investors);
}
