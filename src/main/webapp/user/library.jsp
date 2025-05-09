<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.PlaylistService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Your Library</title>
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
        SongService songService = new SongService();
        PlaylistService playlistService = new PlaylistService();
        
        // Get user's liked songs and playlists
        List<Song> likedSongs = songService.getLikedSongs(userId);
        List<Playlist> userPlaylists = playlistService.getUserPlaylists(userId);
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <nav class="ml-10 hidden md:flex space-x-6">
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-gray-300 hover:text-white">Home</a>
                        <a href="<%=request.getContextPath()%>/user/library.jsp" class="text-white">Library</a>
                        <a href="<%=request.getContextPath()%>/user/playlists.jsp" class="text-gray-300 hover:text-white">Playlists</a>
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
                            <a href="<%=request.getContextPath()%>/user/settings.jsp" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">Settings</a>
                            <a href="<%=request.getContextPath()%>/auth/logout" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <!-- Liked Songs Section -->
        <section class="mb-12">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">Liked Songs</h2>
                <button class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                    <i class="fas fa-play mr-2"></i> Play All
                </button>
            </div>
            
            <div class="bg-gray-800 rounded-lg overflow-hidden">
                <% if (likedSongs == null || likedSongs.isEmpty()) { %>
                    <div class="p-8 text-center">
                        <i class="fas fa-heart text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No liked songs yet</h4>
                        <p class="text-gray-400">Songs you like will appear here.</p>
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="inline-block mt-4 bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                            Discover Music
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
                            for (Song song : likedSongs) { 
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
                                        <button class="text-red-500 hover:text-red-400 px-2 unlike-btn" data-song-id="<%= song.getSongId() %>">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                        <button class="text-gray-400 hover:text-white px-2 add-to-playlist-btn" data-song-id="<%= song.getSongId() %>" data-song-name="<%= song.getSongName() %>">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </section>
        
        <!-- Your Playlists Section -->
        <section>
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">Your Playlists</h2>
                <button id="createPlaylistBtn" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                    <i class="fas fa-plus mr-2"></i> Create Playlist
                </button>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-4">
                <% if (userPlaylists.isEmpty()) { %>
                    <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                        <i class="fas fa-list text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No playlists yet</h4>
                        <p class="text-gray-400 mb-4">Create your first playlist to organize your favorite songs.</p>
                        <button id="emptyCreatePlaylistBtn" class="inline-block bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                            Create Playlist
                        </button>
                    </div>
                <% } else { 
                    for (Playlist playlist : userPlaylists) { %>
                    <a href="<%=request.getContextPath()%>/playlists/view?id=<%= playlist.getPlaylistId() %>" class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                        <div class="h-40 bg-gray-700 flex items-center justify-center">
                            <i class="fas fa-list text-4xl text-gray-500"></i>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-lg mb-1"><%= playlist.getPlaylistName() %></h3>
                            <p class="text-gray-400 mb-2"><%= playlist.getSongs().size() %> songs</p>
                            <div class="flex justify-end">
                                <button class="text-gray-400 hover:text-white px-2 play-playlist-btn" data-playlist-id="<%= playlist.getPlaylistId() %>">
                                    <i class="fas fa-play"></i>
                                </button>
                            </div>
                        </div>
                    </a>
                <% } 
                } %>
            </div>
        </section>
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
        
        if (cancelCreatePlaylist) {
            cancelCreatePlaylist.addEventListener('click', () => {
                createPlaylistModal.classList.add('hidden');
            });
        }
        
        // Unlike Song functionality
        const unlikeBtns = document.querySelectorAll('.unlike-btn');
        
        unlikeBtns.forEach(btn => {
            btn.addEventListener('click', async () => {
                const songId = btn.getAttribute('data-song-id');
                
                try {
                    const response = await fetch('<%=request.getContextPath()%>/songs/unlike', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `songId=${songId}&userId=<%= userId %>`
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
                                    <i class="fas fa-heart text-4xl text-gray-600 mb-4"></i>
                                    <h4 class="text-lg font-medium mb-2">No liked songs yet</h4>
                                    <p class="text-gray-400">Songs you like will appear here.</p>
                                    <a href="<%=request.getContextPath()%>/user/index.jsp" class="inline-block mt-4 bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                                        Discover Music
                                    </a>
                                </div>
                            `;
                        }
                    }
                } catch (error) {
                    console.error('Error unliking song:', error);
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
