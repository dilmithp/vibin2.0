package com.vibin.service;

import java.sql.SQLException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.dao.SongDAO;
import com.vibin.model.Song;
import com.vibin.util.LoggerUtil;

/**
 * Service class for handling business logic related to songs
 */
public class SongService {
    private static final Logger logger = LoggerFactory.getLogger(SongService.class);
    private SongDAO songDAO;
    
    /**
     * Constructor initializing the DAO
     */
    public SongService() {
        this.songDAO = new SongDAO();
    }
    
    /**
     * Get all songs from the database
     * 
     * @return List of all songs
     * @throws SQLException if a database error occurs
     */
    public List<Song> getAllSongs() throws SQLException {
        LoggerUtil.info(logger, "Getting all songs");
        return songDAO.getAllSongs();
    }
    
    /**
     * Get song by ID
     * 
     * @param id The song ID
     * @return Song object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Song getSong(int id) throws SQLException {
        LoggerUtil.info(logger, "Getting song with ID: " + id);
        return songDAO.getSongById(id);
    }
    
    /**
     * Insert a new song
     * 
     * @param song The song to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertSong(Song song) throws SQLException {
        LoggerUtil.info(logger, "Inserting new song: " + song.getSongName());
        return songDAO.insertSong(song);
    }
    
    /**
     * Update an existing song
     * 
     * @param song The song to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateSong(Song song) throws SQLException {
        LoggerUtil.info(logger, "Updating song with ID: " + song.getSongId());
        return songDAO.updateSong(song);
    }
    
    /**
     * Delete a song by ID
     * 
     * @param id The song ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteSong(int id) throws SQLException {
        LoggerUtil.info(logger, "Deleting song with ID: " + id);
        return songDAO.deleteSong(id);
    }
    
    /**
     * Get songs by album ID
     * 
     * @param albumId The album ID
     * @return List of songs in the specified album
     * @throws SQLException if a database error occurs
     */
    public List<Song> getSongsByAlbum(int albumId) throws SQLException {
        LoggerUtil.info(logger, "Getting songs for album ID: " + albumId);
        return songDAO.getSongsByAlbum(albumId);
    }
    
    /**
     * Search songs by name
     * 
     * @param name The name to search for
     * @return List of matching songs
     * @throws SQLException if a database error occurs
     */
    public List<Song> searchSongsByName(String name) throws SQLException {
        LoggerUtil.info(logger, "Searching songs with name containing: " + name);
        return songDAO.searchSongsByName(name);
    }
    
    /**
     * Get songs by artist
     * 
     * @param artist The artist name
     * @return List of songs by the specified artist
     * @throws SQLException if a database error occurs
     */
    public List<Song> getSongsByArtist(String artist) throws SQLException {
        LoggerUtil.info(logger, "Getting songs by artist: " + artist);
        return songDAO.getSongsByArtist(artist);
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
        LoggerUtil.info(logger, "User " + userId + " liking song " + songId);
        return songDAO.likeSong(userId, songId);
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
        LoggerUtil.info(logger, "User " + userId + " unliking song " + songId);
        return songDAO.unlikeSong(userId, songId);
    }
    
    /**
     * Get liked songs for a user
     * 
     * @param userId The user ID
     * @return List of songs liked by the user
     * @throws SQLException if a database error occurs
     */
    public List<Song> getLikedSongs(int userId) throws SQLException {
        LoggerUtil.info(logger, "Getting liked songs for user: " + userId);
        return songDAO.getLikedSongs(userId);
    }
}
