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

import com.vibin.model.Playlist;
import com.vibin.model.Song;
import com.vibin.service.PlaylistService;
import com.vibin.service.SongService;
import com.vibin.util.LoggerUtil;

@WebServlet("/playlists/*")
public class PlaylistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(PlaylistServlet.class);
    
    private PlaylistService playlistService;
    private SongService songService;
    
    public void init() {
        playlistService = new PlaylistService();
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
                case "/create":
                    createPlaylist(request, response);
                    break;
                case "/delete":
                    deletePlaylist(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updatePlaylist(request, response);
                    break;
                case "/view":
                    viewPlaylist(request, response);
                    break;
                case "/add-song":
                    addSongToPlaylist(request, response);
                    break;
                case "/remove-song":
                    removeSongFromPlaylist(request, response);
                    break;
                default:
                    listPlaylists(request, response);
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
    
    private void listPlaylists(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            // User is not logged in, redirect to login page
            LoggerUtil.warn(logger, "Attempt to access playlists without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        LoggerUtil.info(logger, "Fetching playlists for user ID: " + userId);
        List<Playlist> listPlaylist = playlistService.getUserPlaylists(userId);
        request.setAttribute("listPlaylist", listPlaylist);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/playlists.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("id") == null) {
            LoggerUtil.warn(logger, "Attempt to access new playlist form without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        LoggerUtil.info(logger, "Showing new playlist form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/playlist/playlist-create.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to edit playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Showing edit form for playlist ID: " + id);
        
        Playlist existingPlaylist = playlistService.getPlaylist(id);
        
        if (existingPlaylist == null) {
            LoggerUtil.warn(logger, "Playlist not found with ID: " + id);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        // Check if the playlist belongs to the current user
        if (existingPlaylist.getUserId() != userId) {
            LoggerUtil.warn(logger, "Unauthorized attempt to edit playlist ID: " + id + " by user ID: " + userId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        request.setAttribute("playlist", existingPlaylist);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/playlist/playlist-create.jsp");
        dispatcher.forward(request, response);
    }

    private void createPlaylist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to create playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        String playlistName = request.getParameter("playlistName");
        String description = request.getParameter("description");
        
        LoggerUtil.info(logger, "Creating new playlist: " + playlistName + " for user ID: " + userId);
        
        Playlist newPlaylist = new Playlist();
        newPlaylist.setPlaylistName(playlistName);
        newPlaylist.setDescription(description);
        newPlaylist.setUserId(userId);
        
        playlistService.createPlaylist(newPlaylist);
        response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
    }

    private void updatePlaylist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to update playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        int id = Integer.parseInt(request.getParameter("id"));
        String playlistName = request.getParameter("playlistName");
        String description = request.getParameter("description");
        
        LoggerUtil.info(logger, "Updating playlist ID: " + id);
        
        Playlist existingPlaylist = playlistService.getPlaylist(id);
        
        if (existingPlaylist == null) {
            LoggerUtil.warn(logger, "Playlist not found with ID: " + id);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        // Check if the playlist belongs to the current user
        if (existingPlaylist.getUserId() != userId) {
            LoggerUtil.warn(logger, "Unauthorized attempt to update playlist ID: " + id + " by user ID: " + userId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        existingPlaylist.setPlaylistName(playlistName);
        existingPlaylist.setDescription(description);
        
        playlistService.updatePlaylist(existingPlaylist);
        response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
    }

    private void deletePlaylist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to delete playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        // Add null check for the id parameter
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            LoggerUtil.error(logger, "Playlist ID parameter is missing");
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        int id = Integer.parseInt(idParam);
        
        Playlist existingPlaylist = playlistService.getPlaylist(id);
        
        if (existingPlaylist == null) {
            LoggerUtil.warn(logger, "Playlist not found with ID: " + id);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        // Check if the playlist belongs to the current user
        if (existingPlaylist.getUserId() != userId) {
            LoggerUtil.warn(logger, "Unauthorized attempt to delete playlist ID: " + id + " by user ID: " + userId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        LoggerUtil.info(logger, "Deleting playlist ID: " + id);
        playlistService.deletePlaylist(id);
        response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
    }

    
    private void viewPlaylist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        if (session.getAttribute("id") == null) {
            LoggerUtil.warn(logger, "Attempt to view playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Viewing playlist ID: " + id);
        
        Playlist playlist = playlistService.getPlaylist(id);
        
        if (playlist == null) {
            LoggerUtil.warn(logger, "Playlist not found with ID: " + id);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        List<Song> playlistSongs = playlistService.getPlaylistSongs(id);
        
        request.setAttribute("playlist", playlist);
        request.setAttribute("playlistSongs", playlistSongs);
        
        // Get all songs for adding to playlist
        List<Song> allSongs = songService.getAllSongs();
        request.setAttribute("allSongs", allSongs);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/playlist/playlist-view.jsp");
        dispatcher.forward(request, response);
    }
    
    private void addSongToPlaylist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to add song to playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        int playlistId = Integer.parseInt(request.getParameter("playlistId"));
        int songId = Integer.parseInt(request.getParameter("songId"));
        
        Playlist existingPlaylist = playlistService.getPlaylist(playlistId);
        
        if (existingPlaylist == null) {
            LoggerUtil.warn(logger, "Playlist not found with ID: " + playlistId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        // Check if the playlist belongs to the current user
        if (existingPlaylist.getUserId() != userId) {
            LoggerUtil.warn(logger, "Unauthorized attempt to add song to playlist ID: " + playlistId + " by user ID: " + userId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        LoggerUtil.info(logger, "Adding song ID: " + songId + " to playlist ID: " + playlistId);
        playlistService.addSongToPlaylist(playlistId, songId);
        response.sendRedirect(request.getContextPath() + "/playlists/view?id=" + playlistId);
    }
    
    private void removeSongFromPlaylist(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("id");
        
        if (userIdObj == null) {
            LoggerUtil.warn(logger, "Attempt to remove song from playlist without being logged in");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        int userId = userIdObj.intValue();
        
        int playlistId = Integer.parseInt(request.getParameter("playlistId"));
        int songId = Integer.parseInt(request.getParameter("songId"));
        
        Playlist existingPlaylist = playlistService.getPlaylist(playlistId);
        
        if (existingPlaylist == null) {
            LoggerUtil.warn(logger, "Playlist not found with ID: " + playlistId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        // Check if the playlist belongs to the current user
        if (existingPlaylist.getUserId() != userId) {
            LoggerUtil.warn(logger, "Unauthorized attempt to remove song from playlist ID: " + playlistId + " by user ID: " + userId);
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
        
        LoggerUtil.info(logger, "Removing song ID: " + songId + " from playlist ID: " + playlistId);
        playlistService.removeSongFromPlaylist(playlistId, songId);
        response.sendRedirect(request.getContextPath() + "/playlists/view?id=" + playlistId);
    }
}
