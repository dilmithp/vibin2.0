<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Playlist Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-900 text-white">
    <%
        // Check if user is logged in
        if (session.getAttribute("id") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        
        String userName = (String) session.getAttribute("name");
        
        // Get playlist and songs from request attributes
        Playlist playlist = (Playlist) request.getAttribute("playlist");
        List<Song> playlistSongs = (List<Song>) request.getAttribute("playlistSongs");
        List<Song> allSongs = (List<Song>) request.getAttribute("allSongs");
        
        if (playlist == null) {
            response.sendRedirect(request.getContextPath() + "/user/playlists.jsp");
            return;
        }
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <nav class="ml-10 hidden md:flex space-x-6">
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-gray-300 hover:text-white">Home</a>
                        <a href="<%=request.getContextPath()%>/user/library.jsp" class="text-gray-300 hover:text-white">Library</a>
                        <a href="<%=request.getContextPath()%>/user/playlists.jsp" class="text-white">Playlists</a>
                    </nav>
                </div>
                <div class="flex items-center">
                    <div class="relative group">
                        <button class="flex items-center text-gray-300 hover:text-white">
                            <span class="mr-2"><%= userName %></span>
                            <i class="fas fa-user-circle text-xl"></i>
                        </button>
                        <div class="absolute right-0 mt-2 w-48 bg-gray-800 rounded-md shadow-lg py-1 z-10 hidden group-hover:block">
                            <a href="<%=request.getContextPath()%>/user/profile.jsp" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">Profile</a>
                            <a href="<%=request.getContextPath()%>/auth/logout" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <!-- Playlist Header -->
        <div class="bg-gray-800 rounded-lg p-6 mb-8">
            <div class="flex flex-col md:flex-row items-center md:items-start">
                <div class="h-40 w-40 bg-gray-700 rounded-lg flex items-center justify-center mb-4 md:mb-0 md:mr-6">
                    <i class="fas fa-list text-5xl text-gray-500"></i>
                </div>
                <div class="text-center md:text-left">
                    <h2 class="text-3xl font-bold mb-2"><%= playlist.getPlaylistName() %></h2>
                    <p class="text-gray-400 mb-2">Created by <%= userName %></p>
                    <p class="text-gray-400 mb-4"><%= playlistSongs != null ? playlistSongs.size() : 0 %> songs</p>
                    <% if (playlist.getDescription() != null && !playlist.getDescription().isEmpty()) { %>
                        <p class="text-gray-300 mb-4 max-w-2xl"><%= playlist.getDescription() %></p>
                    <% } %>
                    <div class="flex flex-wrap justify-center md:justify-start gap-2">
                        <button class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-full">
                            <i class="fas fa-play mr-2"></i> Play All
                        </button>
                        <a href="<%=request.getContextPath()%>/playlists/edit?id=<%= playlist.getPlaylistId() %>" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-full">
                            <i class="fas fa-edit mr-2"></i> Edit
                        </a>
                        <a href="<%=request.getContextPath()%>/playlists/delete?id=<%= playlist.getPlaylistId() %>" 
                           onclick="return confirm('Are you sure you want to delete this playlist?')" 
                           class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-full">
                            <i class="fas fa-trash-alt mr-2"></i> Delete
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Add Songs to Playlist -->
        <div class="bg-gray-800 rounded-lg p-6 mb-8">
            <h3 class="text-xl font-bold mb-4">Add Songs to Playlist</h3>
            
            <form action="<%=request.getContextPath()%>/playlists/add-song" method="post" class="flex flex-col md:flex-row gap-4">
                <input type="hidden" name="playlistId" value="<%= playlist.getPlaylistId() %>">
                
                <div class="flex-1">
                    <select name="songId" required class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <option value="">-- Select a song --</option>
                        <% if (allSongs != null) {
                            for (Song song : allSongs) {
                                // Check if song is already in the playlist
                                boolean isInPlaylist = false;
                                if (playlistSongs != null) {
                                    for (Song playlistSong : playlistSongs) {
                                        if (playlistSong.getSongId() == song.getSongId()) {
                                            isInPlaylist = true;
                                            break;
                                        }
                                    }
                                }
                                
                                if (!isInPlaylist) { %>
                                    <option value="<%= song.getSongId() %>"><%= song.getSongName() %> - <%= song.getSinger() %></option>
                                <% }
                            }
                        } %>
                    </select>
                </div>
                
                <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                    Add to Playlist
                </button>
            </form>
        </div>
        
        <!-- Playlist Songs -->
        <div class="bg-gray-800 rounded-lg overflow-hidden">
            <h3 class="text-xl font-bold p-6 border-b border-gray-700">Songs in Playlist</h3>
            
            <% if (playlistSongs == null || playlistSongs.isEmpty()) { %>
                <div class="p-8 text-center">
                    <i class="fas fa-music text-4xl text-gray-600 mb-4"></i>
                    <h4 class="text-lg font-medium mb-2">No songs in this playlist</h4>
                    <p class="text-gray-400">Add songs to your playlist using the form above.</p>
                </div>
            <% } else { %>
                <table class="w-full">
                    <thead class="border-b border-gray-700">
                        <tr class="text-gray-400 text-left">
                            <th class="p-4 w-12">#</th>
                            <th class="p-4">Title</th>
                            <th class="p-4">Artist</th>
                            <th class="p-4 hidden md:table-cell">Album</th>
                            <th class="p-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                        int songCount = 0;
                        for (Song song : playlistSongs) { 
                            songCount++;
                        %>
                            <tr class="border-b border-gray-700 hover:bg-gray-700">
                                <td class="p-4 text-gray-400"><%= songCount %></td>
                                <td class="p-4">
                                    <div class="flex items-center">
                                        <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                            <i class="fas fa-music text-gray-400"></i>
                                        </div>
                                        <%= song.getSongName() %>
                                    </div>
                                </td>
                                <td class="p-4 text-gray-300"><%= song.getSinger() %></td>
                                <td class="p-4 text-gray-300 hidden md:table-cell">
                                    <%= song.getAlbumId() > 0 ? "Album Name" : "-" %>
                                </td>
                                <td class="p-4 text-right">
                                    <button class="text-gray-400 hover:text-white px-2 play-btn" data-song-id="<%= song.getSongId() %>">
                                        <i class="fas fa-play"></i>
                                    </button>
                                    <a href="<%=request.getContextPath()%>/playlists/remove-song?playlistId=<%= playlist.getPlaylistId() %>&songId=<%= song.getSongId() %>" 
                                       onclick="return confirm('Remove this song from the playlist?')" 
                                       class="text-gray-400 hover:text-white px-2">
                                        <i class="fas fa-times"></i>
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </main>

    <!-- Footer with Player -->
    <footer class="fixed bottom-0 left-0 right-0 bg-gray-800 border-t border-gray-700 p-3">
        <div class="container mx-auto flex items-center justify-between">
            <div class="flex items-center w-1/3">
                <div class="bg-gray-700 h-12 w-12 rounded-md mr-3 flex items-center justify-center">
                    <i class="fas fa-music text-gray-400"></i>
                </div>
                <div class="truncate">
                    <p class="font-medium truncate" id="currentSongTitle">No song playing</p>
                    <p class="text-sm text-gray-400 truncate" id="currentSongArtist">Select a song to play</p>
                </div>
            </div>
            
            <div class="w-1/3 flex flex-col items-center">
                <div class="flex items-center mb-2">
                    <button class="text-gray-400 hover:text-white mx-2" id="prevBtn">
                        <i class="fas fa-step-backward"></i>
                    </button>
                    <button class="bg-white rounded-full h-8 w-8 flex items-center justify-center text-gray-900 hover:bg-gray-200 mx-2" id="playPauseBtn">
                        <i class="fas fa-play"></i>
                    </button>
                    <button class="text-gray-400 hover:text-white mx-2" id="nextBtn">
                        <i class="fas fa-step-forward"></i>
                    </button>
                </div>
                <div class="w-full flex items-center">
                    <span class="text-xs text-gray-400 mr-2" id="currentTime">0:00</span>
                    <div class="h-1 flex-1 bg-gray-700 rounded-full">
                        <div class="h-1 w-0 bg-purple-500 rounded-full" id="progressBar"></div>
                    </div>
                    <span class="text-xs text-gray-400 ml-2" id="totalTime">0:00</span>
                </div>
            </div>
            
            <div class="w-1/3 flex justify-end items-center">
                <button class="text-gray-400 hover:text-white mx-2" id="volumeBtn">
                    <i class="fas fa-volume-up"></i>
                </button>
                <div class="w-24 h-1 bg-gray-700 rounded-full mx-2">
                    <div class="h-1 w-1/2 bg-purple-500 rounded-full" id="volumeBar"></div>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Play Song functionality
        const playBtns = document.querySelectorAll('.play-btn');
        const playPauseBtn = document.getElementById('playPauseBtn');
        const currentSongTitle = document.getElementById('currentSongTitle');
        const currentSongArtist = document.getElementById('currentSongArtist');
        
        playBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const songId = btn.getAttribute('data-song-id');
                const songRow = btn.closest('tr');
                const songTitle = songRow.querySelector('td:nth-child(2)').textContent.trim();
                const songArtist = songRow.querySelector('td:nth-child(3)').textContent.trim();
                
                // Update player UI
                currentSongTitle.textContent = songTitle;
                currentSongArtist.textContent = songArtist;
                
                // Change play button to pause
                playPauseBtn.innerHTML = '<i class="fas fa-pause"></i>';
                
                // In a real implementation, you would start playing the song here
                console.log(`Playing song: ${songTitle} by ${songArtist}`);
            });
        });
    </script>
</body>
</html>
