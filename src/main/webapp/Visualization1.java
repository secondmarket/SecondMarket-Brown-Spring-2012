package webapp;

import java.util.Iterator;
import java.util.List;

import webapp.Company;
import webapp.CompanyDAO;

public class Visualization1 {
    private CompanyDAO _companyDao;
    private double _totalMoney;
    private List<Company> _companies;
	
	public Visualization1(CompanyDAO companyDao){
		_companyDao = companyDao;
		_companies = _companyDao.find().asList();
		
		Iterator<Company> compit = _companies.iterator();
		_totalMoney = 0;
		while(compit.hasNext()){
			_totalMoney += compit.next().getTotalMoneyRaised();
		}
	}
	
	public double getTotalMoney(){
		return _totalMoney;
	}
	
	public List<Company> getCompanies(){
		return _companies;
	}
}