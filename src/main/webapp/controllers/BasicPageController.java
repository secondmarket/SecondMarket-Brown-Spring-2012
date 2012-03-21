package webapp.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

public class BasicPageController implements Controller {

    protected final Log _logger = LogFactory.getLog(getClass());
	
	BasicPageController() {
	}
	
	public ModelAndView handleRequest(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String page = request.getServletPath();
		page = page.substring(0, page.indexOf('.'));
		_logger.info("Returning page for " + page);
		return new ModelAndView(page);		
	}

}
