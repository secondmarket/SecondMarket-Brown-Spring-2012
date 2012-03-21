package webapp.controllers;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonParseException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import webapp.Company;
import webapp.CompanyDAO;
import webapp.CrunchBaseParser;

/*
 * Populates the database
 */
public class PopulateDbController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
    private CompanyDAO _companyDao;
    private boolean _gettingData;
    private File _excludedCompaniesFile;
    
    public PopulateDbController(CompanyDAO companyDao) {
    	_companyDao = companyDao;
    	_gettingData = false;
    	_excludedCompaniesFile = new File("src/main/webapp/excluded-companies.txt");
    }
    
    public Set<String> getExcludedCompanies(File file) throws IOException {
    	Set<String> excluded = new HashSet<String>();
    	BufferedReader reader = new BufferedReader(new FileReader(file));
    	String nextLine;
    	while ((nextLine = reader.readLine()) != null) {
    		excluded.add(nextLine);
    	}
    	
    	reader.close();
    	return excluded;
    }
    
    public void addExcludedCompany(String permalink, File file) throws IOException {
    	BufferedWriter writer = new BufferedWriter(new FileWriter(file, true));
    	writer.write(permalink);
    	writer.newLine();
    	writer.close();
    }
	
    // Parse data using the CrunchBase API and save it to the DB
    public void saveCrunchbaseDataToDb() {
    	Set<String> excludedCompanies;
    	try {
			excludedCompanies = getExcludedCompanies(_excludedCompaniesFile);
		} catch (IOException e1) {
			excludedCompanies = new HashSet<String>();
		}
    	
    	CrunchBaseParser p = new CrunchBaseParser();
    	try {
    		List<String> permalinks = p.getAllPermalinks();
    		for (int i = 0; i < permalinks.size(); ++i) {
    			String s = permalinks.get(i);
    			Company c = _companyDao.findByPermalink(s);
    			// if not in db or excluded list, parse and save to db
    			if (c == null && !excludedCompanies.contains(s)) {
    				c = p.getCompany(s);
    				if (c != null) {
    					_companyDao.save(c);
    				} else {
    					// new excluded company - add to the list
    					addExcludedCompany(s, _excludedCompaniesFile);
    				}
    			}
    			if (i % 100 == 0) {
    				System.out.println(i);
    			}
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
		if (!_gettingData) {
			_gettingData = true;
			saveCrunchbaseDataToDb();
		}
		return new ModelAndView("hello");
	}
    
    
}
