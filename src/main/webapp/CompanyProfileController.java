package webapp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class CompanyProfileController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
	private CompanyDAO _companyDao;
	
	CompanyProfileController(CompanyDAO companyDao) {
		_companyDao = companyDao;
	}
	
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String companyName = request.getServletPath().substring("/companies/".length());
		companyName = companyName.substring(0, companyName.indexOf('.'));
		_logger.info("Returning profile for " + companyName);
		Company company = _companyDao.findByPermalink(companyName);
		if (company != null) {
			return new ModelAndView("companyprofile", "company", company);		
		} else {
			// Company went missing, just default to main page for now
			return new ModelAndView("hello");
		}
	}

}
