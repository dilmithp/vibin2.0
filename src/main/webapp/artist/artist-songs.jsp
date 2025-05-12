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
    <title>Vibin - My Songs</title>
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

        if (session.getAttribute("artistId") == null) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-login.jsp");
            return;
        }
        
        int artistId = (int) session.getAttribute("artistId");
        String artistName = (String) session.getAttribute("artistName");
        

        ArtistService artistService = new ArtistService();
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        

        Artist artist = artistService.getArtist(artistId);
        

        List<Song> artistSongs = songService.getSongsByArtist(artistName);
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
                <a href="<%=request.getContextPath()%>/artist/artist-albums.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-compact-disc mr-3"></i> My Albums
                </a>
                <a href="<%=request.getContextPath()%>/artist/artist-songs.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold">My Songs</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400">Tuesday, May 13, 2025, 3:51 AM +0530</span>
                    </div>
                </div>
            </div>
            
            <!-- Songs Content -->
            <div class="p-6">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-2xl font-bold">All Songs</h3>
                    <a href="<%=request.getContextPath()%>/artist/add-song.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                        <i class="fas fa-plus mr-2"></i> Add New Song
                    </a>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
                    <% if (artistSongs.isEmpty()) { %>
                        <div class="p-8 text-center">
                            <i class="fas fa-music text-5xl text-gray-600 mb-4"></i>
                            <h4 class="text-xl font-medium mb-2">No Songs Found</h4>
                            <p class="text-gray-400 mb-6">You haven't added any songs yet.</p>
                            <a href="<%=request.getContextPath()%>/artist/add-song.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-md">
                                Add Your First Song
                            </a>
                        </div>
                    <% } else { %>
                        <div class="overflow-x-auto">
                            <table class="w-full">
                                <thead>
                                    <tr class="bg-gray-750 text-left text-gray-400 border-b border-gray-700">
                                        <th class="py-3 px-4">#</th>
                                        <th class="py-3 px-4">Title</th>
                                        <th class="py-3 px-4">Album</th>
                                        <th class="py-3 px-4">Lyricist</th>
                                        <th class="py-3 px-4">Music Director</th>
                                        <th class="py-3 px-4 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    int count = 1;
                                    for (Song song : artistSongs) { 
                                    %>
                                        <tr class="border-b border-gray-700 hover:bg-gray-750">
                                            <td class="py-3 px-4"><%= count++ %></td>
                                            <td class="py-3 px-4"><%= song.getSongName() %></td>
                                            <td class="py-3 px-4">
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
                                            <td class="py-3 px-4"><%= song.getLyricist() != null ? song.getLyricist() : "-" %></td>
                                            <td class="py-3 px-4"><%= song.getMusicDirector() != null ? song.getMusicDirector() : "-" %></td>
                                            <td class="py-3 px-4 text-right">

                                                <a href="<%=request.getContextPath()%>/artist/edit-song?id=<%= song.getSongId() %>" class="text-gray-300 hover:text-white px-2">
                                                    <i class="fas fa-edit"></i>
                                                </a>

                                                <a href="<%=request.getContextPath()%>/artist/delete-song?id=<%= song.getSongId() %>" class="text-gray-300 hover:text-red-500 px-2">
                                                    <i class="fas fa-trash-alt"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
