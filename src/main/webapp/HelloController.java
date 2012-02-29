package webapp;

import org.springframework.web.servlet.mvc.Controller;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonParseException;

import java.io.IOException;
import java.util.List;

public class HelloController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
    private CompanyDAO _companyDao;
    
    public HelloController(CompanyDAO companyDao) {
    	_companyDao = companyDao;
    	
    	// TODO: Move this somewhere that makes more sense
    	//if (_companyDao != null) {
    	//	saveCrunchbaseDataToDb();
    	//}
    }
    
    // TODO: Move this somewhere that makes more sense
    public void saveCrunchbaseDataToDb() {
    	CrunchBaseParser p = new CrunchBaseParser();
    	try {
    		List<Company> companies = p.getAllCompanies();
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
    
    // TODO: Move this somewhere that makes more sense
    
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    			
        _logger.info("Returning index view");
        
        return new ModelAndView("hello", "now", "sleep o clock");
    }
}