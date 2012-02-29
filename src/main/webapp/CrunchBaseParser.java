package webapp;

import java.io.IOException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.JsonToken;
import org.codehaus.jackson.map.DeserializationConfig.Feature;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

public class CrunchBaseParser {

	private static final String[] EXCLUDED_FIELDS = { "deadpooled_year", "ipo", "acquistion" };
	private ObjectMapper _mapper;
	
	public CrunchBaseParser() {
		_mapper = new ObjectMapper();
		_mapper.getDeserializationConfig().setDateFormat(
                 new SimpleDateFormat("EEE MMM dd hh:mm:ss zzz yyyy"));
		_mapper.getDeserializationConfig().addMixInAnnotations(Company.class, CompanyMixIn.class);
		_mapper.getDeserializationConfig().addMixInAnnotations(FundingRound.class, FundingRoundMixIn.class);
		_mapper.configure(Feature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		_mapper.configure(Feature.AUTO_DETECT_SETTERS, false);
		_mapper.configure(Feature.AUTO_DETECT_CREATORS, false);
		_mapper.configure(Feature.AUTO_DETECT_FIELDS, false);
	}
	
	List<Company> getAllCompanies() throws JsonParseException, IOException {
		return getCompanies(-1);
	}
	
	List<Company> getCompanies(int bound) throws JsonParseException, IOException {
		List<Company> companies = new ArrayList<Company>();
		URL url = new URL("http://api.crunchbase.com/v/1/companies.js");
		JsonFactory f = new JsonFactory();
		JsonParser jp = f.createJsonParser(url);
		JsonToken next = jp.nextToken();
		assert(next == JsonToken.START_ARRAY);

		int i = 0;
		while ((next = jp.nextToken()) != JsonToken.END_ARRAY) {
			assert(next == JsonToken.START_OBJECT);
			
			while (jp.nextToken() != JsonToken.END_OBJECT) {
				String name = jp.getCurrentName();
				next = jp.nextToken();
				assert(next == JsonToken.VALUE_STRING);

				if ("permalink".equals(name)) {
					Company company = getCompany(jp.getText());
					if (company != null) {
						companies.add(company);
					}
				}
			}
			
			if (companies.size() == bound) break;
			++i;
			if (i % 100 == 0) {
				System.out.println(i);
			}
		}
		
	    LogFactory.getLog(getClass()).info("Parsed " + companies.size() + " companies");
			
		return companies;		
	}
	
	Company getCompany(String permalink) throws JsonParseException, JsonMappingException, IOException {
		URL url = new URL("http://api.crunchbase.com/v/1/company/" + permalink + ".js");
		
		@SuppressWarnings("unchecked")
		Map<String, Object> data = _mapper.readValue(url.openStream(), Map.class);
		
		// Exclude companies that are dead, acquired, or public
		for (String s : EXCLUDED_FIELDS) {
			if (data.get(s) != null) {
				return null;
			}
		}
		
		return _mapper.convertValue(data, Company.class);
	}
}
