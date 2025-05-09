package com.vibin.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.model.User;
import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

/**
 * Data Access Object for User entity
 */
public class UserDAO {
    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);
    
    /**
     * Authenticate a user with email/username and password
     * 
     * @param emailOrUsername The email or username
     * @param password The password
     * @return User object if authentication successful, null otherwise
     * @throws SQLException if a database error occurs
     */
    public User authenticate(String emailOrUsername, String password) throws SQLException {
        String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, emailOrUsername);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error authenticating user: " + e.getMessage(), e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Check if email already exists
     * 
     * @param email The email to check
     * @return true if email exists, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error checking if email exists: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Insert a new user
     * 
     * @param user The user to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertUser(User user) throws SQLException {
        String sql = "INSERT INTO user (name, email, password, contact_no) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword());
            pstmt.setString(4, user.getContactNo());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error inserting user: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Get user by ID
     * 
     * @param id The user ID
     * @return User object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM user WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting user by ID: " + e.getMessage(), e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Update user information
     * 
     * @param user The user to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE user SET name = ?, email = ?, contact_no = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getContactNo());
            pstmt.setInt(4, user.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating user: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Update user password
     * 
     * @param userId The user ID
     * @param newPassword The new password
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE user SET password = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, newPassword);
            pstmt.setInt(2, userId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating password: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Delete a user
     * 
     * @param id The user ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteUser(int id) throws SQLException {
        String sql = "DELETE FROM user WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error deleting user: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Get all users
     * 
     * @return List of all users
     * @throws SQLException if a database error occurs
     */
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting all users: " + e.getMessage(), e);
            throw e;
        }
        
        return users;
    }
    
    /**
     * Helper method to extract user data from a ResultSet
     * 
     * @param rs The ResultSet containing user data
     * @return User object populated with data from the ResultSet
     * @throws SQLException if a database error occurs
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setContactNo(rs.getString("contact_no"));
        return user;
    }
}
