package webapp;

import java.net.UnknownHostException;
import java.util.List;


import junit.framework.TestCase;

import com.google.code.morphia.Morphia;
import com.mongodb.Mongo;
import com.mongodb.MongoException;

/**
 * Tests checking that DB connection works and stored company data is valid
 *
 */
public class CompanyDataValidityTest extends TestCase {
	
	public static final String dbName = "CompanyDb";
	
	private Mongo _mongo;
	private List<Company> _companies;
	
	@Override
	protected void setUp() {
		try {
			_mongo = new Mongo();
		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (MongoException e) {
			e.printStackTrace();
		}
		Morphia morphia = new Morphia();
		CompanyDAO companyDao = new CompanyDAO(morphia, _mongo, dbName);
		_companies = companyDao.find().asList();
	}
	
	public void testNonEmpty() {
		assertTrue("Company database is empty!", _companies.size() > 0);
	}
	
	public void testCompanyValidity() {
		for (Company c : _companies) {
			assertNotNull(c.getPermalink());
			assertNotNull(c.getName());
			assertTrue("Company with $0 total funding found in DB: " + c.getPermalink(), c.getTotalMoneyRaised() > 0);
		}
	}
	
	public void testFundingRoundValidity() {
		for (Company c : _companies) {
			assertNotNull(c.getPermalink());
			List<FundingRound> rounds = c.getFundingRounds();
			assertNotNull(rounds);
			assertTrue("Company with no funding rounds found in DB: " + c.getPermalink(), rounds.size() > 0);

			for (FundingRound round : rounds) {
				if (round.getRaisedAmount() == 0) continue; // these are ignored anyway

				assertNotNull(round.getRoundCode());
				// if year is null in the json data, it's saved as 0 or 1000
				assertTrue("Invalid year in funding round found in DB: " + c.getPermalink(), 
							round.getYear() == 0 || round.getYear() == 1000 || 
							(round.getYear() > 1900 && round.getYear() < 2100));
				assertTrue("Funding round with negative money raised found in DB: " + c.getPermalink(), 
							round.getRaisedAmount() >= 0);
				assertNotNull(round.getInvestorPermalinks());
				assertNotNull(round.getInvestorTypes());
				assertTrue(round.getInvestorPermalinks().size() == round.getInvestorTypes().size());
			}
		}
	}
	
	@Override
	protected void tearDown() {
		_mongo.close();
	}
}
