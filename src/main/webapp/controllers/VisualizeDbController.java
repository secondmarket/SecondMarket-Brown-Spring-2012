package webapp.controllers;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import webapp.Company;
import webapp.CompanyDAO;
import webapp.LimitedMoneyCompanyComparator;

public class VisualizeDbController implements Controller {
    protected final Log _logger = LogFactory.getLog(getClass());
    private CompanyDAO _companyDao;

    public VisualizeDbController(CompanyDAO companyDao) {
    	_companyDao = companyDao;
    }
		
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		List<Company> companies = _companyDao.find().asList();
		int limit = 500;
		if(companies.size()>limit){
			Collections.sort(companies,new LimitedMoneyCompanyComparator(5));
			Collections.reverse(companies);
			companies = companies.subList(0,500);
		}
		
		_logger.info("Returning Chart of  " + companies.size() + " companies");

		String page = request.getServletPath();
		page = page.substring(0, page.indexOf('.'));
        return new ModelAndView(page, "companies", companies);
	}

}
