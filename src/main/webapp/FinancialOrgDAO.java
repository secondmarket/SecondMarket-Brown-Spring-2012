package webapp;

import java.util.List;

import org.bson.types.ObjectId;

import com.google.code.morphia.Morphia;
import com.google.code.morphia.dao.BasicDAO;
import com.mongodb.Mongo;

/*
 * Data access object a Company
 */
public class FinancialOrgDAO extends BasicDAO<FinancialOrg, ObjectId> {
	public FinancialOrgDAO(Morphia morphia, Mongo mongo, String dbName) {
		super(mongo, morphia, dbName);
	}
	
	public FinancialOrg findByPermalink(String permalink) {
		return ds.find(entityClazz).field("_permalink").equal(permalink).get();
	}
}
