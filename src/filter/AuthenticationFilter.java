package filter;

import action.util.ActionEnum;
import bean.UserInfoBean;
import util.ConfigurationManager;
import util.PageNamesConstants;
import util.RequestParametersNames;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Created by USER on 15.05.2016.
 */
public class AuthenticationFilter implements Filter {

    private static final ActionEnum[] commandsForbiddenForDrivers = { ActionEnum.CHANGE_TRUCK_STATE,
            ActionEnum.CHANGE_TRIP_STATE, ActionEnum.ADD_REQUEST, ActionEnum.GET_REQUESTS,
            ActionEnum.GET_TRIPS, ActionEnum.GET_ASSIGNATION_FORM, ActionEnum.GET_TRUCKS, ActionEnum.ASSIGN_DRIVER_TO_A_TRIP
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) servletRequest;
        HttpServletResponse res = (HttpServletResponse) servletResponse;

        String contextPath = req.getContextPath();
        HttpSession session = req.getSession(false);
        String command = req.getParameter(RequestParametersNames.COMMAND);
        ActionEnum actionEnum = ActionEnum.valueOf(command.toUpperCase());
        UserInfoBean userInfoBean = (UserInfoBean) session.getAttribute(RequestParametersNames.USER);
        if(session == null || userInfoBean == null) {
            if(!ActionEnum.SIGNUP_FORM.equals(actionEnum) && !ActionEnum.SIGNUP.equals(actionEnum)
                    && !ActionEnum.LOGIN.equals(actionEnum) && !ActionEnum.GET_LOGIN_FORM.equals(actionEnum)) {
                res.sendRedirect(contextPath + ConfigurationManager.getProperty(PageNamesConstants.LOGIN));
                return;
            }
            else {
                filterChain.doFilter(servletRequest, servletResponse);
                return;
            }
        }
        else if(!userInfoBean.isAdmin()) {
            for(ActionEnum forbiddenCommand : commandsForbiddenForDrivers) {
                if(actionEnum == forbiddenCommand) {
                    res.sendRedirect(contextPath + ConfigurationManager.getProperty(PageNamesConstants.LOGIN));
                    return;
                }
            }
        }
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}
