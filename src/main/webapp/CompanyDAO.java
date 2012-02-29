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
	
	public Company findByPermalink(String permalink) {
		return ds.find(entityClazz).field("_permalink").equal(permalink).get();
	}
}
