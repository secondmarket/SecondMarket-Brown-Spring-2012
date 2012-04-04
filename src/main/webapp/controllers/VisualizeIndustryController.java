package webapp.controllers;

import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import webapp.Company;
import webapp.CompanyDAO;
import webapp.LimitedMoneyCompanyComparator;

import com.google.code.morphia.query.Query;

public class VisualizeIndustryController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
	private CompanyDAO _companyDao;
	
	VisualizeIndustryController(CompanyDAO companyDao) {
		_companyDao = companyDao;
	}
	
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String industry = request.getServletPath().substring("/industry/".length());
		industry = industry.substring(0, industry.indexOf('.')).toLowerCase();
		
		String location = request.getQueryString();
		if(location!=null && location.contains("%20")){
			String beg = location.substring(0,location.indexOf("%20"));
			String end = location.substring(location.indexOf("%20")+"%20".length());
			location = beg + " " + end;
		}
		
		List<Company> companies;
		int limit = 300;
		if(location!=null){
			if(industry.equals("all")){
				companies = _companyDao.findByLocation(location).order("-_fiveYearMoneyRaised").limit(limit).asList();
			}
			else{
				companies = _companyDao.findByIndustryAndLocation(industry,location).order("-_fiveYearMoneyRaised").limit(limit).asList();
			}
		}
		else{
			if(industry.equals("all")){
				Query<Company> comps = (Query<Company>)_companyDao.find();
				companies = comps.order("-_fiveYearMoneyRaised").limit(limit).asList();
			}
			else{
				companies = _companyDao.findByIndustry(industry).order("-_fiveYearMoneyRaised").limit(limit).asList();
			}
		}

		_logger.info("Returning visualization for " + industry);
        return new ModelAndView("industryvis", "industrycompanies", companies);
	}

}
