<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.PlaylistService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Music Store</title>
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
        AlbumService albumService = new AlbumService();
        SongService songService = new SongService();
        PlaylistService playlistService = new PlaylistService();
        
        // Get all albums
        List<Album> allAlbums = albumService.getAllAlbums();
        
        // Get user's playlists
        List<Playlist> userPlaylists = playlistService.getUserPlaylists(userId);
        
        // Get selected album (if any)
        String albumIdParam = request.getParameter("albumId");
        Album selectedAlbum = null;
        List<Song> albumSongs = null;
        
        if (albumIdParam != null && !albumIdParam.isEmpty()) {
            try {
                int albumId = Integer.parseInt(albumIdParam);
                selectedAlbum = albumService.getAlbum(albumId);
                if (selectedAlbum != null) {
                    albumSongs = songService.getSongsByAlbum(albumId);
                }
            } catch (NumberFormatException e) {
                // Invalid album ID, ignore
            }
        }
    %>

<!-- Header/Navigation -->
<header class="bg-gray-800 shadow-md">
    <div class="container mx-auto px-6 py-3">
        <div class="flex items-center justify-between">
            <div class="flex items-center">
                <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                <nav class="ml-10 hidden md:flex space-x-6">
                    <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-white">Home</a>
                    <a href="<%=request.getContextPath()%>/user/library.jsp" class="text-gray-300 hover:text-white">Library</a>
                    <a href="<%=request.getContextPath()%>/playlists" class="text-gray-300 hover:text-white">Playlists</a>
                    <a href="<%=request.getContextPath()%>/user/profile.jsp" class="text-gray-300 hover:text-white">Profile</a>
                    <a href="<%=request.getContextPath()%>/auth/logout" class="text-gray-300 hover:text-white">Logout</a>
                </nav>
            </div>
            <div class="flex items-center">
                <div class="relative mr-4">
                    <input type="text" placeholder="Search..." class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                    <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
                <div class="text-gray-300">
                    <span class="mr-2"><%= userName %></span>
                    <a href="<%=request.getContextPath()%>/user/profile.jsp" class="text-gray-300 hover:text-white">Profile</a>
                    <a href="<%=request.getContextPath()%>/auth/logout" class="text-gray-300 hover:text-white">Logout</a>
                </div>
            </div>
        </div>
    </div>
