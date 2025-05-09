package com.vibin.model;

import java.io.Serializable;

/**
 * Model class representing a song in the Vibin music store application.
 */
public class Song implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int songId;
    private String songName;
    private String lyricist;
    private String singer;
    private String musicDirector;
    private int albumId;
    
    /**
     * Default constructor
     */
    public Song() {
    }
    
    /**
     * Constructor with all fields
     */
    public Song(int songId, String songName, String singer, String lyricist, String musicDirector, int albumId) {
        this.songId = songId;
        this.songName = songName;
        this.singer = singer;
        this.lyricist = lyricist;
        this.musicDirector = musicDirector;
        this.albumId = albumId;
    }
    
    // Getters and Setters
    public int getSongId() {
        return songId;
    }
    
    public void setSongId(int songId) {
        this.songId = songId;
    }
    
    public String getSongName() {
        return songName;
    }
    
    public void setSongName(String songName) {
        this.songName = songName;
    }
    
    public String getLyricist() {
        return lyricist;
    }
    
    public void setLyricist(String lyricist) {
        this.lyricist = lyricist;
    }
    
    public String getSinger() {
        return singer;
    }
    
    public void setSinger(String singer) {
        this.singer = singer;
    }
    
    public String getMusicDirector() {
        return musicDirector;
    }
    
    public void setMusicDirector(String musicDirector) {
        this.musicDirector = musicDirector;
    }
    
    public int getAlbumId() {
        return albumId;
    }
    
    public void setAlbumId(int albumId) {
        this.albumId = albumId;
    }
    
    @Override
    public String toString() {
        return "Song{" +
                "songId=" + songId +
                ", songName='" + songName + '\'' +
                ", singer='" + singer + '\'' +
                ", lyricist='" + lyricist + '\'' +
                ", musicDirector='" + musicDirector + '\'' +
                ", albumId=" + albumId +
                '}';
    }
}
