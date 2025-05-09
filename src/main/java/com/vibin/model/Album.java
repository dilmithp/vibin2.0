package com.vibin.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Model class representing an album in the Vibin music store application.
 */
public class Album implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int albumId;
    private String albumName;
    private String artist;
    private String releaseDate;
    private String genre;
    private List<Song> songs;
    
    /**
     * Default constructor
     */
    public Album() {
        this.songs = new ArrayList<>();
    }
    
    /**
     * Constructor with essential fields
     */
    public Album(String albumName, String artist, String genre) {
        this.albumName = albumName;
        this.artist = artist;
        this.genre = genre;
        this.songs = new ArrayList<>();
    }
    
    /**
     * Constructor with all fields
     */
    public Album(int albumId, String albumName, String artist, String genre, String releaseDate) {
        this.albumId = albumId;
        this.albumName = albumName;
        this.artist = artist;
        this.genre = genre;
        this.releaseDate = releaseDate;
        this.songs = new ArrayList<>();
    }
    
    // Getters and Setters
    public int getAlbumId() {
        return albumId;
    }
    
    public void setAlbumId(int albumId) {
        this.albumId = albumId;
    }
    
    public String getAlbumName() {
        return albumName;
    }
    
    public void setAlbumName(String albumName) {
        this.albumName = albumName;
    }
    
    public String getArtist() {
        return artist;
    }
    
    public void setArtist(String artist) {
        this.artist = artist;
    }
    
    public String getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(String releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public String getGenre() {
        return genre;
    }
    
    public void setGenre(String genre) {
        this.genre = genre;
    }
    
    public List<Song> getSongs() {
        return songs;
    }
    
    public void setSongs(List<Song> songs) {
        this.songs = songs;
    }
    
    // Album management methods
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
        return "Album{" +
                "albumId=" + albumId +
                ", albumName='" + albumName + '\'' +
                ", artist='" + artist + '\'' +
                ", releaseDate='" + releaseDate + '\'' +
                ", genre='" + genre + '\'' +
                ", songCount=" + getSongCount() +
                '}';
    }
}