</header>


    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <!-- Albums Section -->
        <section class="mb-12">
            <h2 class="text-2xl font-bold mb-6">Albums</h2>
            
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                <% if (allAlbums.isEmpty()) { %>
                    <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No albums found</h4>
                        <p class="text-gray-400">Check back later for new releases!</p>
                    </div>
                <% } else { 
                    for (Album album : allAlbums) { %>
                    <a href="?albumId=<%= album.getAlbumId() %>" class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200 <%= (selectedAlbum != null && selectedAlbum.getAlbumId() == album.getAlbumId()) ? "ring-2 ring-purple-500" : "" %>">
                        <div class="h-40 bg-gray-700 flex items-center justify-center">
                            <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-sm mb-1 truncate"><%= album.getAlbumName() %></h3>
                            <p class="text-gray-400 text-xs truncate"><%= album.getArtist() %></p>
                            <p class="text-gray-500 text-xs"><%= album.getReleaseDate() != null ? album.getReleaseDate() : "No release date" %></p>
                        </div>
                    </a>
                <% } 
                } %>
            </div>
        </section>

        <!-- Songs Section (for selected album) -->
        <% if (selectedAlbum != null && albumSongs != null) { %>
            <section class="mb-12">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold">Songs from <%= selectedAlbum.getAlbumName() %></h2>
                    <div>
                        <a href="<%=request.getContextPath()%>/playlists/new" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md mr-2">
                            <i class="fas fa-plus mr-2"></i> Create Playlist
                        </a>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden">
                    <% if (albumSongs.isEmpty()) { %>
                        <div class="p-8 text-center">
                            <i class="fas fa-music text-4xl text-gray-600 mb-4"></i>
                            <h4 class="text-lg font-medium mb-2">No songs found</h4>
                            <p class="text-gray-400">This album doesn't have any songs yet.</p>
                        </div>
                    <% } else { %>
                        <table class="w-full">
                            <thead class="border-b border-gray-700">
                                <tr class="text-gray-400 text-left">
                                    <th class="p-4 w-12">#</th>
                                    <th class="p-4">Title</th>
                                    <th class="p-4">Artist</th>
                                    <th class="p-4 hidden md:table-cell">Duration</th>
                                    <th class="p-4 text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                int songCount = 0;
                                for (Song song : albumSongs) { 
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
                                        <td class="p-4 text-gray-300 hidden md:table-cell">3:45</td>
                                        <td class="p-4 text-right">
                                            <button class="text-gray-400 hover:text-white px-2 play-btn" data-song-id="<%= song.getSongId() %>">
                                                <i class="fas fa-play"></i>
                                            </button>
                                            <button class="text-gray-400 hover:text-white px-2 like-btn" data-song-id="<%= song.getSongId() %>">
                                                <i class="far fa-heart"></i>
                                            </button>
                                            <button class="text-gray-400 hover:text-white px-2 add-to-playlist-btn" 
                                                    data-song-id="<%= song.getSongId() %>" 
                                                    data-song-name="<%= song.getSongName() %>">
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
        <% } %>
    </main>

    <!-- Add to Playlist Modal -->
    <div id="addToPlaylistModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-gray-800 rounded-lg p-6 w-full max-w-md">
            <h3 class="text-xl font-bold mb-4">Add to Playlist</h3>
            <p class="text-gray-400 mb-4">Song: <span id="selectedSongName"></span></p>
            
            <form id="addToPlaylistForm" action="<%=request.getContextPath()%>/playlists/add-song" method="post">
                <input type="hidden" name="songId" id="selectedSongId">
                
                <div class="mb-4">
                    <label for="playlistId" class="block text-sm font-medium text-gray-400 mb-2">Select Playlist</label>
                    <select id="playlistId" name="playlistId" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <option value="">-- Select a playlist --</option>
                        <% for (Playlist playlist : userPlaylists) { %>
                            <option value="<%= playlist.getPlaylistId() %>"><%= playlist.getPlaylistName() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div class="flex justify-between items-center">
                    <a href="<%=request.getContextPath()%>/playlists/new" class="text-purple-400 hover:text-purple-300 text-sm">
                        <i class="fas fa-plus mr-1"></i> Create New Playlist
                    </a>
                    
                    <div>
                        <button type="button" id="cancelAddToPlaylist" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                            Cancel
                        </button>
                        <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            Add
                        </button>
                    </div>
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
        // Add to Playlist Modal
        const addToPlaylistBtns = document.querySelectorAll('.add-to-playlist-btn');
        const addToPlaylistModal = document.getElementById('addToPlaylistModal');
        const cancelAddToPlaylist = document.getElementById('cancelAddToPlaylist');
        const selectedSongId = document.getElementById('selectedSongId');
        const selectedSongName = document.getElementById('selectedSongName');
        
        addToPlaylistBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const songId = btn.getAttribute('data-song-id');
                const songName = btn.getAttribute('data-song-name');
                
                selectedSongId.value = songId;
                selectedSongName.textContent = songName;
                
                addToPlaylistModal.classList.remove('hidden');
            });
        });
        
        if (cancelAddToPlaylist) {
            cancelAddToPlaylist.addEventListener('click', () => {
                addToPlaylistModal.classList.add('hidden');
            });
        }
        
        // Like Song functionality
        const likeBtns = document.querySelectorAll('.like-btn');
        
        likeBtns.forEach(btn => {
            btn.addEventListener('click', async () => {
                const songId = btn.getAttribute('data-song-id');
                
                try {
                    const response = await fetch('<%=request.getContextPath()%>/songs/like', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: `songId=${songId}&userId=<%= userId %>`
                    });
                    
                    if (response.ok) {
                        // Toggle heart icon
                        const icon = btn.querySelector('i');
                        if (icon.classList.contains('far')) {
                            icon.classList.remove('far');
                            icon.classList.add('fas');
                            icon.classList.add('text-red-500');
                        } else {
                            icon.classList.remove('fas');
                            icon.classList.remove('text-red-500');
                            icon.classList.add('far');
                        }
                    }
                } catch (error) {
                    console.error('Error liking song:', error);
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
