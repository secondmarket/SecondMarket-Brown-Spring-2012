package webapp;

import java.util.Calendar;
import java.util.Comparator;
import java.util.List;
import webapp.FinancialOrg;
import webapp.Investment;

public class LimitedMoneyFinancialComparator  implements Comparator<FinancialOrg>{
	
	private int _years;
	
	public LimitedMoneyFinancialComparator(int years){
		_years = years;
	}
	public int compare(FinancialOrg fo1, FinancialOrg fo2){
		
		List<Investment> invs1 = fo1.getInvestments();
		List<Investment> invs2 = fo2.getInvestments();
		
		int year = Calendar.getInstance().get(Calendar.YEAR);

		double total1 = 0.0;
		for(Investment inv : invs1){
			int diff = year-inv.getYear();
			if(diff<_years && diff>0){
				total1 += inv.getInvestmentAmount();
			}
		}
		
		double total2 = 0.0;
		for(Investment inv : invs2){
			int diff = year-inv.getYear();
			if(diff<_years && diff>0){
				total2 += inv.getInvestmentAmount();
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
