package webapp;

import java.util.List;

import org.bson.types.ObjectId;

import com.google.code.morphia.annotations.Embedded;
import com.google.code.morphia.annotations.Entity;
import com.google.code.morphia.annotations.Id;
import com.google.code.morphia.annotations.Indexed;

/*
 * Holds data for a single company
 */
@Entity("FinancialOrg")
public class FinancialOrg {
	@Id ObjectId _id;
	//private String _name;
	@Indexed
	private String _permalink;
	
	@Embedded
	private List<Investment> _investments;

	public FinancialOrg() {
		_id = new ObjectId();
	}
		
	//public String getName() { return _name; }
	//protected void setName(String name) { _name = name; }

	public String getPermalink() { return _permalink; }
	public void setPermalink(String permalink) { _permalink = permalink; }
	
	public List<Investment> getInvestments() { return _investments; }
	public void setInvestments(List<Investment> investments) { _investments = investments; }
}
