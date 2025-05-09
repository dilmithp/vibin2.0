package com.vibin.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.dao.ArtistDAO;
import com.vibin.model.Artist;
import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

/**
 * Service class for handling business logic related to artists
 */
public class ArtistService {
    private static final Logger logger = LoggerFactory.getLogger(ArtistService.class);
    private ArtistDAO artistDAO;
    
    /**
     * Constructor initializing the DAO
     */
    public ArtistService() {
        this.artistDAO = new ArtistDAO();
    }
    
    /**
     * Get all artists from the database
     * 
     * @return List of all artists
     * @throws SQLException if a database error occurs
     */
    public List<Artist> getAllArtists() throws SQLException {
        LoggerUtil.info(logger, "Getting all artists");
        return artistDAO.getAllArtists();
    }
    
    /**
     * Get artist by ID
     * 
     * @param id The artist ID
     * @return Artist object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Artist getArtist(int id) throws SQLException {
        LoggerUtil.info(logger, "Getting artist with ID: " + id);
        return artistDAO.getArtistById(id);
    }
    
    /**
     * Insert a new artist
     * 
     * @param artist The artist to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertArtist(Artist artist) throws SQLException {
        LoggerUtil.info(logger, "Inserting new artist: " + artist.getArtistName());
        return artistDAO.insertArtist(artist);
    }
    
    /**
     * Update an existing artist
     * 
     * @param artist The artist to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateArtist(Artist artist) throws SQLException {
        LoggerUtil.info(logger, "Updating artist with ID: " + artist.getArtistId());
        return artistDAO.updateArtist(artist);
    }
    
    /**
     * Delete an artist by ID
     * 
     * @param id The artist ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteArtist(int id) throws SQLException {
        LoggerUtil.info(logger, "Deleting artist with ID: " + id);
        return artistDAO.deleteArtist(id);
    }
    
    /**
     * Search artists by name
     * 
     * @param name The name to search for
     * @return List of matching artists
     * @throws SQLException if a database error occurs
     */
    public List<Artist> searchArtistsByName(String name) throws SQLException {
        LoggerUtil.info(logger, "Searching artists with name containing: " + name);
        return artistDAO.searchArtistsByName(name);
    }
    
    /**
     * Get artists by genre
     * 
     * @param genre The genre to filter by
     * @return List of artists in the specified genre
     * @throws SQLException if a database error occurs
     */
    public List<Artist> getArtistsByGenre(String genre) throws SQLException {
        LoggerUtil.info(logger, "Getting artists with genre: " + genre);
        return artistDAO.getArtistsByGenre(genre);
    }
    
    /**
     * Authenticate an artist with username and password
     * 
     * @param username The artist's username
     * @param password The artist's password
     * @return Artist object if authentication successful, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Artist authenticateArtist(String username, String password) throws SQLException {
        LoggerUtil.info(logger, "Authenticating artist with username: " + username);
        
        String sql = "SELECT a.* FROM artists a " +
                     "JOIN artist_login al ON a.artist_id = al.artist_id " +
                     "WHERE al.username = ? AND al.password = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Artist artist = new Artist();
                    artist.setArtistId(rs.getInt("artist_id"));
                    artist.setArtistName(rs.getString("artist_name"));
                    artist.setBio(rs.getString("bio"));
                    artist.setImageUrl(rs.getString("image_url"));
                    artist.setGenre(rs.getString("genre"));
                    artist.setCountry(rs.getString("country"));
                    artist.setCreatedDate(rs.getTimestamp("created_date"));
                    artist.setEmail(rs.getString("email"));
                    
                    // Update last login time
                    updateLastLogin(artist.getArtistId());
                    
                    LoggerUtil.info(logger, "Artist authenticated successfully: " + username);
                    return artist;
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error authenticating artist: " + e.getMessage(), e);
            throw e;
        }
        
        LoggerUtil.warn(logger, "Authentication failed for artist: " + username);
        return null;
    }
    
    /**
     * Update the last login time for an artist
     * 
     * @param artistId The artist ID
     * @throws SQLException if a database error occurs
     */
    private void updateLastLogin(int artistId) throws SQLException {
        String sql = "UPDATE artist_login SET last_login = ? WHERE artist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(2, artistId);
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating last login time: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Check if a username already exists in the artist_login table
     * 
     * @param username The username to check
     * @return true if username exists, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean usernameExists(String username) throws SQLException {
        LoggerUtil.info(logger, "Checking if artist username exists: " + username);
        
        String sql = "SELECT COUNT(*) FROM artist_login WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    boolean exists = rs.getInt(1) > 0;
                    LoggerUtil.info(logger, "Username exists check result: " + exists);
                    return exists;
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error checking if artist username exists: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Check if an email already exists in the artists table
     * 
     * @param email The email to check
     * @return true if email exists, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean emailExists(String email) throws SQLException {
        LoggerUtil.info(logger, "Checking if artist email exists: " + email);
        
        String sql = "SELECT COUNT(*) FROM artists WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    boolean exists = rs.getInt(1) > 0;
                    LoggerUtil.info(logger, "Email exists check result: " + exists);
                    return exists;
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error checking if artist email exists: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Register a new artist with login credentials
     * 
     * @param artist The artist to register
     * @param username The artist's username for login
     * @param password The artist's password
     * @return true if registration successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean registerArtist(Artist artist, String username, String password) throws SQLException {
        LoggerUtil.info(logger, "Registering new artist: " + artist.getArtistName());
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // First insert the artist record
            String artistSql = "INSERT INTO artists (artist_name, bio, genre, country, created_date, email) " +
                              "VALUES (?, ?, ?, ?, ?, ?)";
            
            try (PreparedStatement pstmt = conn.prepareStatement(artistSql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, artist.getArtistName());
                pstmt.setString(2, artist.getBio());
                pstmt.setString(3, artist.getGenre());
                pstmt.setString(4, artist.getCountry());
                
                if (artist.getCreatedDate() == null) {
                    pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                } else {
                    pstmt.setTimestamp(5, artist.getCreatedDate());
                }
                
                pstmt.setString(6, artist.getEmail());
                
                int affectedRows = pstmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Creating artist failed, no rows affected.");
                }
                
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        artist.setArtistId(generatedKeys.getInt(1));
                    } else {
                        throw new SQLException("Creating artist failed, no ID obtained.");
                    }
                }
            }
            
            // Then insert the login record
            String loginSql = "INSERT INTO artist_login (username, password, artist_id) VALUES (?, ?, ?)";
            
            try (PreparedStatement pstmt = conn.prepareStatement(loginSql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, password); // In a real application, you would hash this password
                pstmt.setInt(3, artist.getArtistId());
                
                int affectedRows = pstmt.executeUpdate();
                
                if (affectedRows == 0) {
                    throw new SQLException("Creating artist login failed, no rows affected.");
                }
            }
            
            conn.commit();
            LoggerUtil.info(logger, "Artist registered successfully with ID: " + artist.getArtistId());
            return true;
            
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error registering artist: " + e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LoggerUtil.error(logger, "Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LoggerUtil.error(logger, "Error closing connection: " + e.getMessage(), e);
                }
            }
        }
    }
}
