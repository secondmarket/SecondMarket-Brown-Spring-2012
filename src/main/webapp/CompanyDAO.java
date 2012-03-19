package webapp;

import java.util.List;

import org.bson.types.ObjectId;

import com.google.code.morphia.Morphia;
import com.google.code.morphia.dao.BasicDAO;
import com.mongodb.Mongo;

/*
 * Data access object a Company
 */
public class CompanyDAO extends BasicDAO<Company, ObjectId> {
	public CompanyDAO(Morphia morphia, Mongo mongo, String dbName) {
		super(mongo, morphia, dbName);
	}
	
	public List<Company> findByName(String name) {
		return ds.find(entityClazz).field("_name").equal(name).asList();
	}
	
	// permalinks are unique, so only return one
	public Company findByPermalink(String permalink) {
		return ds.find(entityClazz).field("_permalink").equal(permalink).get();
	}
	
	public List<Company> findByIndustry(String industry) {
		return ds.find(entityClazz).field("_industry").equal(industry).asList();
	}
	
	// location queries use the first Office by default
	public List<Company> findByLocation(String city) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).asList();		
	}
	
	public List<Company> findByLocation(String city, String state) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).
				 field("_offices.0._state").equal(state).asList();
	}

	// use these to sort by industry and city, they'll be faster than 
	// combining findByLocation() and findByIndustry()
	public List<Company> findByIndustryAndLocation(String industry, String city) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).
				field("_industry").equal(industry).asList();
	}
	
	public List<Company> findByIndustryAndLocation(String industry, String city, String state) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).
				 field("_offices.0._state").equal(state).field("_industry").equal(industry).
				 asList();		
	}
}
