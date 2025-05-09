package com.vibin.service;

import java.sql.SQLException;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.dao.PlaylistDAO;
import com.vibin.model.Playlist;
import com.vibin.model.Song;
import com.vibin.util.LoggerUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import com.vibin.util.DBConnection;


/**
 * Service class for handling business logic related to playlists
 */
public class PlaylistService {
    private static final Logger logger = LoggerFactory.getLogger(PlaylistService.class);
    private PlaylistDAO playlistDAO;
    
    /**
     * Constructor initializing the DAO
     */
    public PlaylistService() {
        this.playlistDAO = new PlaylistDAO();
    }
    
    /**
     * Get all playlists for a user
     * 
     * @param userId The user ID
     * @return List of playlists for the user
     * @throws SQLException if a database error occurs
     */
    public List<Playlist> getUserPlaylists(int userId) throws SQLException {
        LoggerUtil.info(logger, "Getting playlists for user ID: " + userId);
        return playlistDAO.getPlaylistsByUser(userId);
    }
    
    /**
     * Get playlist by ID
     * 
     * @param id The playlist ID
     * @return Playlist object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Playlist getPlaylist(int id) throws SQLException {
        LoggerUtil.info(logger, "Getting playlist with ID: " + id);
        return playlistDAO.getPlaylistById(id);
    }
    
    /**
     * Create a new playlist
     * 
     * @param playlist The playlist to create
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean createPlaylist(Playlist playlist) throws SQLException {
        LoggerUtil.info(logger, "Creating new playlist: " + playlist.getPlaylistName());
        return playlistDAO.insertPlaylist(playlist);
    }
    
    /**
     * Update an existing playlist
     * 
     * @param playlist The playlist to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updatePlaylist(Playlist playlist) throws SQLException {
        LoggerUtil.info(logger, "Updating playlist with ID: " + playlist.getPlaylistId());
        return playlistDAO.updatePlaylist(playlist);
    }
    
    /**
     * Delete a playlist by ID
     * 
     * @param id The playlist ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deletePlaylist(int id) throws SQLException {
        LoggerUtil.info(logger, "Deleting playlist with ID: " + id);
        return playlistDAO.deletePlaylist(id);
    }
    
    /**
     * Get songs in a playlist
     * 
     * @param playlistId The playlist ID
     * @return List of songs in the playlist
     * @throws SQLException if a database error occurs
     */
    public List<Song> getPlaylistSongs(int playlistId) throws SQLException {
        LoggerUtil.info(logger, "Getting songs for playlist ID: " + playlistId);
        return playlistDAO.getPlaylistSongs(playlistId);
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
        LoggerUtil.info(logger, "Adding song " + songId + " to playlist " + playlistId);
        return playlistDAO.addSongToPlaylist(playlistId, songId);
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
        LoggerUtil.info(logger, "Removing song " + songId + " from playlist " + playlistId);
        return playlistDAO.removeSongFromPlaylist(playlistId, songId);
    }
    /**
     * Retrieves all playlists from the database
     * 
     * @return List of all playlists
     * @throws SQLException if a database error occurs
     */
    public List<Playlist> getAllPlaylists() throws SQLException {
        LoggerUtil.info(logger, "Retrieving all playlists");
        
        // Since PlaylistDAO doesn't have a direct getAllPlaylists method,
        // we need to implement this functionality in the service layer
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT * FROM playlists";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Playlist playlist = new Playlist();
                playlist.setPlaylistId(rs.getInt("playlist_id"));
                playlist.setPlaylistName(rs.getString("playlist_name"));
                playlist.setUserId(rs.getInt("user_id"));
                playlist.setCreatedDate(rs.getTimestamp("created_date"));
                playlist.setDescription(rs.getString("description"));
                
                // Get the songs for this playlist
                playlist.setSongs(playlistDAO.getPlaylistSongs(playlist.getPlaylistId()));
                
                playlists.add(playlist);
            }
        } catch (SQLException e) {
            LoggerUtil.error(logger, "Error retrieving all playlists: " + e.getMessage(), e);
            throw e;
        }
        
        return playlists;
    }

    
}
