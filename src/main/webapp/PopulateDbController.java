package webapp;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonParseException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

/*
 * Populates the database
 */
public class PopulateDbController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
    private CompanyDAO _companyDao;
    private boolean _gettingData;
    
    public PopulateDbController(CompanyDAO companyDao) {
    	_companyDao = companyDao;
    	_gettingData = false;
    }
	
    // Parse data using the CrunchBase API and save it to the DB
    public void saveCrunchbaseDataToDb() {
    	CrunchBaseParser p = new CrunchBaseParser();
    	try {
    		// List<Company> companies = p.getAllCompanies();
    		List<Company> companies = p.getCompanies(200);
    		for (int i = 0; i < companies.size(); ++i) {
    			_companyDao.save(companies.get(i));
    		}
    	} catch (JsonParseException e) {
    		_logger.error("Failed to save CrunchBase data to db: JsonParseException");
    		e.printStackTrace();
    	} catch (IOException e) {
    		_logger.error("Failed to save CrunchBase data to db: IOException");
			e.printStackTrace();
		}
    }

	public ModelAndView handleRequest(HttpServletRequest arg0,
			HttpServletResponse arg1) throws Exception {
		// make sure database wasn't already populated
		if (!_gettingData && _companyDao.count() == 0) {
			_gettingData = true;
			saveCrunchbaseDataToDb();
		}
		return new ModelAndView("hello");
	}
    
    

}
