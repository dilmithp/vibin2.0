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

import com.vibin.model.Album;
import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

/**
 * Data Access Object for Album entity
 */
public class AlbumDAO {
    private static final Logger logger = LoggerFactory.getLogger(AlbumDAO.class);
    
    /**
     * Get all albums from the database
     * 
     * @return List of all albums
     * @throws SQLException if a database error occurs
     */
    public List<Album> getAllAlbums() throws SQLException {
        List<Album> albums = new ArrayList<>();
        String sql = "SELECT * FROM albums ORDER BY album_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                albums.add(extractAlbumFromResultSet(rs));
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting all albums: " + e.getMessage(), e);
            throw e;
        }
        
        return albums;
    }
    
    /**
     * Get album by ID
     * 
     * @param id The album ID
     * @return Album object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Album getAlbumById(int id) throws SQLException {
        String sql = "SELECT * FROM albums WHERE album_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractAlbumFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting album by ID: " + e.getMessage(), e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Insert a new album
     * 
     * @param album The album to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertAlbum(Album album) throws SQLException {
        String sql = "INSERT INTO albums (album_name, artist, release_date, genre) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, album.getAlbumName());
            pstmt.setString(2, album.getArtist());
            pstmt.setString(3, album.getReleaseDate());
            pstmt.setString(4, album.getGenre());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        album.setAlbumId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error inserting album: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Update an existing album
     * 
     * @param album The album to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateAlbum(Album album) throws SQLException {
        String sql = "UPDATE albums SET album_name = ?, artist = ?, release_date = ?, genre = ? WHERE album_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, album.getAlbumName());
            pstmt.setString(2, album.getArtist());
            pstmt.setString(3, album.getReleaseDate());
            pstmt.setString(4, album.getGenre());
            pstmt.setInt(5, album.getAlbumId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating album: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Delete an album by ID
     * 
     * @param id The album ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteAlbum(int id) throws SQLException {
        String sql = "DELETE FROM albums WHERE album_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error deleting album: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Search albums by name
     * 
     * @param name The name to search for
     * @return List of matching albums
     * @throws SQLException if a database error occurs
     */
    public List<Album> searchAlbumsByName(String name) throws SQLException {
        List<Album> albums = new ArrayList<>();
        String sql = "SELECT * FROM albums WHERE album_name LIKE ? ORDER BY album_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    albums.add(extractAlbumFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error searching albums by name: " + e.getMessage(), e);
            throw e;
        }
        
        return albums;
    }
    
    /**
     * Get albums by artist
     * 
     * @param artist The artist name
     * @return List of albums by the specified artist
     * @throws SQLException if a database error occurs
     */
    public List<Album> getAlbumsByArtist(String artist) throws SQLException {
        List<Album> albums = new ArrayList<>();
        String sql = "SELECT * FROM albums WHERE artist = ? ORDER BY release_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, artist);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    albums.add(extractAlbumFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting albums by artist: " + e.getMessage(), e);
            throw e;
        }
        
        return albums;
    }
    
    /**
     * Get albums by genre
     * 
     * @param genre The genre to filter by
     * @return List of albums in the specified genre
     * @throws SQLException if a database error occurs
     */
    public List<Album> getAlbumsByGenre(String genre) throws SQLException {
        List<Album> albums = new ArrayList<>();
        String sql = "SELECT * FROM albums WHERE genre = ? ORDER BY album_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, genre);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    albums.add(extractAlbumFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting albums by genre: " + e.getMessage(), e);
            throw e;
        }
        
        return albums;
    }
    
    /**
     * Helper method to extract album data from a ResultSet
     * 
     * @param rs The ResultSet containing album data
     * @return Album object populated with data from the ResultSet
     * @throws SQLException if a database error occurs
     */
    private Album extractAlbumFromResultSet(ResultSet rs) throws SQLException {
        Album album = new Album();
        album.setAlbumId(rs.getInt("album_id"));
        album.setAlbumName(rs.getString("album_name"));
        album.setArtist(rs.getString("artist"));
        album.setReleaseDate(rs.getString("release_date"));
        album.setGenre(rs.getString("genre"));
        return album;
    }
}
