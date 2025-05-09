package com.vibin.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.model.Song;
import com.vibin.model.User;
import com.vibin.service.SongService;
import com.vibin.service.UserService;
import com.vibin.util.LoggerUtil;

@WebServlet("/users/*")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(UserServlet.class);
    
    private UserService userService;
    private SongService songService;
    
    public void init() {
        userService = new UserService();
        songService = new SongService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getPathInfo();
        
        if (action == null) {
            action = "/profile";
        }
        
        try {
            switch (action) {
                case "/profile":
                    showProfile(request, response);
                    break;
                case "/edit-profile":
                    showEditProfileForm(request, response);
                    break;
                case "/update":
                    updateProfile(request, response);
                    break;
                case "/change-password":
                    showChangePasswordForm(request, response);
                    break;
                case "/update-password":
                    updatePassword(request, response);
                    break;
                case "/library":
                    showLibrary(request, response);
                    break;
                case "/delete-account":
                    deleteAccount(request, response);
                    break;
                case "/view":
                    viewUser(request, response);
                    break;
                default:
                    showProfile(request, response);
                    break;
            }
        } catch (SQLException ex) {
            LoggerUtil.error(logger, "Database error occurred: " + ex.getMessage(), ex);
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void showProfile(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to access profile without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        LoggerUtil.info(logger, "Showing profile for user ID: " + userId);
        
        User user = userService.getUserById(userId);
        request.setAttribute("user", user);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showEditProfileForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to access edit profile form without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        LoggerUtil.info(logger, "Showing edit profile form for user ID: " + userId);
        
        User user = userService.getUserById(userId);
        request.setAttribute("user", user);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/edit-profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to update profile without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String contactNo = request.getParameter("contactNo");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        LoggerUtil.info(logger, "Updating profile for user ID: " + userId);
        
        User user = userService.getUserById(userId);
        
        // Verify current password
        if (currentPassword == null || !user.getPassword().equals(currentPassword)) {
            LoggerUtil.warn(logger, "Current password verification failed for user ID: " + userId);
            request.setAttribute("error", "Current password is incorrect");
            request.setAttribute("user", user);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Update basic info
        user.setName(name);
        user.setEmail(email);
        user.setContactNo(contactNo);
        
        // Check if password change is requested
        if (newPassword != null && !newPassword.isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                LoggerUtil.warn(logger, "New password and confirmation do not match for user ID: " + userId);
                request.setAttribute("error", "New password and confirmation do not match");
                request.setAttribute("user", user);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Update password
            user.setPassword(newPassword);
            LoggerUtil.info(logger, "Password change included in profile update for user ID: " + userId);
        }
        
        boolean updated = userService.updateUser(user);
        
        if (updated) {
            // Update session attributes
            session.setAttribute("name", name);
            session.setAttribute("email", email);
            
            LoggerUtil.info(logger, "Profile updated successfully for user ID: " + userId);
            request.setAttribute("successMessage", "Profile updated successfully");
        } else {
            LoggerUtil.error(logger, "Failed to update profile for user ID: " + userId);
            request.setAttribute("error", "Failed to update profile");
        }
        
        request.setAttribute("user", user);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("id") == null) {
            LoggerUtil.warn(logger, "Attempt to access change password form without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        LoggerUtil.info(logger, "Showing change password form");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/change-password.jsp");
        dispatcher.forward(request, response);
    }
    
    private void updatePassword(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to update password without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        LoggerUtil.info(logger, "Attempting to change password for user ID: " + userId);
        
        // Verify current password
        User user = userService.getUserById(userId);
        
        if (!user.getPassword().equals(currentPassword)) {
            request.setAttribute("error", "Current password is incorrect");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/change-password.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Verify new password and confirmation match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New password and confirmation do not match");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/change-password.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        // Update password
        boolean updated = userService.changePassword(userId, newPassword);
        
        if (updated) {
            request.setAttribute("successMessage", "Password changed successfully");
        } else {
            request.setAttribute("error", "Failed to change password");
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/profile.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showLibrary(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to access library without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        LoggerUtil.info(logger, "Showing library for user ID: " + userId);
        
        List<Song> likedSongs = songService.getLikedSongs(userId);
        request.setAttribute("likedSongs", likedSongs);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/library.jsp");
        dispatcher.forward(request, response);
    }
    
    private void deleteAccount(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to delete account without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        LoggerUtil.info(logger, "Deleting account for user ID: " + userId);
        
        boolean deleted = userService.deleteUser(userId);
        
        if (deleted) {
            // Invalidate session
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?message=Account deleted successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/users/profile?error=Failed to delete account");
        }
    }
    
    private void viewUser(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        // Check if admin is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") == null) {
            LoggerUtil.warn(logger, "Unauthorized attempt to view user details");
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            LoggerUtil.error(logger, "User ID parameter is missing");
            response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp");
            return;
        }
        
        try {
            int userId = Integer.parseInt(idParam);
            LoggerUtil.info(logger, "Viewing user details for user ID: " + userId);
            
            User user = userService.getUserById(userId);
            
            if (user == null) {
                LoggerUtil.error(logger, "User not found with ID: " + userId);
                response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp");
                return;
            }
            
            request.setAttribute("user", user);
            
            // Get user's liked songs for the view
            List<Song> likedSongs = songService.getLikedSongs(userId);
            request.setAttribute("likedSongs", likedSongs);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/user/user-view.jsp");
            dispatcher.forward(request, response);
        } catch (NumberFormatException e) {
            LoggerUtil.error(logger, "Invalid user ID format: " + idParam);
            response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp");
        }
    }
}
