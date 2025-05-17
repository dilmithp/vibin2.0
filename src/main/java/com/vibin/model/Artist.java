package com.vibin.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Model class representing an artist in the Vibin music store application.
 */
public class Artist implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int artistId;
    private String artistName;
    private String bio;
    private String imageUrl;
    private String genre;
    private String country;
    private Timestamp createdDate;
    private String email;
    

    public Artist() {
    }
    

    public Artist(String artistName, String genre) {
        this.artistName = artistName;
        this.genre = genre;
        this.createdDate = new Timestamp(System.currentTimeMillis());
    }

    public Artist(int artistId, String artistName, String bio, String imageUrl, 
                 String genre, String country, Timestamp createdDate, String email) {
        this.artistId = artistId;
        this.artistName = artistName;
        this.bio = bio;
        this.imageUrl = imageUrl;
        this.genre = genre;
        this.country = country;
        this.createdDate = createdDate;
        this.email = email;
    }
    
    public int getArtistId() {
        return artistId;
    }
    
    public void setArtistId(int artistId) {
        this.artistId = artistId;
    }
    
    public String getArtistName() {
        return artistName;
    }
    
    public void setArtistName(String artistName) {
        this.artistName = artistName;
    }
    
    public String getBio() {
        return bio;
    }
    
    public void setBio(String bio) {
        this.bio = bio;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }
    
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    public String getGenre() {
        return genre;
    }
    
    public void setGenre(String genre) {
        this.genre = genre;
    }
    
    public String getCountry() {
        return country;
    }
    
    public void setCountry(String country) {
        this.country = country;
    }
    
    public Timestamp getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    @Override
    public String toString() {
        return "Artist{" +
                "artistId=" + artistId +
                ", artistName='" + artistName + '\'' +
                ", genre='" + genre + '\'' +
                ", country='" + country + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
