package webapp;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class FetchDataController implements Controller {

    private CompanyDAO _companyDao;

    public FetchDataController(CompanyDAO companyDao) {
    	_companyDao = companyDao;
    }
		
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		List<Company> companies = _companyDao.find().asList();
		
        return new ModelAndView("index.jsp", "companies", companies);
	}

	
}
