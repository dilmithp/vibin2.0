package com.vibin.dao;

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

import com.vibin.model.Artist;
import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

/**
 * Data Access Object for Artist entity
 */
public class ArtistDAO {
    private static final Logger logger = LoggerFactory.getLogger(ArtistDAO.class);
    
    /**
     * Get all artists from the database
     * 
     * @return List of all artists
     * @throws SQLException if a database error occurs
     */
    public List<Artist> getAllArtists() throws SQLException {
        List<Artist> artists = new ArrayList<>();
        String sql = "SELECT * FROM artists ORDER BY artist_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                artists.add(extractArtistFromResultSet(rs));
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting all artists: " + e.getMessage(), e);
            throw e;
        }
        
        return artists;
    }
    
    /**
     * Get artist by ID
     * 
     * @param id The artist ID
     * @return Artist object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Artist getArtistById(int id) throws SQLException {
        String sql = "SELECT * FROM artists WHERE artist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractArtistFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting artist by ID: " + e.getMessage(), e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Insert a new artist
     * 
     * @param artist The artist to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertArtist(Artist artist) throws SQLException {
        String sql = "INSERT INTO artists (artist_name, bio, image_url, genre, country, created_date, email) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, artist.getArtistName());
            pstmt.setString(2, artist.getBio());
            pstmt.setString(3, artist.getImageUrl());
            pstmt.setString(4, artist.getGenre());
            pstmt.setString(5, artist.getCountry());
            
            if (artist.getCreatedDate() == null) {
                pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            } else {
                pstmt.setTimestamp(6, artist.getCreatedDate());
            }
            
            pstmt.setString(7, artist.getEmail());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        artist.setArtistId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error inserting artist: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Update an existing artist
     * 
     * @param artist The artist to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateArtist(Artist artist) throws SQLException {
        String sql = "UPDATE artists SET artist_name = ?, bio = ?, image_url = ?, " +
                     "genre = ?, country = ?, email = ? WHERE artist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, artist.getArtistName());
            pstmt.setString(2, artist.getBio());
            pstmt.setString(3, artist.getImageUrl());
            pstmt.setString(4, artist.getGenre());
            pstmt.setString(5, artist.getCountry());
            pstmt.setString(6, artist.getEmail());
            pstmt.setInt(7, artist.getArtistId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating artist: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Delete an artist by ID
     * 
     * @param id The artist ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteArtist(int id) throws SQLException {
        String sql = "DELETE FROM artists WHERE artist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error deleting artist: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Search artists by name
     * 
     * @param name The name to search for
     * @return List of matching artists
     * @throws SQLException if a database error occurs
     */
    public List<Artist> searchArtistsByName(String name) throws SQLException {
        List<Artist> artists = new ArrayList<>();
        String sql = "SELECT * FROM artists WHERE artist_name LIKE ? ORDER BY artist_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    artists.add(extractArtistFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error searching artists by name: " + e.getMessage(), e);
            throw e;
        }
        
        return artists;
    }
    
    /**
     * Get artists by genre
     * 
     * @param genre The genre to filter by
     * @return List of artists in the specified genre
     * @throws SQLException if a database error occurs
     */
    public List<Artist> getArtistsByGenre(String genre) throws SQLException {
        List<Artist> artists = new ArrayList<>();
        String sql = "SELECT * FROM artists WHERE genre = ? ORDER BY artist_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, genre);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    artists.add(extractArtistFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting artists by genre: " + e.getMessage(), e);
            throw e;
        }
        
        return artists;
    }
    
    /**
     * Helper method to extract artist data from a ResultSet
     * 
     * @param rs The ResultSet containing artist data
     * @return Artist object populated with data from the ResultSet
     * @throws SQLException if a database error occurs
     */
    private Artist extractArtistFromResultSet(ResultSet rs) throws SQLException {
        Artist artist = new Artist();
        artist.setArtistId(rs.getInt("artist_id"));
        artist.setArtistName(rs.getString("artist_name"));
        artist.setBio(rs.getString("bio"));
        artist.setImageUrl(rs.getString("image_url"));
        artist.setGenre(rs.getString("genre"));
        artist.setCountry(rs.getString("country"));
        artist.setCreatedDate(rs.getTimestamp("created_date"));
        artist.setEmail(rs.getString("email"));
        return artist;
    }
}
