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
import com.vibin.service.ArtistService;
import com.vibin.util.LoggerUtil;

@WebServlet(urlPatterns = {"/artist/login", "/artist/register", "/artist/logout", "/artist/artist-dashboard", "/artists/*"})
public class ArtistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(ArtistServlet.class);
    
    private ArtistService artistService;
    
    public void init() {
        artistService = new ArtistService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        logger.info("GET request URI: " + uri);
        
        if (uri.endsWith("/artist/artist-login.jsp")) {
            showArtistLoginForm(request, response);
        } else if (uri.endsWith("/artist/artist-register.jsp")) {
            showArtistRegisterForm(request, response);
        } else if (uri.endsWith("/artist/login")) {
            showArtistLoginForm(request, response);
        } else if (uri.endsWith("/artist/register")) {
            showArtistRegisterForm(request, response);
        } else if (uri.endsWith("/artist/artist-dashboard")) {
            showArtistDashboard(request, response);
        } else if (uri.endsWith("/artist/logout")) {
            logoutArtist(request, response);
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
            response.sendRedirect(request.getContextPath() + "/artist/artist-login.jsp");
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
        response.sendRedirect(request.getContextPath() + "/artist/artist-login.jsp");
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
                response.sendRedirect(request.getContextPath() + "/artist/artist-login.jsp?success=Registration successful");
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
}
