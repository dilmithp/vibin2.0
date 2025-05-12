<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - My Albums</title>
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
        AlbumService albumService = new AlbumService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
        
        // Get artist's albums
        List<Album> artistAlbums = albumService.getAlbumsByArtist(artistName);
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
                <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                </a>
                <a href="<%=request.getContextPath()%>/artist/artist-albums.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold">My Albums</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400">Tuesday, May 13, 2025, 3:51 AM +0530</span>
                    </div>
                </div>
            </div>
            
            <!-- Albums Content -->
            <div class="p-6">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-2xl font-bold">All Albums</h3>
                    <a href="<%=request.getContextPath()%>/artist/add-album.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                        <i class="fas fa-plus mr-2"></i> Add New Album
                    </a>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% if (artistAlbums.isEmpty()) { %>
                        <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                            <i class="fas fa-compact-disc text-5xl text-gray-600 mb-4"></i>
                            <h4 class="text-xl font-medium mb-2">No Albums Found</h4>
                            <p class="text-gray-400 mb-6">You haven't created any albums yet.</p>
                            <a href="<%=request.getContextPath()%>/artist/add-album.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-md">
                                Create Your First Album
                            </a>
                        </div>
                    <% } else { 
                        for (Album album : artistAlbums) { %>
                            <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
                                <div class="h-48 bg-gray-700 flex items-center justify-center">
                                    <% if (album.getCoverImage() != null && !album.getCoverImage().isEmpty()) { %>
                                        <img src="<%=request.getContextPath()%>/images/albums/<%= album.getCoverImage() %>" alt="<%= album.getAlbumName() %>" class="h-full w-full object-cover">
                                    <% } else { %>
                                        <i class="fas fa-compact-disc text-6xl text-gray-500"></i>
                                    <% } %>
                                </div>
                                <div class="p-4">
                                    <h4 class="text-xl font-bold mb-1"><%= album.getAlbumName() %></h4>
                                    <p class="text-gray-400 mb-2"><%= album.getGenre() %></p>
                                    <p class="text-gray-500 mb-4"><%= album.getReleaseDate() %></p>
                                    
                                    <div class="flex justify-between items-center">
                                        <span class="text-sm text-gray-400">
                                            <% 
                                            int songCount = albumService.getSongCountByAlbum(album.getAlbumId());
                                            %>
                                            <%= songCount %> song<%= songCount != 1 ? "s" : "" %>
                                        </span>
                                        <div class="flex space-x-2">
                                            <a href="<%=request.getContextPath()%>/artist/edit-album.jsp?id=<%= album.getAlbumId() %>" class="text-gray-300 hover:text-white">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="<%=request.getContextPath()%>/artist/delete-album.jsp?id=<%= album.getAlbumId() %>" class="text-gray-300 hover:text-red-500">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } 
                    } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
