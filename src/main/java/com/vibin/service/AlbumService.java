package com.vibin.service;

import java.sql.SQLException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.dao.AlbumDAO;
import com.vibin.model.Album;
import com.vibin.util.LoggerUtil;

/**
 * Service class for handling business logic related to albums
 */
public class AlbumService {
    private static final Logger logger = LoggerFactory.getLogger(AlbumService.class);
    private AlbumDAO albumDAO;
    
    /**
     * Constructor initializing the DAO
     */
    public AlbumService() {
        this.albumDAO = new AlbumDAO();
    }
    
    /**
     * Get all albums from the database
     * 
     * @return List of all albums
     * @throws SQLException if a database error occurs
     */
    public List<Album> getAllAlbums() throws SQLException {
        LoggerUtil.info(logger, "Getting all albums");
        return albumDAO.getAllAlbums();
    }
    
    /**
     * Get album by ID
     * 
     * @param id The album ID
     * @return Album object if found, null otherwise
     * @throws SQLException if a database error occurs
     */
    public Album getAlbum(int id) throws SQLException {
        LoggerUtil.info(logger, "Getting album with ID: " + id);
        return albumDAO.getAlbumById(id);
    }
    
    /**
     * Insert a new album
     * 
     * @param album The album to insert
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean insertAlbum(Album album) throws SQLException {
        LoggerUtil.info(logger, "Inserting new album: " + album.getAlbumName());
        return albumDAO.insertAlbum(album);
    }
    
    /**
     * Update an existing album
     * 
     * @param album The album to update
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean updateAlbum(Album album) throws SQLException {
        LoggerUtil.info(logger, "Updating album with ID: " + album.getAlbumId());
        return albumDAO.updateAlbum(album);
    }
    
    /**
     * Delete an album by ID
     * 
     * @param id The album ID to delete
     * @return true if successful, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean deleteAlbum(int id) throws SQLException {
        LoggerUtil.info(logger, "Deleting album with ID: " + id);
        return albumDAO.deleteAlbum(id);
    }
    
    /**
     * Search albums by name
     * 
     * @param name The name to search for
     * @return List of matching albums
     * @throws SQLException if a database error occurs
     */
    public List<Album> searchAlbumsByName(String name) throws SQLException {
        LoggerUtil.info(logger, "Searching albums with name containing: " + name);
        return albumDAO.searchAlbumsByName(name);
    }
    
    /**
     * Get albums by artist
     * 
     * @param artist The artist name
     * @return List of albums by the specified artist
     * @throws SQLException if a database error occurs
     */
    public List<Album> getAlbumsByArtist(String artist) throws SQLException {
        LoggerUtil.info(logger, "Getting albums by artist: " + artist);
        return albumDAO.getAlbumsByArtist(artist);
    }
    
    /**
     * Get albums by genre
     * 
     * @param genre The genre to filter by
     * @return List of albums in the specified genre
     * @throws SQLException if a database error occurs
     */
    public List<Album> getAlbumsByGenre(String genre) throws SQLException {
        LoggerUtil.info(logger, "Getting albums with genre: " + genre);
        return albumDAO.getAlbumsByGenre(genre);
    }
}
