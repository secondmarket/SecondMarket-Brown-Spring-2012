package webapp;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class VisualizeFinancialController implements Controller {
    protected final Log _logger = LogFactory.getLog(getClass());
    private FinancialOrgDAO _financialDao;

    public VisualizeFinancialController(FinancialOrgDAO financialDao) {
    	_financialDao = financialDao;
    }
		
	public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		List<FinancialOrg> financialorgs = _financialDao.find().asList();
		int limit = 500;
		if(financialorgs.size()>limit){
			Collections.sort(financialorgs,new LimitedMoneyFinancialComparator(5));
			Collections.reverse(financialorgs);
			financialorgs = financialorgs.subList(0,500);
		}
		
		_logger.info("Returning Chart of  " + financialorgs.size() + " Financial Organizations");
		
        return new ModelAndView("vis2", "financialorgs", financialorgs);
	}

}
