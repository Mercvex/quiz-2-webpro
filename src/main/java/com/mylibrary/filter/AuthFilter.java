package com.mylibrary.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Redirects unauthenticated requests to /login.
 * Applied to all protected routes in web.xml.
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest)  req;
        HttpServletResponse response = (HttpServletResponse) res;

        HttpSession session = request.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (loggedIn) {
            chain.doFilter(req, res);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
