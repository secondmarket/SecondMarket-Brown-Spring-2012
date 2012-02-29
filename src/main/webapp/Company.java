package webapp;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.LogFactory;
import org.bson.types.ObjectId;

import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;

/*
 * Holds data for a single company
 */
@Entity
public class Company {
	@Id ObjectId _id;
	private String _name, _homepageUrl, _blogUrl;
	private int _numEmployees;
	private String _overview;
	private String _imageUrl;
	private double _totalMoneyRaised;
	private List<FundingRound> _fundingRounds;

	public String getName() { return _name; }
	protected void setName(String name) { _name = name; }

	public String getHomepageUrl() { return _homepageUrl; }
	protected void setHomepageUrl(String url) { _homepageUrl = url; }

	public String getBlogUrl() { return _blogUrl; }
	protected void setBlogUrl(String url) { _blogUrl = url; }

	public String getOverview() { return _overview; }
	protected void setOverview(String overview) { _overview = overview; }
	
	public int getNumEmployees() { return _numEmployees; }
	protected void setNumEmployees(int n) { _numEmployees = n; }
		
	public String getImageUrl() { return _imageUrl; }
	public void setImageUrl(Map<String, List<List<Object>>> json) {
		List<List<Object>> l = json.get("available_sizes");
		if (l == null || l.size() == 0) {
			_imageUrl = null;
		} else {
			_imageUrl = (String) l.get(0).get(1);
		}
	}
		
	public double getTotalMoneyRaised() { return _totalMoneyRaised; }
	protected void setTotalMoneyRaised(String totalMoney) {
		int len = totalMoney.length();
		char type = totalMoney.charAt(len - 1);
		double mult = 1;
		if (type == 'M') {
			mult = 1e6;
			totalMoney = totalMoney.substring(1, len - 1); // Ignore dollar sign and type
		} else if (type == 'B') {
			mult = 1e9;
			totalMoney = totalMoney.substring(1, len - 1); // Ignore dollar sign and type
		} else {
			totalMoney = totalMoney.substring(1, len); // Ignore dollar sign and type
		}

		switch (type) {
		case 'B':
			mult = 1e9;
			break;
		case 'M':
		default:
			mult = 1e6;
			break;			
		}
		_totalMoneyRaised = Double.parseDouble(totalMoney) * mult;
	}
	
	public List<FundingRound> getFundingRounds() { return _fundingRounds; }
	protected void setFundingRounds(List<FundingRound> rounds) { _fundingRounds = rounds; }
}
