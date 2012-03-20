package webapp;

import java.util.Comparator;

import webapp.Company;

public class CompanyComparator  implements Comparator<Company>{
	public int compare(Company comp1, Company comp2){
		
		double total1 = comp1.getTotalMoneyRaised();
		double total2 = comp2.getTotalMoneyRaised();
		
		if(total1>total2){
			return 1;
		}
		else if(total1<total2){
			return -1;
		}
		else{
			return 0;
		}
	}
}
