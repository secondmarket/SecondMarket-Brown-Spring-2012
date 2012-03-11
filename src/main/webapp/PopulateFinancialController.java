package webapp;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/*
 * Populates the database
 */
public class PopulateFinancialController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
    private FinancialOrgDAO _financialDao;
    private CompanyDAO _companyDao;
    private boolean _gettingData;
    
    public PopulateFinancialController(FinancialOrgDAO financialDao, CompanyDAO companyDao) {
    	_financialDao = financialDao;
    	_companyDao = companyDao;
    	_gettingData = false;
    }
	
    // Calculate Financial Org Data From Funding Rounds and Populate Db
    public void saveFinancialDataToDb() {
    	List<Company> companies = _companyDao.find().asList();
    	
    	for(Company c : companies){
    		String name = c.getName();
    		for(FundingRound fr : c.getFundingRounds()){
    			List<FundingRound.InvestorType> invtypes = fr.getInvestorTypes();
    			List<String> invperma = fr.getInvestorPermalinks();
    			int year = fr.getYear();
    			
    			for(int i=0;i<invperma.size();i++){
    				String s = invperma.get(i);
    				if(invtypes.get(i)==FundingRound.InvestorType.FINANCIAL_ORG){
    					FinancialOrg fo = _financialDao.findByPermalink(s);
    					if(fo==null){
    						fo = new FinancialOrg();
    						fo.setPermalink(s);
    						List<Investment> invs = new ArrayList<Investment>();
    						Investment inv = new Investment();
    						inv.setCompany(name);
    						inv.setYear(year);
    						inv.setRoundCode(fr.getRoundCode());
    						inv.setInvestmentAmount((fr.getRaisedAmount()/invperma.size()));
    						invs.add(inv);
    						fo.setInvestments(invs);
    						_financialDao.save(fo);
    					}
    					else{
    						List<Investment> invs = fo.getInvestments();
    						Investment inv = new Investment();
    						inv.setCompany(name);
    						inv.setYear(year);
    						inv.setRoundCode(fr.getRoundCode());
    						inv.setInvestmentAmount((fr.getRaisedAmount()/invperma.size()));
    						invs.add(inv);
    						fo.setInvestments(invs);
    						_financialDao.save(fo);
    						
    					}
    				}
    			}
    			
    		}
    	}
    }

	public ModelAndView handleRequest(HttpServletRequest arg0,
			HttpServletResponse arg1) throws Exception {
		// make sure database wasn't already populated
		if (!_gettingData) {
			_gettingData = true;
			saveFinancialDataToDb();
		}
		return new ModelAndView("hello");
	}
    
    
}
