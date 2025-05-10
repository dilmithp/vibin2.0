<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Profile</title>
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
        // Get artist ID from request
        String artistIdParam = request.getParameter("id");
        if (artistIdParam == null || artistIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        int artistId = Integer.parseInt(artistIdParam);
        
        // Initialize services
        ArtistService artistService = new ArtistService();
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
        
        if (artist == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Get artist's songs and albums
        List<Song> artistSongs = songService.getSongsByArtist(artist.getArtistName());
        List<Album> artistAlbums = albumService.getAlbumsByArtist(artist.getArtistName());
        
        // Check if user is logged in
        boolean isLoggedIn = session.getAttribute("id") != null;
        String userName = (String) session.getAttribute("name");
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <nav class="ml-10 hidden md:flex space-x-6">
                        <a href="<%=request.getContextPath()%>/" class="text-gray-300 hover:text-white">Home</a>
                        <% if (isLoggedIn) { %>
                            <a href="<%=request.getContextPath()%>/user/library.jsp" class="text-gray-300 hover:text-white">Library</a>
                            <a href="<%=request.getContextPath()%>/playlists" class="text-gray-300 hover:text-white">Playlists</a>
                            <a href="<%=request.getContextPath()%>/user/profile.jsp" class="text-gray-300 hover:text-white">Profile</a>
                            <a href="<%=request.getContextPath()%>/auth/logout" class="text-gray-300 hover:text-white">Logout</a>
                        <% } else { %>
                            <a href="<%=request.getContextPath()%>/auth/login.jsp" class="text-gray-300 hover:text-white">Login</a>
                            <a href="<%=request.getContextPath()%>/auth/register.jsp" class="text-gray-300 hover:text-white">Register</a>
                        <% } %>
                    </nav>
                </div>
                <div class="flex items-center">
                    <div class="relative mr-4">
                        <input type="text" placeholder="Search..." class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                        <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <% if (isLoggedIn) { %>
                        <div class="text-gray-300">
                            <span class="mr-2"><%= userName %></span>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <!-- Artist Header -->
        <div class="bg-gray-800 rounded-lg p-6 mb-8">
            <div class="flex flex-col md:flex-row items-center md:items-start">
                <div class="h-40 w-40 bg-gray-700 rounded-lg flex items-center justify-center mb-4 md:mb-0 md:mr-6">
                    <% if (artist.getImageUrl() != null && !artist.getImageUrl().isEmpty()) { %>
                        <img src="<%=request.getContextPath()%>/images/artists/<%= artist.getImageUrl() %>" alt="<%= artist.getArtistName() %>" class="h-full w-full object-cover rounded-lg">
                    <% } else { %>
                        <i class="fas fa-user-music text-5xl text-gray-500"></i>
                    <% } %>
                </div>
                <div class="text-center md:text-left">
                    <h2 class="text-3xl font-bold mb-2"><%= artist.getArtistName() %></h2>
                    <p class="text-gray-400 mb-2"><%= artist.getGenre() %> • <%= artist.getCountry() %></p>
                    <p class="text-gray-300 mb-4 max-w-2xl"><%= artist.getBio() != null ? artist.getBio() : "No biography available." %></p>
                    <div class="flex flex-wrap justify-center md:justify-start gap-2">
                        <button class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-full">
                            <i class="fas fa-play mr-2"></i> Play All
                        </button>
                        <button class="bg-transparent border border-gray-600 hover:border-white text-white px-6 py-2 rounded-full">
                            <i class="fas fa-heart mr-2"></i> Follow
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Albums Section -->
        <div class="mb-8">
            <h3 class="text-xl font-bold mb-4">Albums by <%= artist.getArtistName() %></h3>
            
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                <% if (artistAlbums.isEmpty()) { %>
                    <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No albums found</h4>
                        <p class="text-gray-400">This artist hasn't released any albums yet.</p>
                    </div>
                <% } else { 
                    for (Album album : artistAlbums) { %>
                    <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                        <div class="h-40 bg-gray-700 flex items-center justify-center">
                            <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-sm mb-1 truncate"><%= album.getAlbumName() %></h3>
                            <p class="text-gray-400 text-xs truncate"><%= album.getArtist() %></p>
                            <p class="text-gray-500 text-xs"><%= album.getReleaseDate() != null ? album.getReleaseDate() : "No release date" %></p>
                        </div>
                    </div>
                <% } 
                } %>
            </div>
        </div>
        
        <!-- Songs Section -->
        <div>
            <h3 class="text-xl font-bold mb-4">Songs by <%= artist.getArtistName() %></h3>
            
            <div class="bg-gray-800 rounded-lg overflow-hidden">
                <% if (artistSongs.isEmpty()) { %>
                    <div class="p-8 text-center">
                        <i class="fas fa-music text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No songs found</h4>
                        <p class="text-gray-400">This artist hasn't released any songs yet.</p>
                    </div>
                <% } else { %>
                    <table class="w-full">
                        <thead class="border-b border-gray-700">
                            <tr class="text-gray-400 text-left">
                                <th class="p-4 w-12">#</th>
                                <th class="p-4">Title</th>
                                <th class="p-4 hidden md:table-cell">Album</th>
                                <th class="p-4 hidden md:table-cell">Duration</th>
                                <th class="p-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int songCount = 0;
                            for (Song song : artistSongs) { 
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
                                    <td class="p-4 text-gray-300 hidden md:table-cell">
                                        <% if (song.getAlbumId() > 0) {
                                            Album album = albumService.getAlbum(song.getAlbumId());
                                            if (album != null) { %>
                                                <%= album.getAlbumName() %>
                                            <% } else { %>
                                                -
                                            <% }
                                        } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td class="p-4 text-gray-300 hidden md:table-cell">3:45</td>
                                    <td class="p-4 text-right">
                                        <button class="text-gray-400 hover:text-white px-2 play-btn" data-song-id="<%= song.getSongId() %>">
                                            <i class="fas fa-play"></i>
                                        </button>
                                        <% if (isLoggedIn) { %>
                                            <button class="text-gray-400 hover:text-white px-2 like-btn" data-song-id="<%= song.getSongId() %>">
                                                <i class="far fa-heart"></i>
                                            </button>
                                            <button class="text-gray-400 hover:text-white px-2 add-to-playlist-btn" 
                                                    data-song-id="<%= song.getSongId() %>" 
                                                    data-song-name="<%= song.getSongName() %>">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
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
                
                // Update player UI
                currentSongTitle.textContent = songTitle;
                currentSongArtist.textContent = "<%= artist.getArtistName() %>";
                
                // Change play button to pause
                playPauseBtn.innerHTML = '<i class="fas fa-pause"></i>';
                
                // In a real implementation, you would start playing the song here
                console.log(`Playing song: ${songTitle} by <%= artist.getArtistName() %>`);
            });
        });
    </script>
</body>
</html>
