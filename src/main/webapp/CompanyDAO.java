package webapp;

import org.bson.types.ObjectId;

import com.google.code.morphia.Morphia;
import com.google.code.morphia.dao.BasicDAO;
import com.google.code.morphia.query.Query;
import com.mongodb.Mongo;

/*
 * Data access object a Company
 */
public class CompanyDAO extends BasicDAO<Company, ObjectId> {
	public CompanyDAO(Morphia morphia, Mongo mongo, String dbName) {
		super(mongo, morphia, dbName);
	}
	
	// permalinks are unique, so only return one
	public Company findByPermalink(String permalink) {
		return ds.find(entityClazz).field("_permalink").equal(permalink).get();
	}
	
	public Query<Company> findByName(String name) {
		return ds.find(entityClazz).field("_name").equal(name);
	}
	
	public Query<Company> findByIndustry(String industry) {
		return ds.find(entityClazz).field("_industry").equal(industry);
	}
	
	// location queries use the first Office by default
	public Query<Company> findByLocation(String city) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city);		
	}
	
	public Query<Company> findByLocation(String city, String state) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).
				 field("_offices.0._state").equal(state);
	}

	// use these to sort by industry and city, they'll be faster than 
	// combining findByLocation() and findByIndustry()
	public Query<Company> findByIndustryAndLocation(String industry, String city) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).
				field("_industry").equal(industry);
	}
	
	public Query<Company> findByIndustryAndLocation(String industry, String city, String state) {
		return ds.find(entityClazz).disableValidation().field("_offices.0._city").equal(city).
				 field("_offices.0._state").equal(state).field("_industry").equal(industry);		
	}
}
