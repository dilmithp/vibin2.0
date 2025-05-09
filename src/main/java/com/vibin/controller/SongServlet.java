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

import com.vibin.model.Song;
import com.vibin.service.SongService;
import com.vibin.util.LoggerUtil;

@WebServlet("/songs/*")
public class SongServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(SongServlet.class);
    
    private SongService songService;
    
    public void init() {
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
                    insertSong(request, response);
                    break;
                case "/delete":
                    deleteSong(request, response);
                    break;
                case "/edit":
                    showEditForm(request, response);
                    break;
                case "/update":
                    updateSong(request, response);
                    break;
                case "/view":
                    viewSong(request, response);
                    break;
                case "/add":
                    insertSong(request, response);
                    break;
                default:
                    listSongs(request, response);
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
    
    private void listSongs(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException, ServletException {
        LoggerUtil.info(logger, "Fetching all songs");
        List<Song> listSong = songService.getAllSongs();
        request.setAttribute("listSong", listSong);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-songs.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        LoggerUtil.info(logger, "Showing new song form");
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-song-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Showing edit form for song ID: " + id);
        Song existingSong = songService.getSong(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/admin-song-form.jsp");
        request.setAttribute("song", existingSong);
        dispatcher.forward(request, response);
    }

    private void insertSong(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        String songName = request.getParameter("song_name");
        String singer = request.getParameter("singer");
        String lyricist = request.getParameter("lyricist");
        String musicDirector = request.getParameter("music_director");
        String albumIdParam = request.getParameter("album_id");
        
        int albumId = 0;
        if (albumIdParam != null && !albumIdParam.isEmpty()) {
            try {
                albumId = Integer.parseInt(albumIdParam);
            } catch (NumberFormatException e) {
                LoggerUtil.warn(logger, "Invalid album ID format: " + albumIdParam);
            }
        }
        
        LoggerUtil.info(logger, "Creating new song: " + songName + " by " + singer);
        
        Song newSong = new Song();
        newSong.setSongName(songName);
        newSong.setSinger(singer);
        newSong.setLyricist(lyricist);
        newSong.setMusicDirector(musicDirector);
        newSong.setAlbumId(albumId);
        
        songService.insertSong(newSong);
        
        // Redirect back to artist dashboard
        response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
    }

    private void updateSong(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String songName = request.getParameter("songName");
        String singer = request.getParameter("singer");
        String lyricist = request.getParameter("lyricist");
        String musicDirector = request.getParameter("music_director");
        String albumIdParam = request.getParameter("albumId");
        
        int albumId = 0;
        if (albumIdParam != null && !albumIdParam.isEmpty()) {
            try {
                albumId = Integer.parseInt(albumIdParam);
            } catch (NumberFormatException e) {
                // Log warning about invalid album ID format
            }
        }
        
        // Get existing song and update its properties
        Song song = songService.getSong(id);
        song.setSongName(songName);
        song.setSinger(singer);
        song.setLyricist(lyricist);
        song.setMusicDirector(musicDirector);
        song.setAlbumId(albumId);
        
        // Update the song in the database
        songService.updateSong(song);
        
        // Redirect based on where the request came from
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/artist/artist-dashboard")) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/songs");
        }
    }

    private void deleteSong(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Deleting song ID: " + id);
        songService.deleteSong(id);
        
        // Check if request came from artist dashboard
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("/artist/artist-dashboard")) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/songs");
        }
    }
    
    private void viewSong(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LoggerUtil.info(logger, "Viewing song ID: " + id);
        
        Song song = songService.getSong(id);
        request.setAttribute("song", song);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/song-view.jsp");
        dispatcher.forward(request, response);
    }
    
    public List<Song> getSongsByArtist(String artist) throws SQLException {
        return songService.getSongsByArtist(artist);
    }
    
    public List<Song> getSongsByAlbum(int albumId) throws SQLException {
        return songService.getSongsByAlbum(albumId);
    }
}
