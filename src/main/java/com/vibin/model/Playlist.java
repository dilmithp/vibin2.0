package com.vibin.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Model class representing a playlist in the Vibin music store application.
 */
public class Playlist implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int playlistId;
    private String playlistName;
    private int userId;
    private Timestamp createdDate;
    private String description;
    private List<Song> songs;
    
    /**
     * Default constructor
     */
    public Playlist() {
        this.songs = new ArrayList<>();
    }
    
    /**
     * Constructor with essential fields
     */
    public Playlist(String playlistName, int userId) {
        this.playlistName = playlistName;
        this.userId = userId;
        this.createdDate = new Timestamp(System.currentTimeMillis());
        this.songs = new ArrayList<>();
    }
    
    /**
     * Constructor with all fields
     */
    public Playlist(int playlistId, String playlistName, int userId, Timestamp createdDate, String description) {
        this.playlistId = playlistId;
        this.playlistName = playlistName;
        this.userId = userId;
        this.createdDate = createdDate;
        this.description = description;
        this.songs = new ArrayList<>();
    }
    
    // Getters and Setters
    public int getPlaylistId() {
        return playlistId;
    }
    
    public void setPlaylistId(int playlistId) {
        this.playlistId = playlistId;
    }
    
    public String getPlaylistName() {
        return playlistName;
    }
    
    public void setPlaylistName(String playlistName) {
        this.playlistName = playlistName;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public List<Song> getSongs() {
        return songs;
    }
    
    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }
    
    // Playlist management methods
    public void addSong(Song song) {
        if (!songs.contains(song)) {
            songs.add(song);
        }
    }
    
    public void removeSong(Song song) {
        songs.remove(song);
    }
    
    public int getSongCount() {
        return songs.size();
    }
    
    @Override
    public String toString() {
        return "Playlist{" +
                "playlistId=" + playlistId +
                ", playlistName='" + playlistName + '\'' +
                ", userId=" + userId +
                ", createdDate=" + createdDate +
                ", songCount=" + getSongCount() +
                '}';
    }
}
