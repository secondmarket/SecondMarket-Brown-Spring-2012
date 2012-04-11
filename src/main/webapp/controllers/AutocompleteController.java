package webapp.controllers;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;
import org.springframework.http.server.ServletServerHttpResponse;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import webapp.Company;
import webapp.CompanyDAO;

import com.google.code.morphia.query.QueryResults;

public class AutocompleteController implements Controller {

	private CompanyDAO _companyDao;
	private MappingJacksonHttpMessageConverter _jsonConverter;
	
	AutocompleteController(CompanyDAO companyDao) {
		_companyDao = companyDao;
		_jsonConverter = new MappingJacksonHttpMessageConverter();
	}
	
	class LabelValuePair {
		public String label, value;
	}
	
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		QueryResults<Company> companies = _companyDao.find();
		List<LabelValuePair> json = new ArrayList<LabelValuePair>();
		for (Company c : companies) {
			LabelValuePair p = new LabelValuePair();
			p.label = c.getName();
			p.value = c.getPermalink();
			json.add(p);
		}
		
		_jsonConverter.write(json, MediaType.APPLICATION_JSON, new ServletServerHttpResponse(response));// = new MappingJacksonHttpMessageConverter();
		return null;
	}

}
