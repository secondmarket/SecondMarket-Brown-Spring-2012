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
	private static final String LOCATIONS[] = {
		"Austin, TX",
		"Boston, MA",
		"Cambridge, MA",
		"Chicago, IL",
		"Mountain View, CA",
		"New York, NY",
		"Palo Alto, CA",
		"Seattle, WA",
		"San Francisco, CA"
	};
	
	AutocompleteController(CompanyDAO companyDao) {
		_companyDao = companyDao;
		_jsonConverter = new MappingJacksonHttpMessageConverter();
	}
	
	class LabelValuePair {
		public String label, value, type;
	}
	
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String startsWith = request.getParameter("startsWith");
		int maxRows;
		try {
			maxRows = Integer.parseInt(request.getParameter("maxRows"));
		} catch (NumberFormatException e) {
			maxRows = 10;
		}
		List<LabelValuePair> json = new ArrayList<LabelValuePair>();
		
		// add locations to json
		for (String s : LOCATIONS) {
			if (s.toLowerCase().startsWith(startsWith)) {
				LabelValuePair p = new LabelValuePair();
				p.label = s;
				p.value = s.substring(0, s.indexOf(","));
				p.type = "l";
				json.add(p);
			}
		}
			
		maxRows -= json.size();
		QueryResults<Company> companies = _companyDao.createQuery().field("_name").startsWithIgnoreCase(startsWith).limit(maxRows).order("_name");
		
		// add companies to json
		for (Company c : companies) {
			LabelValuePair p = new LabelValuePair();
			p.label = c.getName();
			p.value = c.getPermalink();
			p.type = "c"; // c for company, l for location
			json.add(p);
		}
		_jsonConverter.write(json, MediaType.APPLICATION_JSON, new ServletServerHttpResponse(response));// = new MappingJacksonHttpMessageConverter();
		return null;
	}
}
