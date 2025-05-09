package com.vibin.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

@WebServlet(urlPatterns = {"/auth/login", "/auth/register", "/auth/logout", "/admin/login","/admin/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(AuthServlet.class);
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        LoggerUtil.info(logger, "GET request URI: " + uri + ", Context Path: " + contextPath);
        
        if (uri.endsWith("/auth/login")) {
            showLoginForm(request, response);
        } else if (uri.endsWith("/auth/register")) {
            showRegisterForm(request, response);
        } else if (uri.endsWith("/auth/logout")) {
            logout(request, response);
        } else {
            // Default to login page
            showLoginForm(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        LoggerUtil.info(logger, "POST request URI: " + uri + ", Context Path: " + contextPath);
        
        if (uri.endsWith("/auth/login") || uri.endsWith("/admin/login")) {
            authenticate(request, response);
        } else if (uri.endsWith("/auth/register")) {
            register(request, response);
        } else {
            // Default to login page
            showLoginForm(request, response);
        }
    }

    
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        LoggerUtil.info(logger, "Showing login form");
        
        // Check if there's a success message from registration
        String successParam = request.getParameter("success");
        if (successParam != null) {
            request.setAttribute("success", successParam);
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/login.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        LoggerUtil.info(logger, "Showing register form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/register.jsp");
        dispatcher.forward(request, response);
    }
    
    private void authenticate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        LoggerUtil.info(logger, "Login attempt for user: " + username);
        
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            LoggerUtil.warn(logger, "Login failed: Empty username or password");
            request.setAttribute("error", "Username and password are required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/login.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            LoggerUtil.info(logger, "Database connection established for login");
            
            // First check if this is an admin login
            String adminSql = "SELECT * FROM admin WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(adminSql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Admin login successful
                HttpSession session = request.getSession();
                session.setAttribute("adminId", rs.getInt("admin_id"));
                session.setAttribute("adminName", rs.getString("name"));
                session.setAttribute("adminUsername", rs.getString("username"));
                session.setAttribute("userType", "admin");
                
                LoggerUtil.info(logger, "Admin logged in successfully: " + username);
                response.sendRedirect(request.getContextPath() + "/admin/admin-dashboard.jsp");
                return;
            }

            
            // If not admin, check regular user
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            
            String userSql = "SELECT * FROM user WHERE email = ? AND password = ?";
            pstmt = conn.prepareStatement(userSql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Regular user login successful
                HttpSession session = request.getSession();
                session.setAttribute("id", rs.getInt("id"));
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("email", rs.getString("email"));
                session.setAttribute("userType", "user");
                
                LoggerUtil.info(logger, "User logged in successfully: " + username);
                response.sendRedirect(request.getContextPath() + "/user/index.jsp");
            } else {
                LoggerUtil.warn(logger, "Login failed for user: " + username);
                request.setAttribute("error", "Invalid username or password");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Database error during login: " + e.getMessage(), e);
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/login.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Close resources in reverse order
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LoggerUtil.error(logger, "Error closing database resources: " + e.getMessage(), e);
            }
        }
    }

    
    private void register(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("pass");
        String contact = request.getParameter("contact");
        String agreeTerms = request.getParameter("agree-term");
        
        LoggerUtil.info(logger, "Registration attempt for: " + email);
        LoggerUtil.info(logger, "Form data - Name: " + name + ", Email: " + email + 
                      ", Contact: " + contact + ", Terms Agreed: " + agreeTerms);
        
        // Validate form data
        if (name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            contact == null || contact.trim().isEmpty() || 
            agreeTerms == null) {
            
            LoggerUtil.warn(logger, "Registration failed: Missing required fields");
            request.setAttribute("error", "All fields are required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/register.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            LoggerUtil.info(logger, "Database connection established for registration");
            
            // Check if email already exists
            String checkSql = "SELECT * FROM user WHERE email = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, email);
            rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                LoggerUtil.warn(logger, "Registration failed - email already exists: " + email);
                request.setAttribute("error", "Email already registered");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/register.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Insert new user
            String sql = "INSERT INTO user (name, email, password, contact_no) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, password);
            pstmt.setString(4, contact);
            
            LoggerUtil.info(logger, "Executing SQL: " + sql + " with values: " + name + ", " + email + ", [PASSWORD], " + contact);
            int rowsAffected = pstmt.executeUpdate();
            LoggerUtil.info(logger, "SQL execution complete. Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                LoggerUtil.info(logger, "User registered successfully: " + email);
                response.sendRedirect(request.getContextPath() + "/auth/login?success=Registration successful");
            } else {
                LoggerUtil.error(logger, "Registration failed for: " + email + " - No rows affected");
                request.setAttribute("error", "Registration failed - database did not update");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/register.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Database error during registration: " + e.getMessage(), e);
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/auth/register.jsp");
            dispatcher.forward(request, response);
        } finally {
            // Close resources in reverse order
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                LoggerUtil.error(logger, "Error closing database resources: " + e.getMessage(), e);
            }
        }
    }
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            String userType = (String) session.getAttribute("userType");
            if ("admin".equals(userType)) {
                LoggerUtil.info(logger, "Admin logged out: " + session.getAttribute("adminUsername"));
            } else {
                LoggerUtil.info(logger, "User logged out: " + session.getAttribute("email"));
            }
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/auth/login");
    }

}
