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

import com.vibin.model.Playlist;
import com.vibin.model.Song;
import com.vibin.util.DBConnection;
import com.vibin.util.LoggerUtil;

/**
 * Data Access Object for Playlist entity
 */
public class PlaylistDAO {
    private static final Logger logger = LoggerFactory.getLogger(PlaylistDAO.class);
    
    /**
     * Get playlists by user ID
     * 
     * @param userId The user ID
     * @return List of playlists for the user
     * @throws SQLException if a database error occurs
     */
    public List<Playlist> getPlaylistsByUser(int userId) throws SQLException {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT * FROM playlists WHERE user_id = ? ORDER BY playlist_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    playlists.add(extractPlaylistFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting playlists by user: " + e.getMessage(), e);
            throw e;
        }
        
        return playlists;
    }
    
    /**
     * Get playlist by ID
     * 
     * @param id The playlist ID
     * @return Playlist object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Playlist getPlaylistById(int id) throws SQLException {
        String sql = "SELECT * FROM playlists WHERE playlist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Playlist playlist = extractPlaylistFromResultSet(rs);
                    playlist.setSongs(getPlaylistSongs(id));
                    return playlist;
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting playlist by ID: " + e.getMessage(), e);
            throw e;
        }
        
        return null;
    }
    
    /**
     * Insert a new playlist
     * 
     * @param playlist The playlist to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertPlaylist(Playlist playlist) throws SQLException {
        String sql = "INSERT INTO playlists (playlist_name, user_id, description) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, playlist.getPlaylistName());
            pstmt.setInt(2, playlist.getUserId());
            pstmt.setString(3, playlist.getDescription());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        playlist.setPlaylistId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error inserting playlist: " + e.getMessage(), e);
            throw e;
        }
        
        return false;
    }
    
    /**
     * Update an existing playlist
     * 
     * @param playlist The playlist to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updatePlaylist(Playlist playlist) throws SQLException {
        String sql = "UPDATE playlists SET playlist_name = ?, description = ? WHERE playlist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, playlist.getPlaylistName());
            pstmt.setString(2, playlist.getDescription());
            pstmt.setInt(3, playlist.getPlaylistId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error updating playlist: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Delete a playlist by ID
     * 
     * @param id The playlist ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deletePlaylist(int id) throws SQLException {
        String sql = "DELETE FROM playlists WHERE playlist_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error deleting playlist: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Get songs in a playlist
     * 
     * @param playlistId The playlist ID
     * @return List of songs in the playlist
     * @throws SQLException if a database error occurs
     */
    public List<Song> getPlaylistSongs(int playlistId) throws SQLException {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT s.* FROM songs s " +
                     "JOIN playlist_songs ps ON s.song_id = ps.song_id " +
                     "WHERE ps.playlist_id = ? " +
                     "ORDER BY ps.added_date";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Song song = new Song();
                    song.setSongId(rs.getInt("song_id"));
                    song.setSongName(rs.getString("song_name"));
                    song.setLyricist(rs.getString("lyricist"));
                    song.setSinger(rs.getString("singer"));
                    song.setMusicDirector(rs.getString("music_director"));
                    song.setAlbumId(rs.getInt("album_id"));
                    songs.add(song);
                }
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error getting playlist songs: " + e.getMessage(), e);
            throw e;
        }
        
        return songs;
    }
    
    /**
     * Add a song to a playlist
     * 
     * @param playlistId The playlist ID
     * @param songId The song ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean addSongToPlaylist(int playlistId, int songId) throws SQLException {
        String sql = "INSERT IGNORE INTO playlist_songs (playlist_id, song_id) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setInt(2, songId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error adding song to playlist: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Remove a song from a playlist
     * 
     * @param playlistId The playlist ID
     * @param songId The song ID
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean removeSongFromPlaylist(int playlistId, int songId) throws SQLException {
        String sql = "DELETE FROM playlist_songs WHERE playlist_id = ? AND song_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setInt(2, songId);
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error removing song from playlist: " + e.getMessage(), e);
            throw e;
        }
    }
    
    /**
     * Helper method to extract playlist data from a ResultSet
     * 
     * @param rs The ResultSet containing playlist data
     * @return Playlist object populated with data from the ResultSet
     * @throws SQLException if a database error occurs
     */
    private Playlist extractPlaylistFromResultSet(ResultSet rs) throws SQLException {
        Playlist playlist = new Playlist();
        playlist.setPlaylistId(rs.getInt("playlist_id"));
        playlist.setPlaylistName(rs.getString("playlist_name"));
        playlist.setUserId(rs.getInt("user_id"));
        playlist.setCreatedDate(rs.getTimestamp("created_date"));
        playlist.setDescription(rs.getString("description"));
        return playlist;
    }
}
