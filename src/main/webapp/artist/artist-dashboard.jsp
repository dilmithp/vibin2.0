<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Dashboard</title>
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
        // Check if artist is logged in
        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-login.jsp");
            return;
        }
        
        int artistId = (int) session.getAttribute("artistId");
        String artistName = (String) session.getAttribute("artistName");
        
        // Initialize services
        ArtistService artistService = new ArtistService();
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
        
        // Get artist's songs and albums
        List<Song> artistSongs = songService.getSongsByArtist(artistName);
        List<Album> artistAlbums = albumService.getAlbumsByArtist(artistName);
        
        // Format current date
        SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy, h:mm a Z");
        String currentDate = "Tuesday, May 13, 2025, 3:47 AM +0530";
    %>

    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="w-64 bg-gray-800 p-4">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Artist Portal</p>
            </div>
            
            <div class="mb-6">
                <div class="flex items-center mb-4">
                    <div class="h-12 w-12 rounded-full bg-blue-700 flex items-center justify-center mr-3">
                        <% if (artist.getImageUrl() != null && !artist.getImageUrl().isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/images/artists/<%= artist.getImageUrl() %>" alt="<%= artistName %>" class="h-12 w-12 rounded-full object-cover">
                        <% } else { %>
                            <i class="fas fa-user-music text-xl"></i>
                        <% } %>
                    </div>
                    <div>
                        <h3 class="font-bold"><%= artistName %></h3>
                        <p class="text-sm text-gray-400">Artist</p>
                    </div>
                </div>
            </div>
            
            <nav class="space-y-2">
                <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
                    <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                </a>
                <a href="<%=request.getContextPath()%>/artist/artist-albums.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-compact-disc mr-3"></i> My Albums
                </a>
                <a href="<%=request.getContextPath()%>/artist/artist-songs.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-music mr-3"></i> My Songs
                </a>
                <a href="<%=request.getContextPath()%>/artist/add-album.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-plus mr-3"></i> Add Album
                </a>
                <a href="<%=request.getContextPath()%>/artist/add-song.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-plus mr-3"></i> Add Song
                </a>
                <a href="<%=request.getContextPath()%>/artist/artist-profile.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-user mr-3"></i> Profile
                </a>
                <a href="<%=request.getContextPath()%>/artist/logout" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white mt-8">
                    <i class="fas fa-sign-out-alt mr-3"></i> Logout
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="flex-1 overflow-y-auto">
            <!-- Header -->
            <div class="bg-gray-800 p-4 shadow-md">
                <div class="flex justify-between items-center">
                    <h2 class="text-xl font-bold">Artist Dashboard</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400"><%= currentDate %></span>
                    </div>
                </div>
            </div>
            
            <!-- Dashboard Content -->
            <div class="p-6">
                <!-- Welcome Section -->
                <div class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-2xl font-bold mb-2">Welcome back, <%= artistName %>!</h3>
                    <p class="text-gray-400 mb-4">Manage your music, view statistics, and keep your fans updated.</p>
                </div>
                
                <!-- Stats Overview -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                    <div class="bg-gray-800 p-6 rounded-lg">
                        <div class="flex items-center mb-4">
                            <div class="h-12 w-12 rounded-full bg-purple-700 flex items-center justify-center mr-3">
                                <i class="fas fa-music text-xl"></i>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-400">Total Songs</h4>
                                <p class="text-2xl font-bold"><%= artistSongs.size() %></p>
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/artist/artist-songs.jsp" class="text-purple-400 hover:text-purple-300 text-sm">
                            View all songs →
                        </a>
                    </div>
                    
                    <div class="bg-gray-800 p-6 rounded-lg">
                        <div class="flex items-center mb-4">
                            <div class="h-12 w-12 rounded-full bg-indigo-700 flex items-center justify-center mr-3">
                                <i class="fas fa-compact-disc text-xl"></i>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-400">Total Albums</h4>
                                <p class="text-2xl font-bold"><%= artistAlbums.size() %></p>
                            </div>
                        </div>
                        <a href="<%=request.getContextPath()%>/artist/artist-albums.jsp" class="text-purple-400 hover:text-purple-300 text-sm">
                            View all albums →
                        </a>
                    </div>
                    
                    <div class="bg-gray-800 p-6 rounded-lg">
                        <div class="flex items-center mb-4">
                            <div class="h-12 w-12 rounded-full bg-pink-700 flex items-center justify-center mr-3">
                                <i class="fas fa-headphones text-xl"></i>
                            </div>
                            <div>
                                <h4 class="font-medium text-gray-400">Total Plays</h4>
                                <p class="text-2xl font-bold">1,245</p>
                            </div>
                        </div>
                        <span class="text-gray-400 text-sm">Updated daily</span>
                    </div>
                </div>
                
                <!-- Recent Activity -->
                <div class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">Recent Activity</h3>
                    
                    <div class="space-y-4">
                        <div class="flex items-start">
                            <div class="h-10 w-10 rounded-full bg-gray-700 flex items-center justify-center mr-3 flex-shrink-0">
                                <i class="fas fa-music text-gray-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-300">You added a new song: <span class="font-medium">Sanda Thurule</span></p>
                                <p class="text-xs text-gray-500">Today, 2:45 AM</p>
                            </div>
                        </div>
                        
                        <div class="flex items-start">
                            <div class="h-10 w-10 rounded-full bg-gray-700 flex items-center justify-center mr-3 flex-shrink-0">
                                <i class="fas fa-compact-disc text-gray-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-300">You created a new album: <span class="font-medium">Sulanga Matha Mohothak</span></p>
                                <p class="text-xs text-gray-500">Yesterday, 4:15 PM</p>
                            </div>
                        </div>
                        
                        <div class="flex items-start">
                            <div class="h-10 w-10 rounded-full bg-gray-700 flex items-center justify-center mr-3 flex-shrink-0">
                                <i class="fas fa-user text-gray-400"></i>
                            </div>
                            <div>
                                <p class="text-gray-300">You updated your profile information</p>
                                <p class="text-xs text-gray-500">May 10, 2025, 6:30 PM</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="bg-gray-800 rounded-lg p-6">
                    <h3 class="text-xl font-bold mb-4">Quick Actions</h3>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <a href="<%=request.getContextPath()%>/artist/add-song.jsp" class="bg-gray-700 hover:bg-gray-600 p-4 rounded-lg flex items-center">
                            <div class="h-10 w-10 rounded-full bg-purple-700 flex items-center justify-center mr-3">
                                <i class="fas fa-plus text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Add New Song</h4>
                                <p class="text-sm text-gray-400">Upload music to the platform</p>
                            </div>
                        </a>
                        
                        <a href="<%=request.getContextPath()%>/artist/add-album.jsp" class="bg-gray-700 hover:bg-gray-600 p-4 rounded-lg flex items-center">
                            <div class="h-10 w-10 rounded-full bg-indigo-700 flex items-center justify-center mr-3">
                                <i class="fas fa-plus text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Add New Album</h4>
                                <p class="text-sm text-gray-400">Create a new album</p>
                            </div>
                        </a>
                        
                        <a href="<%=request.getContextPath()%>/artist/artist-profile.jsp" class="bg-gray-700 hover:bg-gray-600 p-4 rounded-lg flex items-center">
                            <div class="h-10 w-10 rounded-full bg-pink-700 flex items-center justify-center mr-3">
                                <i class="fas fa-user text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Edit Profile</h4>
                                <p class="text-sm text-gray-400">Update your artist information</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
