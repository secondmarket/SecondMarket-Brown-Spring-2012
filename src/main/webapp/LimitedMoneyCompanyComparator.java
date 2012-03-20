package webapp;

import java.util.Calendar;
import java.util.Comparator;
import java.util.List;

import webapp.Company;
import webapp.FundingRound;

public class LimitedMoneyCompanyComparator  implements Comparator<Company>{
	
	private int _years;
	
	public LimitedMoneyCompanyComparator(int years){
		_years = years;
	}
	public int compare(Company comp1, Company comp2){
		
		List<FundingRound> fr1 = comp1.getFundingRounds();
		List<FundingRound> fr2 = comp2.getFundingRounds();
		
		int year = Calendar.getInstance().get(Calendar.YEAR);

		double total1 = 0.0;
		for(FundingRound fr : fr1){
			int diff = year-fr.getYear();
			if(diff<_years && diff>0){
				total1 += fr.getRaisedAmount();
			}
		}
		
		double total2 = 0.0;
		for(FundingRound fr : fr2){
			int diff = year-fr.getYear();
			if(diff<_years && diff>0){
				total2 += fr.getRaisedAmount();
			}
		}

		
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
