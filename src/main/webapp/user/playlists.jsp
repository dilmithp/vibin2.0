<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.service.PlaylistService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Your Playlists</title>
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
        
        int userId = (int) session.getAttribute("id");
        String userName = (String) session.getAttribute("name");
        
        // Initialize services
        PlaylistService playlistService = new PlaylistService();
        SongService songService = new SongService();
        
        // Get user's playlists
        List<Playlist> userPlaylists = playlistService.getUserPlaylists(userId);
        
        // Get selected playlist (if any)
        String playlistIdParam = request.getParameter("id");
        Playlist selectedPlaylist = null;
        List<Song> playlistSongs = null;
        
        if (playlistIdParam != null && !playlistIdParam.isEmpty()) {
            try {
                int playlistId = Integer.parseInt(playlistIdParam);
                selectedPlaylist = playlistService.getPlaylist(playlistId);
                if (selectedPlaylist != null) {
                    playlistSongs = selectedPlaylist.getSongs();
                }
            } catch (NumberFormatException e) {
                // Invalid playlist ID, ignore
            }
        }
        
        // Get current date
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEEE, MMMM dd, yyyy, h:mm a");
        String currentDate = sdf.format(new java.util.Date());
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
                    <div class="relative mr-4">
                        <input type="text" placeholder="Search..." class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                        <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
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
        <!-- Current Date -->
        <div class="text-sm text-gray-400 mb-6">
            <%= currentDate %>
        </div>
        
        <div class="flex flex-col md:flex-row">
            <!-- Playlists Sidebar -->
            <div class="w-full md:w-64 mb-8 md:mb-0 md:mr-8">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-xl font-bold">Your Playlists</h2>
                    <button id="createPlaylistBtn" class="text-purple-400 hover:text-purple-300 text-sm">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden">
                    <% if (userPlaylists.isEmpty()) { %>
                        <div class="p-6 text-center">
                            <i class="fas fa-list text-4xl text-gray-600 mb-4"></i>
                            <h4 class="text-lg font-medium mb-2">No playlists yet</h4>
                            <p class="text-gray-400 mb-4">Create your first playlist to organize your favorite songs.</p>
                            <button id="emptyCreatePlaylistBtn" class="inline-block bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                                Create Playlist
                            </button>
                        </div>
                    <% } else { %>
                        <ul class="divide-y divide-gray-700">
                            <% for (Playlist playlist : userPlaylists) { 
                                boolean isSelected = selectedPlaylist != null && selectedPlaylist.getPlaylistId() == playlist.getPlaylistId();
                            %>
                                <li>
                                    <a href="?id=<%= playlist.getPlaylistId() %>" 
                                       class="block p-4 hover:bg-gray-700 <%= isSelected ? "bg-gray-700" : "" %>">
                                        <div class="flex items-center">
                                            <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                                <i class="fas fa-list text-gray-400"></i>
                                            </div>
                                            <div>
                                                <h4 class="font-medium"><%= playlist.getPlaylistName() %></h4>
                                                <p class="text-sm text-gray-400"><%= playlist.getSongs().size() %> songs</p>
                                            </div>
                                        </div>
                                    </a>
                                </li>
                            <% } %>
                        </ul>
                    <% } %>
                </div>
            </div>
            
            <!-- Playlist Content -->
            <div class="flex-1">
                <% if (selectedPlaylist != null) { %>
                    <div class="bg-gray-800 rounded-lg p-6 mb-6">
                        <div class="flex flex-col md:flex-row items-center md:items-start">
                            <div class="h-40 w-40 bg-gray-700 rounded-lg flex items-center justify-center mb-4 md:mb-0 md:mr-6">
                                <i class="fas fa-list text-5xl text-gray-500"></i>
                            </div>
                            <div class="text-center md:text-left">
                                <h2 class="text-3xl font-bold mb-2"><%= selectedPlaylist.getPlaylistName() %></h2>
                                <p class="text-gray-400 mb-4">Created by <%= userName %> • <%= selectedPlaylist.getSongs().size() %> songs</p>
                                <div class="flex flex-wrap justify-center md:justify-start gap-2">
                                    <button class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-full">
                                        <i class="fas fa-play mr-2"></i> Play All
                                    </button>
                                    <button id="editPlaylistBtn" data-playlist-id="<%= selectedPlaylist.getPlaylistId() %>" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-full">
                                        <i class="fas fa-edit mr-2"></i> Edit
                                    </button>
                                    <button id="deletePlaylistBtn" data-playlist-id="<%= selectedPlaylist.getPlaylistId() %>" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-full">
                                        <i class="fas fa-trash-alt mr-2"></i> Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Songs in Playlist -->
                    <div class="bg-gray-800 rounded-lg overflow-hidden">
                        <% if (playlistSongs == null || playlistSongs.isEmpty()) { %>
                            <div class="p-8 text-center">
                                <i class="fas fa-music text-4xl text-gray-600 mb-4"></i>
                                <h4 class="text-lg font-medium mb-2">No songs in this playlist</h4>
                                <p class="text-gray-400">Add songs to your playlist from the music library.</p>
                                <a href="<%=request.getContextPath()%>/user/index.jsp" class="inline-block mt-4 bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                                    Browse Music
                                </a>
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
                                                <button class="text-gray-400 hover:text-white px-2 like-btn" data-song-id="<%= song.getSongId() %>">
                                                    <i class="far fa-heart"></i>
                                                </button>
                                                <button class="text-gray-400 hover:text-white px-2 remove-song-btn" 
                                                        data-song-id="<%= song.getSongId() %>" 
                                                        data-playlist-id="<%= selectedPlaylist.getPlaylistId() %>">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="bg-gray-800 rounded-lg p-8 text-center">
                        <i class="fas fa-list text-6xl text-gray-600 mb-4"></i>
                        <h3 class="text-2xl font-bold mb-2">Select a Playlist</h3>
                        <p class="text-gray-400 mb-6">Choose a playlist from the sidebar or create a new one.</p>
                        <button id="mainCreatePlaylistBtn" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-full">
                            Create New Playlist
                        </button>
                    </div>
                <% } %>
            </div>
        </div>
    </main>

    <!-- Create Playlist Modal -->
    <div id="createPlaylistModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-gray-800 rounded-lg p-6 w-full max-w-md">
            <h3 class="text-xl font-bold mb-4">Create New Playlist</h3>
            <form id="createPlaylistForm" action="<%=request.getContextPath()%>/playlists/create" method="post">
                <input type="hidden" name="userId" value="<%= userId %>">
                
                <div class="mb-4">
                    <label for="playlistName" class="block text-sm font-medium text-gray-400 mb-2">Playlist Name</label>
                    <input type="text" id="playlistName" name="playlistName" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-4">
                    <label for="description" class="block text-sm font-medium text-gray-400 mb-2">Description (Optional)</label>
                    <textarea id="description" name="description" rows="3"
                              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"></textarea>
                </div>
                
                <div class="flex justify-end">
                    <button type="button" id="cancelCreatePlaylist" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                        Cancel
                    </button>
                    <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                        Create
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Playlist Modal -->
    <div id="editPlaylistModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-gray-800 rounded-lg p-6 w-full max-w-md">
            <h3 class="text-xl font-bold mb-4">Edit Playlist</h3>
            <form id="editPlaylistForm" action="<%=request.getContextPath()%>/playlists/update" method="post">
                <input type="hidden" name="id" id="editPlaylistId">
                
                <div class="mb-4">
                    <label for="editPlaylistName" class="block text-sm font-medium text-gray-400 mb-2">Playlist Name</label>
                    <input type="text" id="editPlaylistName" name="playlistName" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-4">
                    <label for="editDescription" class="block text-sm font-medium text-gray-400 mb-2">Description (Optional)</label>
                    <textarea id="editDescription" name="description" rows="3"
                              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"></textarea>
                </div>
                
                <div class="flex justify-end">
                    <button type="button" id="cancelEditPlaylist" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                        Cancel
                    </button>
                    <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                        Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Playlist Confirmation Modal -->
    <div id="deletePlaylistModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-gray-800 rounded-lg p-6 w-full max-w-md">
            <h3 class="text-xl font-bold mb-4">Delete Playlist</h3>
            <p class="text-gray-300 mb-6">Are you sure you want to delete this playlist? This action cannot be undone.</p>
            
            <form id="deletePlaylistForm" action="<%=request.getContextPath()%>/playlists/delete" method="post">
                <input type="hidden" name="id" id="deletePlaylistId">
                
                <div class="flex justify-end">
                    <button type="button" id="cancelDeletePlaylist" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                        Cancel
                    </button>
                    <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md">
                        Delete
                    </button>
                </div>
            </form>
        </div>
    </div>

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

    <!-- JavaScript for interactivity -->
    <script>
        // Create Playlist Modal
        const createPlaylistBtn = document.getElementById('createPlaylistBtn');
        const emptyCreatePlaylistBtn = document.getElementById('emptyCreatePlaylistBtn');
        const mainCreatePlaylistBtn = document.getElementById('mainCreatePlaylistBtn');
        const createPlaylistModal = document.getElementById('createPlaylistModal');
        const cancelCreatePlaylist = document.getElementById('cancelCreatePlaylist');
        
        function showCreatePlaylistModal() {
            createPlaylistModal.classList.remove('hidden');
        }
        
        if (createPlaylistBtn) {
            createPlaylistBtn.addEventListener('click', showCreatePlaylistModal);
        }
        
        if (emptyCreatePlaylistBtn) {
            emptyCreatePlaylistBtn.addEventListener('click', showCreatePlaylistModal);
        }
        
        if (mainCreatePlaylistBtn) {
            mainCreatePlaylistBtn.addEventListener('click', showCreatePlaylistModal);
        }
        
        if (cancelCreatePlaylist) {
            cancelCreatePlaylist.addEventListener('click', () => {
                createPlaylistModal.classList.add('hidden');
            });
        }
        
        // Edit Playlist Modal
        const editPlaylistBtn = document.getElementById('editPlaylistBtn');
        const editPlaylistModal = document.getElementById('editPlaylistModal');
        const cancelEditPlaylist = document.getElementById('cancelEditPlaylist');
        const editPlaylistId = document.getElementById('editPlaylistId');
        const editPlaylistName = document.getElementById('editPlaylistName');
        
        if (editPlaylistBtn) {
            editPlaylistBtn.addEventListener('click', () => {
                const playlistId = editPlaylistBtn.getAttribute('data-playlist-id');
                editPlaylistId.value = playlistId;
                
                // In a real implementation, you would fetch the playlist details here
                // For now, we'll just use the current playlist name
                <% if (selectedPlaylist != null) { %>
                    editPlaylistName.value = "<%= selectedPlaylist.getPlaylistName() %>";
                <% } %>
                
                editPlaylistModal.classList.remove('hidden');
            });
        }
        
        if (cancelEditPlaylist) {
            cancelEditPlaylist.addEventListener('click', () => {
                editPlaylistModal.classList.add('hidden');
            });
        }
        
        // Delete Playlist Modal
        const deletePlaylistBtn = document.getElementById('deletePlaylistBtn');
        const deletePlaylistModal = document.getElementById('deletePlaylistModal');
        const cancelDeletePlaylist = document.getElementById('cancelDeletePlaylist');
        const deletePlaylistId = document.getElementById('deletePlaylistId');
        
        if (deletePlaylistBtn) {
            deletePlaylistBtn.addEventListener('click', () => {
                const playlistId = deletePlaylistBtn.getAttribute('data-playlist-id');
                deletePlaylistId.value = playlistId;
                deletePlaylistModal.classList.remove('hidden');
            });
        }
        
        if (cancelDeletePlaylist) {
            cancelDeletePlaylist.addEventListener('click', () => {
                deletePlaylistModal.classList.add('hidden');
            });
        }
        
        // Remove Song from Playlist
        const removeSongBtns = document.querySelectorAll('.remove-song-btn');
        
        removeSongBtns.forEach(btn => {
            btn.addEventListener('click', async () => {
                const songId = btn.getAttribute('data-song-id');
                const playlistId = btn.getAttribute('data-playlist-id');
                
                if (confirm('Remove this song from the playlist?')) {
                    try {
                        const response = await fetch('<%=request.getContextPath()%>/playlists/remove-song', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                            body: `songId=${songId}&playlistId=${playlistId}`
                        });
                        
                        if (response.ok) {
                            // Remove the song row from the table
                            const row = btn.closest('tr');
                            row.remove();
                            
                            // If no more songs, show the empty state
                            const tbody = document.querySelector('tbody');
                            if (!tbody.hasChildNodes()) {
                                const table = tbody.closest('table');
                                const container = table.parentElement;
                                
                                container.innerHTML = `
                                    <div class="p-8 text-center">
                                        <i class="fas fa-music text-4xl text-gray-600 mb-4"></i>
                                        <h4 class="text-lg font-medium mb-2">No songs in this playlist</h4>
                                        <p class="text-gray-400">Add songs to your playlist from the music library.</p>
                                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="inline-block mt-4 bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                                            Browse Music
                                        </a>
                                    </div>
                                `;
                            }
                        }
                    } catch (error) {
                        console.error('Error removing song:', error);
                    }
                }
            });
        });
        
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
