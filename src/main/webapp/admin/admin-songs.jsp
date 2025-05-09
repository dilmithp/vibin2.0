<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Admin Songs</title>
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
        // Check if admin is logged in
        if (session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-login.jsp");
            return;
        }
        
        String adminName = (String) session.getAttribute("adminName");
        
        // Initialize services
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        
        // Get all songs
        List<Song> allSongs = songService.getAllSongs();
    %>

    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="w-64 bg-gray-800 p-4">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Admin Portal</p>
            </div>
            
            <div class="mb-6">
                <div class="flex items-center mb-4">
                    <div class="h-12 w-12 rounded-full bg-red-700 flex items-center justify-center mr-3">
                        <i class="fas fa-user-shield text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold"><%= adminName %></h3>
                        <p class="text-sm text-gray-400">Administrator</p>
                    </div>
                </div>
            </div>
            
            <nav class="space-y-2">
                <a href="<%=request.getContextPath()%>/admin/admin-dashboard.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-songs.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
                    <i class="fas fa-music mr-3"></i> Songs
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-albums.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-compact-disc mr-3"></i> Albums
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-artists.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-user-music mr-3"></i> Artists
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-users.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-users mr-3"></i> Users
                </a>
                <a href="<%=request.getContextPath()%>/auth/logout" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white mt-8">
                    <i class="fas fa-sign-out-alt mr-3"></i> Logout
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="flex-1 overflow-y-auto">
            <!-- Header -->
            <div class="bg-gray-800 p-4 shadow-md">
                <div class="flex justify-between items-center">
                    <h2 class="text-xl font-bold">Songs Management</h2>
                    <div class="flex items-center">
                        <a href="<%=request.getContextPath()%>/songs/new" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            <i class="fas fa-plus mr-2"></i> Add New Song
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Songs Content -->
            <div class="p-6">
                <!-- Search and Filter -->
                <div class="bg-gray-800 p-4 rounded-lg mb-6">
                    <div class="flex flex-col md:flex-row gap-4">
                        <div class="flex-1">
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-search text-gray-500"></i>
                                </div>
                                <input type="text" id="searchSong" placeholder="Search songs..." 
                                       class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                        </div>
                        <div>
                            <select id="filterAlbum" class="px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                <option value="">All Albums</option>
                                <% 
                                List<Album> albums = albumService.getAllAlbums();
                                for (Album album : albums) { 
                                %>
                                    <option value="<%= album.getAlbumId() %>"><%= album.getAlbumName() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Songs Table -->
                <div class="bg-gray-800 rounded-lg overflow-hidden">
                    <table class="w-full">
                        <thead class="border-b border-gray-700">
                            <tr class="text-gray-400 text-left">
                                <th class="p-4">ID</th>
                                <th class="p-4">Title</th>
                                <th class="p-4">Singer</th>
                                <th class="p-4">Album</th>
                                <th class="p-4">Music Director</th>
                                <th class="p-4">Lyricist</th>
                                <th class="p-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allSongs.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="p-4 text-center text-gray-400">
                                        No songs found in the database.
                                    </td>
                                </tr>
                            <% } else { 
                                for (Song song : allSongs) { %>
                                <tr class="border-b border-gray-700 hover:bg-gray-700">
                                    <td class="p-4"><%= song.getSongId() %></td>
                                    <td class="p-4">
                                        <div class="flex items-center">
                                            <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                                <i class="fas fa-music text-gray-400"></i>
                                            </div>
                                            <%= song.getSongName() %>
                                        </div>
                                    </td>
                                    <td class="p-4 text-gray-300"><%= song.getSinger() != null ? song.getSinger() : "-" %></td>
                                    <td class="p-4 text-gray-300">
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
                                    <td class="p-4 text-gray-300"><%= song.getMusicDirector() != null ? song.getMusicDirector() : "-" %></td>
                                    <td class="p-4 text-gray-300"><%= song.getLyricist() != null ? song.getLyricist() : "-" %></td>
                                    <td class="p-4 text-right">
                                        <a href="<%=request.getContextPath()%>/songs/edit?id=<%= song.getSongId() %>" class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="<%=request.getContextPath()%>/songs/delete?id=<%= song.getSongId() %>" 
                                           onclick="return confirm('Are you sure you want to delete this song?')" 
                                           class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } 
                            } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <div class="mt-4 flex justify-between items-center">
                    <div class="text-gray-400 text-sm">
                        Showing <span class="font-medium"><%= allSongs.size() %></span> songs
                    </div>
                    <div class="flex space-x-1">
                        <button class="px-3 py-1 bg-gray-800 text-gray-400 rounded-md hover:bg-gray-700 disabled:opacity-50" disabled>
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="px-3 py-1 bg-purple-600 text-white rounded-md">1</button>
                        <button class="px-3 py-1 bg-gray-800 text-gray-400 rounded-md hover:bg-gray-700 disabled:opacity-50" disabled>
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Simple search functionality
        document.getElementById('searchSong').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const songName = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const singer = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                
                if (songName.includes(searchValue) || singer.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
        
        // Album filter
        document.getElementById('filterAlbum').addEventListener('change', function() {
            const albumId = this.value;
            const rows = document.querySelectorAll('tbody tr');
            
            if (!albumId) {
                rows.forEach(row => row.style.display = '');
                return;
            }
            
            rows.forEach(row => {
                const albumCell = row.querySelector('td:nth-child(4)');
                const albumLink = albumCell.querySelector('a');
                
                if (albumLink && albumLink.getAttribute('href').includes('id=' + albumId)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
