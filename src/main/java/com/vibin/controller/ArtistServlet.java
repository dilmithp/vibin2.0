package com.vibin.controller;

import java.io.IOException;

import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.model.Artist;
import com.vibin.model.Album;
import com.vibin.model.Song;
import com.vibin.service.ArtistService;
import com.vibin.service.AlbumService;
import com.vibin.service.SongService;
import com.vibin.util.LoggerUtil;

@WebServlet(urlPatterns = {
    "/artist/login", 
    "/artist/register", 
    "/artist/logout", 
    "/artist/artist-dashboard", 
    "/artist/edit-song", 
    "/artist/update-song",
    "/artist/delete-song",
    "/artist/add-song",
    "/artist/edit-album",
    "/artist/update-album",
    "/artist/delete-album",
    "/artist/add-album",
    "/artist/view",
    "/artists/*"
})
public class ArtistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(ArtistServlet.class);
    
    private ArtistService artistService;
    private AlbumService albumService;
    private SongService songService;
    
    public void init() {
        artistService = new ArtistService();
        albumService = new AlbumService();
        songService = new SongService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        logger.info("GET request URI: " + uri);
        
        // Important: Do NOT check for .jsp files to avoid infinite recursion
        if (uri.endsWith("/artist/login")) {
            showArtistLoginForm(request, response);
        } else if (uri.endsWith("/artist/register")) {
            showArtistRegisterForm(request, response);
        } else if (uri.endsWith("/artist/artist-dashboard")) {
            showArtistDashboard(request, response);
        } else if (uri.endsWith("/artist/logout")) {
            logoutArtist(request, response);
        } else if (uri.endsWith("/artist/edit-song")) {
            showEditSongForm(request, response);
        } else if (uri.endsWith("/artist/delete-song")) {
            deleteSong(request, response);
        } else if (uri.endsWith("/artist/add-song")) {
            showAddSongForm(request, response);
        } else if (uri.endsWith("/artist/edit-album")) {
            showEditAlbumForm(request, response);
        } else if (uri.endsWith("/artist/delete-album")) {
            deleteAlbum(request, response);
        } else if (uri.endsWith("/artist/add-album")) {
            showAddAlbumForm(request, response);
        } else {
            // Handle admin artist management paths
            String action = request.getPathInfo();
            
            if (action == null) {
                action = "/list";
            }
            
            try {
                switch (action) {
                    case "/new":
                        showNewForm(request, response);
                        break;
                    case "/insert":
                        insertArtist(request, response);
                        break;
                    case "/delete":
                        deleteArtist(request, response);
                        break;
                    case "/edit":
                        showEditForm(request, response);
                        break;
                    case "/update":
                        updateArtist(request, response);
                        break;
                    case "/view":
                        viewArtist(request, response);
                        break;
                    default:
                        listArtists(request, response);
                        break;
                }
            } catch (SQLException ex) {
                logger.error("Database error occurred", ex);
                throw new ServletException(ex);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        logger.info("POST request URI: " + uri);
        
        if (uri.endsWith("/artist/login")) {
            artistLogin(request, response);
        } else if (uri.endsWith("/artist/register")) {
            artistRegister(request, response);
        } else if (uri.endsWith("/artist/add-song")) {
            addSong(request, response);
        } else if (uri.endsWith("/artist/update-song")) {
            updateSong(request, response);
        } else if (uri.endsWith("/artist/add-album")) {
            addAlbum(request, response);
        } else if (uri.endsWith("/artist/update-album")) {
            updateAlbum(request, response);
        } else {
            // Handle admin artist management
            doGet(request, response);
        }
    }
    
    private void showArtistLoginForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("Showing artist login form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-login.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showArtistRegisterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("Showing artist registration form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-register.jsp");
        dispatcher.forward(request, response);
    }
    
    private void showArtistDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        logger.info("Showing artist dashboard for artist ID: " + session.getAttribute("artistId"));
        RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-dashboard.jsp");
        dispatcher.forward(request, response);
    }
    
    private void logoutArtist(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            logger.info("Artist logged out: " + session.getAttribute("artistName"));
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/artist/login");
    }
    
    private void artistLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email"); 
        String password = request.getParameter("password");
        
        logger.info("Artist login attempt for: " + email);
        
        try {
            // Pass the email as the username to the authentication method
            Artist artist = artistService.authenticateArtist(email, password);
            
            if (artist != null) {
                // Create session for artist
                HttpSession session = request.getSession();
                session.setAttribute("artistId", artist.getArtistId());
                session.setAttribute("artistName", artist.getArtistName());
                session.setAttribute("artistEmail", artist.getEmail());
                session.setAttribute("userType", "artist");
                
                logger.info("Artist logged in successfully: " + email);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            } else {
                logger.warn("Artist login failed for: " + email);
                request.setAttribute("error", "Invalid email or password");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-login.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            logger.error("Database error during artist login: " + e.getMessage(), e);
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-login.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    private void artistRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String artistName = request.getParameter("artistName");
        String email = request.getParameter("email");
        String username = email;
        String password = request.getParameter("password");
        String genre = request.getParameter("genre");
        String country = request.getParameter("country");
        String bio = request.getParameter("bio");
        String agreeTerms = request.getParameter("agree-term");
        
        logger.info("Artist registration attempt for: " + username);
        
        // Validate form data
        if (artistName == null || artistName.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            genre == null || genre.trim().isEmpty() || 
            country == null || country.trim().isEmpty() || 
            agreeTerms == null) {
            
            logger.warn("Artist registration failed: Missing required fields");
            request.setAttribute("error", "All fields are required");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-register.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        try {
            // Check if username (email) already exists
            if (artistService.usernameExists(username)) {
                logger.warn("Artist registration failed - username already exists: " + username);
                request.setAttribute("error", "Email already registered as username");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-register.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Check if email already exists
            if (artistService.emailExists(email)) {
                logger.warn("Artist registration failed - email already exists: " + email);
                request.setAttribute("error", "Email already registered");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-register.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Create new artist
            Artist newArtist = new Artist();
            newArtist.setArtistName(artistName);
            newArtist.setEmail(email);
            newArtist.setGenre(genre);
            newArtist.setCountry(country);
            newArtist.setBio(bio);
            
            // Register artist with email as username and password
            boolean registered = artistService.registerArtist(newArtist, username, password);
            
            if (registered) {
                logger.info("Artist registered successfully: " + username);
                response.sendRedirect(request.getContextPath() + "/artist/login?success=Registration successful");
            } else {
                logger.error("Artist registration failed for: " + username);
                request.setAttribute("error", "Registration failed");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-register.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException e) {
            logger.error("Database error during artist registration: " + e.getMessage(), e);
            request.setAttribute("error", "Database error: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-register.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    // Admin panel methods for artist management
    private void listArtists(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        logger.info("Fetching all artists");
        List<Artist> listArtist = artistService.getAllArtists();
        request.setAttribute("listArtist", listArtist);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-artists.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("Showing new artist form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-artist-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Showing edit form for artist ID: " + id);
        Artist existingArtist = artistService.getArtist(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-artist-form.jsp");
        request.setAttribute("artist", existingArtist);
        dispatcher.forward(request, response);
    }

    private void insertArtist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String artistName = request.getParameter("artistName");
        String genre = request.getParameter("genre");
        String country = request.getParameter("country");
        String bio = request.getParameter("bio");
        String email = request.getParameter("email");
        
        logger.info("Creating new artist: " + artistName);
        
        Artist newArtist = new Artist();
        newArtist.setArtistName(artistName);
        newArtist.setGenre(genre);
        newArtist.setCountry(country);
        newArtist.setBio(bio);
        newArtist.setEmail(email);
        
        artistService.insertArtist(newArtist);
        response.sendRedirect(request.getContextPath() + "/artists");
    }

    private void updateArtist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String artistName = request.getParameter("artistName");
        String genre = request.getParameter("genre");
        String country = request.getParameter("country");
        String bio = request.getParameter("bio");
        String email = request.getParameter("email");
        String imageUrl = request.getParameter("imageUrl");
        
        logger.info("Updating artist ID: " + id);
        
        Artist artist = artistService.getArtist(id);
        artist.setArtistName(artistName);
        artist.setGenre(genre);
        artist.setCountry(country);
        artist.setBio(bio);
        artist.setEmail(email);
        
        if (imageUrl != null && !imageUrl.isEmpty()) {
            artist.setImageUrl(imageUrl);
        }
        
        artistService.updateArtist(artist);
        response.sendRedirect(request.getContextPath() + "/artists");
    }

    private void deleteArtist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Deleting artist ID: " + id);
        artistService.deleteArtist(id);
        response.sendRedirect(request.getContextPath() + "/artists");
    }
    
    private void viewArtist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        logger.info("Viewing artist ID: " + id);
        
        Artist artist = artistService.getArtist(id);
        request.setAttribute("artist", artist);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/artist-view.jsp");
        dispatcher.forward(request, response);
    }
    
    // Artist song management methods
    private void showEditSongForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get song ID from request
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            int songId = Integer.parseInt(idParam);
            
            // Get song details
            Song song = songService.getSong(songId);
            
            // Verify this song belongs to the logged-in artist
            if (song == null || !song.getSinger().equals(artistName)) {
                logger.warn("Unauthorized attempt to edit song ID: " + songId + " by artist: " + artistName);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            // Get albums for dropdown
            List<Album> artistAlbums = albumService.getAlbumsByArtist(artistName);
            
            // Set attributes for JSP
            request.setAttribute("song", song);
            request.setAttribute("artistAlbums", artistAlbums);
            
            // Forward to edit form
            logger.info("Showing edit song form for song ID: " + songId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/edit-song.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.error("Invalid song ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when fetching song details", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void updateSong(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get form data
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            int songId = Integer.parseInt(idParam);
            String songName = request.getParameter("songName");
            String albumIdStr = request.getParameter("albumId");
            int albumId = albumIdStr != null && !albumIdStr.isEmpty() ? Integer.parseInt(albumIdStr) : 0;
            String lyricist = request.getParameter("lyricist");
            String musicDirector = request.getParameter("musicDirector");
            
            // Get existing song
            Song song = songService.getSong(songId);
            
            // Verify this song belongs to the logged-in artist
            if (song == null || !song.getSinger().equals(artistName)) {
                logger.warn("Unauthorized attempt to update song ID: " + songId + " by artist: " + artistName);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            // Update song details
            song.setSongName(songName);
            song.setAlbumId(albumId);
            song.setLyricist(lyricist);
            song.setMusicDirector(musicDirector);
            
            // Save changes
            songService.updateSong(song);
            
            logger.info("Song updated successfully: " + songId);
            
            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            
        } catch (NumberFormatException e) {
            logger.error("Invalid song ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when updating song", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void deleteSong(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get song ID from request
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            int songId = Integer.parseInt(idParam);
            
            // Get song details
            Song song = songService.getSong(songId);
            
            // Verify this song belongs to the logged-in artist
            if (song == null || !song.getSinger().equals(artistName)) {
                logger.warn("Unauthorized attempt to delete song ID: " + songId + " by artist: " + artistName);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            // Delete the song
            songService.deleteSong(songId);
            
            logger.info("Song deleted successfully: " + songId);
            
            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            
        } catch (NumberFormatException e) {
            logger.error("Invalid song ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when deleting song", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void showAddSongForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get albums for dropdown
            List<Album> artistAlbums = albumService.getAlbumsByArtist(artistName);
            
            // Set attributes for JSP
            request.setAttribute("artistAlbums", artistAlbums);
            
            // Forward to add form
            logger.info("Showing add song form for artist: " + artistName);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/add-song.jsp");
            dispatcher.forward(request, response);
            
        } catch (SQLException e) {
            logger.error("Database error when fetching albums", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void addSong(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get form data
            String songName = request.getParameter("songName");
            String albumIdStr = request.getParameter("albumId");
            int albumId = albumIdStr != null && !albumIdStr.isEmpty() ? Integer.parseInt(albumIdStr) : 0;
            String lyricist = request.getParameter("lyricist");
            String musicDirector = request.getParameter("musicDirector");
            
            // Create new song
            Song newSong = new Song();
            newSong.setSongName(songName);
            newSong.setSinger(artistName);
            newSong.setAlbumId(albumId);
            newSong.setLyricist(lyricist);
            newSong.setMusicDirector(musicDirector);
            
            // Save song
            songService.insertSong(newSong);
            
            logger.info("Song added successfully by artist: " + artistName);
            
            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            
        } catch (NumberFormatException e) {
            logger.error("Invalid album ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when adding song", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    // Artist album management methods
    private void showEditAlbumForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get album ID from request
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            int albumId = Integer.parseInt(idParam);
            
            // Get album details
            Album album = albumService.getAlbum(albumId);
            
            // Verify this album belongs to the logged-in artist
            if (album == null || !album.getArtist().equals(artistName)) {
                logger.warn("Unauthorized attempt to edit album ID: " + albumId + " by artist: " + artistName);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            // Set attributes for JSP
            request.setAttribute("album", album);
            
            // Forward to edit form
            logger.info("Showing edit album form for album ID: " + albumId);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/edit-album.jsp");
            dispatcher.forward(request, response);
            
        } catch (NumberFormatException e) {
            logger.error("Invalid album ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when fetching album details", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void updateAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get form data
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            int albumId = Integer.parseInt(idParam);
            String albumName = request.getParameter("albumName");
            String genre = request.getParameter("genre");
            String releaseDate = request.getParameter("releaseDate");
            
            // Get existing album
            Album album = albumService.getAlbum(albumId);
            
            // Verify this album belongs to the logged-in artist
            if (album == null || !album.getArtist().equals(artistName)) {
                logger.warn("Unauthorized attempt to update album ID: " + albumId + " by artist: " + artistName);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            // Update album details
            album.setAlbumName(albumName);
            album.setGenre(genre);
            album.setReleaseDate(releaseDate);
            
            // Save changes
            albumService.updateAlbum(album);
            
            logger.info("Album updated successfully: " + albumId);
            
            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            
        } catch (NumberFormatException e) {
            logger.error("Invalid album ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when updating album", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void deleteAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get album ID from request
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            int albumId = Integer.parseInt(idParam);
            
            // Get album details
            Album album = albumService.getAlbum(albumId);
            
            // Verify this album belongs to the logged-in artist
            if (album == null || !album.getArtist().equals(artistName)) {
                logger.warn("Unauthorized attempt to delete album ID: " + albumId + " by artist: " + artistName);
                response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
                return;
            }
            
            // Delete the album
            albumService.deleteAlbum(albumId);
            
            logger.info("Album deleted successfully: " + albumId);
            
            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            
        } catch (NumberFormatException e) {
            logger.error("Invalid album ID format", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } catch (SQLException e) {
            logger.error("Database error when deleting album", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
    
    private void showAddAlbumForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        // Forward to add form
        logger.info("Showing add album form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/artist/add-album.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if artist is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/login");
            return;
        }
        
        String artistName = (String) session.getAttribute("artistName");
        
        try {
            // Get form data
            String albumName = request.getParameter("albumName");
            String genre = request.getParameter("genre");
            String releaseDate = request.getParameter("releaseDate");
            
            // Create new album
            Album newAlbum = new Album();
            newAlbum.setAlbumName(albumName);
            newAlbum.setArtist(artistName);
            newAlbum.setGenre(genre);
            newAlbum.setReleaseDate(releaseDate);
            
            // Save album
            albumService.insertAlbum(newAlbum);
            
            logger.info("Album added successfully by artist: " + artistName);
            
            // Redirect back to dashboard
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
            
        } catch (SQLException e) {
            logger.error("Database error when adding album", e);
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        }
    }
}
