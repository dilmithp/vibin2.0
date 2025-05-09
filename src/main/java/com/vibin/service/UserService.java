package com.vibin.service;

import java.sql.SQLException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.dao.UserDAO;
import com.vibin.model.User;
import com.vibin.util.LoggerUtil;

/**
 * Service class for handling business logic related to users
 */
public class UserService {
    private static final Logger logger = LoggerFactory.getLogger(UserService.class);
    private UserDAO userDAO;
    
    /**
     * Constructor initializing the DAO
     */
    public UserService() {
        this.userDAO = new UserDAO();
    }
    
    /**
     * Authenticate a user with email/username and password
     * 
     * @param emailOrUsername The email or username
     * @param password The password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticate(String emailOrUsername, String password) {
        try {
            LoggerUtil.info(logger, "Authenticating user: " + emailOrUsername);
            return userDAO.authenticate(emailOrUsername, password);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error authenticating user: " + e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * Register a new user
     * 
     * @param user The user to register
     * @return true if successful, false otherwise
     */
    public boolean registerUser(User user) {
        try {
            LoggerUtil.info(logger, "Registering new user: " + user.getEmail());
            return userDAO.insertUser(user);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error registering user: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Check if email already exists
     * 
     * @param email The email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        try {
            LoggerUtil.info(logger, "Checking if email exists: " + email);
            return userDAO.emailExists(email);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error checking email existence: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Get user by ID
     * 
     * @param id The user ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int id) {
        try {
            LoggerUtil.info(logger, "Getting user with ID: " + id);
            return userDAO.getUserById(id);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting user by ID: " + e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * Update user profile
     * 
     * @param user The user to update
     * @return true if successful, false otherwise
     */
    public boolean updateUser(User user) {
        try {
            LoggerUtil.info(logger, "Updating user with ID: " + user.getId());
            return userDAO.updateUser(user);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating user: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Change user password
     * 
     * @param userId The user ID
     * @param newPassword The new password
     * @return true if successful, false otherwise
     */
    public boolean changePassword(int userId, String newPassword) {
        try {
            LoggerUtil.info(logger, "Changing password for user ID: " + userId);
            return userDAO.updatePassword(userId, newPassword);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error changing password: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Get all users
     * 
     * @return List of all users
     */
    public List<User> getAllUsers() {
        try {
            LoggerUtil.info(logger, "Getting all users");
            return userDAO.getAllUsers();
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting all users: " + e.getMessage(), e);
            return null;
        }
    }
    
    /**
     * Delete user by ID
     * 
     * @param id The user ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteUser(int id) {
        try {
            LoggerUtil.info(logger, "Deleting user with ID: " + id);
            return userDAO.deleteUser(id);
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error deleting user: " + e.getMessage(), e);
            return false;
        }
    }
}
