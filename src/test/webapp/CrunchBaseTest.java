package webapp;

import java.io.File;
import java.io.IOException;
import java.util.List;
import junit.framework.TestCase;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

public class CrunchBaseTest extends TestCase {

	public void testSerialization() {
		CrunchBaseParser p = new CrunchBaseParser();
		List<Company> companies = null;
		try {
			companies = p.getCompanies(10);
		} catch (JsonParseException e) {
			assertFalse(true);
		} catch (IOException e) {
			assertFalse(true);
		}
		
		assertNotNull(companies);
		assertEquals(companies.size(), 10);
	}
	
	public void testDeserialization() {
		ObjectMapper mapper = new ObjectMapper();
		Company company = new Company();
		try {
			mapper.writeValue(new File("company_test.json"), company);
		} catch (JsonGenerationException e) {
			assertFalse(true);
		} catch (JsonMappingException e) {
			assertFalse(true);
		} catch (IOException e) {
			assertFalse(true);
		}
	}

	public void testCombined() {
		CrunchBaseParser p = new CrunchBaseParser();
		List<Company> companies = null;
		try {
			companies = p.getCompanies(1);
		} catch (JsonParseException e) {
			assertFalse(true);
		} catch (IOException e) {
			assertFalse(true);
		}

		assertNotNull(companies);
		assertEquals(companies.size(), 1);
		Company c = companies.get(0);
		assertNotNull(c.getName());

		ObjectMapper mapper = new ObjectMapper();
		try {
			mapper.writeValue(new File("company_test.json"), c);
		} catch (Exception e) {
			assertFalse(true);
		}
	}
	
	@Override
	protected void tearDown() {
		// delete the file
	}
}
