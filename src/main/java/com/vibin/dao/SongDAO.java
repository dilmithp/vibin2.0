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

import com.vibin.model.Song;
import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

/**
 * Data Access Object for Song entity
 */
public class SongDAO {
    private static final Logger logger = LoggerFactory.getLogger(SongDAO.class);
    
    /**
     * Get all songs from the database
     * 
     * @return List of all songs
     * @throws SQLException if a database error occurs
     */
    public List<Song> getAllSongs() throws SQLException {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT * FROM songs ORDER BY song_name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                songs.add(extractSongFromResultSet(rs));
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting all songs: " + e.getMessage(), e);
            throw e;
        }
        
        return songs;
    }
    
    /**
     * Get song by ID
     * 
     * @param id The song ID
     * @return Song object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Song getSongById(int id) throws SQLException {
        String sql = "SELECT * FROM songs WHERE song_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractSongFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting song by ID: " + e.getMessage(), e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Insert a new song
     * 
     * @param song The song to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertSong(Song song) throws SQLException {
        String sql = "INSERT INTO songs (song_name, lyricist, singer, music_director, album_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, song.getSongName());
            pstmt.setString(2, song.getLyricist());
            pstmt.setString(3, song.getSinger());
            pstmt.setString(4, song.getMusicDirector());
            
            if (song.getAlbumId() > 0) {
                pstmt.setInt(5, song.getAlbumId());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        song.setSongId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error inserting song: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Update an existing song
     * 
     * @param song The song to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateSong(Song song) throws SQLException {
        String sql = "UPDATE songs SET song_name = ?, lyricist = ?, singer = ?, music_director = ?, album_id = ? WHERE song_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, song.getSongName());
            pstmt.setString(2, song.getLyricist());
            pstmt.setString(3, song.getSinger());
            pstmt.setString(4, song.getMusicDirector());
            
            if (song.getAlbumId() > 0) {
                pstmt.setInt(5, song.getAlbumId());
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(6, song.getSongId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating song: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Delete a song by ID
     * 
     * @param id The song ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteSong(int id) throws SQLException {
        String sql = "DELETE FROM songs WHERE song_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error deleting song: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Get songs by album ID
     * 
     * @param albumId The album ID
     * @return List of songs in the specified album
     * @throws SQLException if a database error occurs
     */
    public List<Song> getSongsByAlbum(int albumId) throws SQLException {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT * FROM songs WHERE album_id = ? ORDER BY song_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, albumId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    songs.add(extractSongFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting songs by album: " + e.getMessage(), e);
            throw e;
        }
        
        return songs;
    }
    
    /**
     * Search songs by name
     * 
     * @param name The name to search for
     * @return List of matching songs
     * @throws SQLException if a database error occurs
     */
    public List<Song> searchSongsByName(String name) throws SQLException {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT * FROM songs WHERE song_name LIKE ? ORDER BY song_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + name + "%");
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    songs.add(extractSongFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error searching songs by name: " + e.getMessage(), e);
            throw e;
        }
        
        return songs;
    }
    
    /**
     * Get songs by artist
     * 
     * @param artist The artist name
     * @return List of songs by the specified artist
     * @throws SQLException if a database error occurs
     */
    public List<Song> getSongsByArtist(String artist) throws SQLException {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT * FROM songs WHERE singer = ? ORDER BY song_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, artist);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    songs.add(extractSongFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting songs by artist: " + e.getMessage(), e);
            throw e;
        }
        
        return songs;
    }
    
    /**
     * Like a song
     * 
     * @param userId The user ID
     * @param songId The song ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean likeSong(int userId, int songId) throws SQLException {
        String sql = "INSERT IGNORE INTO liked_songs (user_id, song_id) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, songId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error liking song: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Unlike a song
     * 
     * @param userId The user ID
     * @param songId The song ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean unlikeSong(int userId, int songId) throws SQLException {
        String sql = "DELETE FROM liked_songs WHERE user_id = ? AND song_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, songId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error unliking song: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Get liked songs for a user
     * 
     * @param userId The user ID
     * @return List of songs liked by the user
     * @throws SQLException if a database error occurs
     */
    public List<Song> getLikedSongs(int userId) throws SQLException {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT s.* FROM songs s " +
                     "JOIN liked_songs ls ON s.song_id = ls.song_id " +
                     "WHERE ls.user_id = ? " +
                     "ORDER BY s.song_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    songs.add(extractSongFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting liked songs: " + e.getMessage(), e);
            throw e;
        }
        
        return songs;
    }
    
    /**
     * Helper method to extract song data from a ResultSet
     * 
     * @param rs The ResultSet containing song data
     * @return Song object populated with data from the ResultSet
     * @throws SQLException if a database error occurs
     */
    private Song extractSongFromResultSet(ResultSet rs) throws SQLException {
        Song song = new Song();
        song.setSongId(rs.getInt("song_id"));
        song.setSongName(rs.getString("song_name"));
        song.setLyricist(rs.getString("lyricist"));
        song.setSinger(rs.getString("singer"));
        song.setMusicDirector(rs.getString("music_director"));
        
        int albumId = rs.getInt("album_id");
        if (!rs.wasNull()) {
            song.setAlbumId(albumId);
        }
        
        return song;
    }
}
