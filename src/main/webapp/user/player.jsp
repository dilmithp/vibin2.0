<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.AlbumService" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Music Player</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }
        
        .player-bg {
            background: linear-gradient(to bottom, #4c1d95, #1f2937);
            min-height: 100vh;
        }
        
        .progress-bar {
            cursor: pointer;
            transition: height 0.1s ease-in-out;
        }
        
        .progress-bar:hover {
            height: 0.5rem;
        }
        
        .volume-bar {
            cursor: pointer;
            transition: height 0.1s ease-in-out;
        }
        
        .volume-bar:hover {
            height: 0.5rem;
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
        
        // Get song ID from request parameter
        String songIdParam = request.getParameter("songId");
        int songId = 0;
        
        // Initialize services
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        
        // Get song details
        Song currentSong = null;
        Album album = null;
        
        if (songIdParam != null && !songIdParam.isEmpty()) {
            try {
                songId = Integer.parseInt(songIdParam);
                currentSong = songService.getSong(songId);
                
                if (currentSong != null && currentSong.getAlbumId() > 0) {
                    album = albumService.getAlbum(currentSong.getAlbumId());
                }
            } catch (NumberFormatException e) {
                // Invalid song ID, ignore
            }
        }
    %>

    <div class="player-bg">
        <!-- Header/Navigation -->
        <header class="bg-transparent shadow-md">
            <div class="container mx-auto px-6 py-3">
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                        <nav class="ml-10 hidden md:flex space-x-6">
                            <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-gray-300 hover:text-white">Home</a>
                            <a href="<%=request.getContextPath()%>/user/library.jsp" class="text-gray-300 hover:text-white">Library</a>
                            <a href="<%=request.getContextPath()%>/user/playlists.jsp" class="text-gray-300 hover:text-white">Playlists</a>
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
            <div class="flex flex-col md:flex-row items-center md:items-start">
                <!-- Album Art -->
                <div class="w-64 h-64 bg-gray-800 rounded-lg shadow-lg mb-6 md:mb-0 md:mr-8 flex items-center justify-center">
                    <% if (currentSong != null) { %>
                        <i class="fas fa-music text-6xl text-gray-600"></i>
                    <% } else { %>
                        <i class="fas fa-question text-6xl text-gray-600"></i>
                    <% } %>
                </div>
                
                <!-- Song Info -->
                <div class="text-center md:text-left">
                    <% if (currentSong != null) { %>
                        <h1 class="text-4xl font-bold mb-2"><%= currentSong.getSongName() %></h1>
                        <p class="text-2xl text-gray-300 mb-4"><%= currentSong.getSinger() %></p>
                        <p class="text-gray-400 mb-6">
                            <% if (album != null) { %>
                                From the album: <%= album.getAlbumName() %>
                            <% } else { %>
                                Single
                            <% } %>
                        </p>
                        
                        <div class="flex flex-wrap justify-center md:justify-start gap-3 mb-8">
                            <button id="likeBtn" class="bg-transparent border border-gray-600 hover:border-white text-white px-6 py-2 rounded-full">
                                <i class="far fa-heart mr-2"></i> Like
                            </button>
                            <button id="addToPlaylistBtn" class="bg-transparent border border-gray-600 hover:border-white text-white px-6 py-2 rounded-full">
                                <i class="fas fa-plus mr-2"></i> Add to Playlist
                            </button>
                            <button id="shareBtn" class="bg-transparent border border-gray-600 hover:border-white text-white px-6 py-2 rounded-full">
                                <i class="fas fa-share-alt mr-2"></i> Share
                            </button>
                        </div>
                        
                        <% if (currentSong.getLyricist() != null && !currentSong.getLyricist().isEmpty()) { %>
                            <div class="mt-8">
                                <h3 class="text-xl font-bold mb-4">Lyrics</h3>
                                <div class="bg-gray-800 bg-opacity-50 p-4 rounded-lg max-w-2xl">
                                    <p class="whitespace-pre-line">Song lyrics would appear here...</p>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <h1 class="text-4xl font-bold mb-2">No song selected</h1>
                        <p class="text-gray-400 mb-6">Please select a song to play</p>
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="inline-block bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-full">
                            Browse Music
                        </a>
                    <% } %>
                </div>
            </div>
        </main>

        <!-- Player Controls -->
        <div class="fixed bottom-0 left-0 right-0 bg-gray-900 bg-opacity-90 backdrop-blur-sm p-6">
            <div class="container mx-auto">
                <div class="flex flex-col items-center">
                    <!-- Progress Bar -->
                    <div class="w-full flex items-center mb-4">
                        <span class="text-xs text-gray-400 mr-2" id="currentTime">0:00</span>
                        <div class="h-1 flex-1 bg-gray-700 rounded-full progress-bar">
                            <div class="h-full w-0 bg-purple-500 rounded-full" id="progressBar"></div>
                        </div>
                        <span class="text-xs text-gray-400 ml-2" id="totalTime">0:00</span>
                    </div>
                    
                    <!-- Controls -->
                    <div class="flex items-center mb-4">
                        <button class="text-gray-400 hover:text-white mx-3" id="shuffleBtn">
                            <i class="fas fa-random"></i>
                        </button>
                        <button class="text-gray-400 hover:text-white mx-3" id="prevBtn">
                            <i class="fas fa-step-backward text-2xl"></i>
                        </button>
                        <button class="bg-white rounded-full h-14 w-14 flex items-center justify-center text-gray-900 hover:bg-gray-200 mx-4" id="playPauseBtn">
                            <i class="fas fa-play text-2xl"></i>
                        </button>
                        <button class="text-gray-400 hover:text-white mx-3" id="nextBtn">
                            <i class="fas fa-step-forward text-2xl"></i>
                        </button>
                        <button class="text-gray-400 hover:text-white mx-3" id="repeatBtn">
                            <i class="fas fa-redo"></i>
                        </button>
                    </div>
                    
                    <!-- Volume -->
                    <div class="flex items-center">
                        <button class="text-gray-400 hover:text-white mr-2" id="volumeBtn">
                            <i class="fas fa-volume-up"></i>
                        </button>
                        <div class="w-32 h-1 bg-gray-700 rounded-full volume-bar">
                            <div class="h-full w-1/2 bg-purple-500 rounded-full" id="volumeBar"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add to Playlist Modal -->
    <div id="addToPlaylistModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-gray-800 rounded-lg p-6 w-full max-w-md">
            <h3 class="text-xl font-bold mb-4">Add to Playlist</h3>
            <% if (currentSong != null) { %>
                <p class="text-gray-400 mb-4">Song: <%= currentSong.getSongName() %></p>
            <% } %>
            
            <form id="addToPlaylistForm" action="<%=request.getContextPath()%>/playlists/add-song" method="post">
                <input type="hidden" name="songId" value="<%= currentSong != null ? currentSong.getSongId() : 0 %>">
                
                <div class="mb-4">
                    <label for="playlistId" class="block text-sm font-medium text-gray-400 mb-2">Select Playlist</label>
                    <select id="playlistId" name="playlistId" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <option value="">-- Select a playlist --</option>
                        <!-- Playlists would be populated here -->
                    </select>
                </div>
                
                <div class="flex justify-end">
                    <button type="button" id="cancelAddToPlaylist" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                        Cancel
                    </button>
                    <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                        Add
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Player functionality
        const playPauseBtn = document.getElementById('playPauseBtn');
        const progressBar = document.getElementById('progressBar');
        const currentTimeEl = document.getElementById('currentTime');
        const totalTimeEl = document.getElementById('totalTime');
        const volumeBar = document.getElementById('volumeBar');
        
        let isPlaying = false;
        let currentTime = 0;
        let totalTime = 180; // 3 minutes in seconds
        let volume = 0.5;
        
        // Initialize player
        updateTimeDisplay();
        
        // Play/Pause functionality
        playPauseBtn.addEventListener('click', () => {
            isPlaying = !isPlaying;
            
            if (isPlaying) {
                playPauseBtn.innerHTML = '<i class="fas fa-pause text-2xl"></i>';
                startPlayback();
            } else {
                playPauseBtn.innerHTML = '<i class="fas fa-play text-2xl"></i>';
                pausePlayback();
            }
        });
        
        // Progress bar functionality
        document.querySelector('.progress-bar').addEventListener('click', (e) => {
            const progressBarWidth = e.currentTarget.clientWidth;
            const clickPosition = e.offsetX;
            const percentageClicked = clickPosition / progressBarWidth;
            
            currentTime = Math.floor(totalTime * percentageClicked);
            updateTimeDisplay();
            updateProgressBar();
        });
        
        // Volume bar functionality
        document.querySelector('.volume-bar').addEventListener('click', (e) => {
            const volumeBarWidth = e.currentTarget.clientWidth;
            const clickPosition = e.offsetX;
            const percentageClicked = clickPosition / volumeBarWidth;
            
            volume = percentageClicked;
            volumeBar.style.width = `${volume * 100}%`;
            
            // In a real implementation, you would set the audio volume here
        });
        
        // Like button
        const likeBtn = document.getElementById('likeBtn');
        if (likeBtn) {
            likeBtn.addEventListener('click', () => {
                const icon = likeBtn.querySelector('i');
                
                if (icon.classList.contains('far')) {
                    icon.classList.remove('far');
                    icon.classList.add('fas');
                    icon.classList.add('text-red-500');
                } else {
                    icon.classList.remove('fas');
                    icon.classList.remove('text-red-500');
                    icon.classList.add('far');
                }
            });
        }
        
        // Add to Playlist Modal
        const addToPlaylistBtn = document.getElementById('addToPlaylistBtn');
        const addToPlaylistModal = document.getElementById('addToPlaylistModal');
        const cancelAddToPlaylist = document.getElementById('cancelAddToPlaylist');
        
        if (addToPlaylistBtn) {
            addToPlaylistBtn.addEventListener('click', () => {
                addToPlaylistModal.classList.remove('hidden');
            });
        }
        
        if (cancelAddToPlaylist) {
            cancelAddToPlaylist.addEventListener('click', () => {
                addToPlaylistModal.classList.add('hidden');
            });
        }
        
        // Helper functions
        function startPlayback() {
            // In a real implementation, you would start the audio playback here
            // For this demo, we'll simulate playback with a timer
            window.playbackInterval = setInterval(() => {
                currentTime++;
                
                if (currentTime >= totalTime) {
                    currentTime = 0;
                    isPlaying = false;
                    playPauseBtn.innerHTML = '<i class="fas fa-play text-2xl"></i>';
                    clearInterval(window.playbackInterval);
                }
                
                updateTimeDisplay();
                updateProgressBar();
            }, 1000);
        }
        
        function pausePlayback() {
            // In a real implementation, you would pause the audio playback here
            clearInterval(window.playbackInterval);
        }
        
        function updateTimeDisplay() {
            currentTimeEl.textContent = formatTime(currentTime);
            totalTimeEl.textContent = formatTime(totalTime);
        }
        
        function updateProgressBar() {
            const percentage = (currentTime / totalTime) * 100;
            progressBar.style.width = `${percentage}%`;
        }
        
        function formatTime(seconds) {
            const minutes = Math.floor(seconds / 60);
            const remainingSeconds = seconds % 60;
            return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
        }
    </script>
</body>
</html>
