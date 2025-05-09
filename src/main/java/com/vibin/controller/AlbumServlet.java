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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.vibin.model.Album;
import com.vibin.service.AlbumService;
import com.vibin.service.SongService;
import com.vibin.util.LoggerUtil;

@WebServlet("/albums/*")
public class AlbumServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(AlbumServlet.class);
    
    private AlbumService albumService;
    private SongService songService;
    
    public void init() {
        albumService = new AlbumService();
        songService = new SongService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
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
                    insertAlbum(request, response);
                    break;
                case "/delete":
                    deleteAlbum(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateAlbum(request, response);
                    break;
                case "/view":
                    viewAlbum(request, response);
                    break;
                case "/add":
                    insertAlbum(request, response);
                    break;
                default:
                    listAlbums(request, response);
                    break;
            }
        } catch (SQLException ex) {
            LoggerUtil.error(logger, "Database error occurred: " + ex.getMessage(), ex);
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void listAlbums(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        LoggerUtil.info(logger, "Fetching all albums");
        List<Album> listAlbum = albumService.getAllAlbums();
        request.setAttribute("listAlbum", listAlbum);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-albums.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        LoggerUtil.info(logger, "Showing new album form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-album-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Showing edit form for album ID: " + id);
        Album existingAlbum = albumService.getAlbum(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-album-form.jsp");
        request.setAttribute("album", existingAlbum);
        dispatcher.forward(request, response);
    }

    private void insertAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String albumName = request.getParameter("albumName");
        String artist = request.getParameter("artist");
        String genre = request.getParameter("genre");
        String releaseDate = request.getParameter("releaseDate");
        
        LoggerUtil.info(logger, "Creating new album: " + albumName);
        
        Album newAlbum = new Album(0, albumName, artist, genre, releaseDate);
        albumService.insertAlbum(newAlbum);
        
        // Check if request came from artist dashboard
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/artist/artist-dashboard")) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/albums");
        }
    }

    private void updateAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String albumName = request.getParameter("albumName");
        String artist = request.getParameter("artist");
        String genre = request.getParameter("genre");
        String releaseDate = request.getParameter("releaseDate");
        
        LoggerUtil.info(logger, "Updating album ID: " + id);
        
        Album album = new Album(id, albumName, artist, genre, releaseDate);
        albumService.updateAlbum(album);
        
        // Check if request came from artist dashboard
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/artist/artist-dashboard")) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/albums");
        }
    }

    private void deleteAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Deleting album ID: " + id);
        albumService.deleteAlbum(id);
        
        // Check if request came from artist dashboard
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/artist/artist-dashboard")) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/albums");
        }
    }
    
    private void viewAlbum(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Viewing album ID: " + id);
        
        Album album = albumService.getAlbum(id);
        request.setAttribute("album", album);
        
        // Get songs in this album
        request.setAttribute("albumSongs", songService.getSongsByAlbum(id));
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/album-view.jsp");
        dispatcher.forward(request, response);
    }
}
