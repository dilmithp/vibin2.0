package com.vibin.util;

/**
 * Constants class for the Vibin online music store application.
 * Contains application-wide constant values.
 */
public class Constants {
    
    // Prevent instantiation
    private Constants() {
        // Utility class, no instantiation needed
    }
    
    // Database related constants
    public static final String DB_NAME = "loginjsp";
    public static final String DB_USER_TABLE = "user";
    public static final String DB_ALBUM_TABLE = "albums";
    public static final String DB_SONG_TABLE = "songs";
    public static final String DB_PLAYLIST_TABLE = "playlists";
    public static final String DB_PLAYLIST_SONGS_TABLE = "playlist_songs";
    public static final String DB_LIKED_SONGS_TABLE = "liked_songs";
    public static final String DB_ARTIST_TABLE = "artists";
    public static final String DB_ADMIN_TABLE = "admin";
    public static final String DB_ARTIST_LOGIN_TABLE = "artist_login";
    
    // Session attribute names
    public static final String SESSION_USER_ID = "id";
    public static final String SESSION_USER_NAME = "name";
    public static final String SESSION_USER_EMAIL = "email";
    public static final String SESSION_ARTIST_ID = "artistId";
    public static final String SESSION_ARTIST_NAME = "artistName";
    public static final String SESSION_ADMIN_ID = "adminId";
    public static final String SESSION_ADMIN_NAME = "adminName";
    
    // Page paths
    public static final String PATH_HOME = "/user/index.jsp";
    public static final String PATH_LOGIN = "/auth/login.jsp";
    public static final String PATH_REGISTER = "/auth/register.jsp";
    public static final String PATH_ADMIN_DASHBOARD = "/admin/admin-dashboard.jsp";
    public static final String PATH_ARTIST_DASHBOARD = "/artist/artist-dashboard.jsp";
    
    // Error messages
    public static final String ERROR_LOGIN_FAILED = "Invalid username/email or password.";
    public static final String ERROR_REGISTRATION_FAILED = "Registration failed. Please try again.";
    public static final String ERROR_EMAIL_EXISTS = "Email is already registered.";
    public static final String ERROR_PASSWORDS_DONT_MATCH = "Passwords do not match.";
    public static final String ERROR_UNAUTHORIZED = "You are not authorized to access this resource.";
    
    // Success messages
    public static final String SUCCESS_REGISTRATION = "Account created successfully! Please log in.";
    public static final String SUCCESS_PROFILE_UPDATE = "Profile updated successfully.";
    public static final String SUCCESS_PASSWORD_CHANGE = "Password changed successfully.";
    
    // File upload constants
    public static final String UPLOAD_DIRECTORY = "images";
    public static final int MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    public static final String[] ALLOWED_IMAGE_TYPES = {"image/jpeg", "image/png", "image/gif"};
}
