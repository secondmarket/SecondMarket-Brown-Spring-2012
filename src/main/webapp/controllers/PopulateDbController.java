package webapp.controllers;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import webapp.Company;
import webapp.CompanyDAO;
import webapp.CrunchBaseParser;
import webapp.FundingRound;
import webapp.Office;

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
    
    @SuppressWarnings("unused")
	private void setLatLong(Company c) throws IOException {
		List<Office> offices = c.getOffices();
		if (offices != null && offices.size() != 0) {
			Office mainOffice = offices.get(0);
			String address = mainOffice.getAddress();
			if (mainOffice.getCity() != null && mainOffice.getCity().length() != 0) {
				address += ", " + mainOffice.getCity();
    			if (mainOffice.getState() != null && mainOffice.getState().length() != 0) {
    				address += ", " + mainOffice.getState();
    			}
			}

			address = URLEncoder.encode(address, "utf-8");
			URL url = new URL("http://www.mapquestapi.com/geocoding/v1/address?key=Fmjtd%7Cluua2quz2u%2Cbg%3Do5-hzyxg&location=" + address);
    		URLConnection connection = url.openConnection();
    		String line;
    		StringBuilder builder = new StringBuilder();
    		BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
    		while ((line = reader.readLine()) != null) {
    			builder.append(line);
    		}
    		reader.close();

    		ObjectMapper mapper = new ObjectMapper();
    		JsonFactory factory = mapper.getJsonFactory();
    		JsonParser jp = factory.createJsonParser(builder.toString());
    		JsonNode data = jp.readValueAsTree();
			int status = data.get("info").get("statuscode").getIntValue();
			if (status == 0) {
				JsonNode latLng = data.get("results").get(0).get("locations").get(0).get("latLng");
				double lat = latLng.get("lat").getDoubleValue();
				double lng = latLng.get("lng").getDoubleValue();
				mainOffice.setLatitude(lat);
				mainOffice.setLongitude(lng);
			} else {
				System.out.println("Bad Mapquest status: " + status);
			}
		}
    }
    
    public void updateDb() throws IOException, URISyntaxException{
    	List<Company> companies = _companyDao.find().asList();
    	int counter = 0;
    	for(Company c: companies){
    		// fill in money raised since 2008
    		counter++;
    		List<FundingRound> rounds = c.getFundingRounds();
    		double money = 0;
    		for(FundingRound fr: rounds){
    			if(fr.getYear()>=2008){
    				money=money+fr.getRaisedAmount();
    			}
    		}
    		c.setFiveYearMoneyRaised(money);
    		
    		_companyDao.save(c);
    		if(counter%100==0){
    			System.out.println(counter);
    		}
    	}
    }

	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		//check for update vs first populate
		String add = request.getServletPath();
		add = add.substring(0, add.indexOf('.'));
		
		System.out.println(add);
		//if a db populate is being requested
		if(add.equals("/populate_db")){
			// make sure database wasn't already populated
			if (!_gettingData) {
				_gettingData = true;
				saveCrunchbaseDataToDb();
			}
			updateDb();
		}
		//if a db update is being requested
		else if(add.equals("/update_db")){
			updateDb();
		}
		//if something else is being requested
		return new ModelAndView("hello");
	}
    
}
