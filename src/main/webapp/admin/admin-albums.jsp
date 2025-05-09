<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Admin Albums</title>
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
        AlbumService albumService = new AlbumService();
        
        // Get all albums
        List<Album> allAlbums = albumService.getAllAlbums();
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
                <a href="<%=request.getContextPath()%>/admin/admin-songs.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-music mr-3"></i> Songs
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-albums.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold">Albums Management</h2>
                    <div class="flex items-center">
                        <a href="<%=request.getContextPath()%>/albums/new" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            <i class="fas fa-plus mr-2"></i> Add New Album
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Albums Content -->
            <div class="p-6">
                <!-- Search and Filter -->
                <div class="bg-gray-800 p-4 rounded-lg mb-6">
                    <div class="flex flex-col md:flex-row gap-4">
                        <div class="flex-1">
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-search text-gray-500"></i>
                                </div>
                                <input type="text" id="searchAlbum" placeholder="Search albums..." 
                                       class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                        </div>
                        <div>
                            <select id="filterGenre" class="px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                <option value="">All Genres</option>
                                <option value="Pop">Pop</option>
                                <option value="Rock">Rock</option>
                                <option value="Hip Hop">Hip Hop</option>
                                <option value="R&B">R&B</option>
                                <option value="Electronic">Electronic</option>
                                <option value="Jazz">Jazz</option>
                                <option value="Classical">Classical</option>
                                <option value="Country">Country</option>
                                <option value="Folk">Folk</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <!-- Albums Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    <% if (allAlbums.isEmpty()) { %>
                        <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                            <i class="fas fa-compact-disc text-4xl text-gray-600 mb-4"></i>
                            <h4 class="text-lg font-medium mb-2">No albums found</h4>
                            <p class="text-gray-400 mb-4">Start by adding a new album to the platform</p>
                            <a href="<%=request.getContextPath()%>/albums/new" class="inline-block bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                                Add New Album
                            </a>
                        </div>
                    <% } else { 
                        for (Album album : allAlbums) { %>
                        <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200" data-genre="<%= album.getGenre() %>">
                            <div class="h-40 bg-gray-700 flex items-center justify-center">
                                <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold text-lg mb-1"><%= album.getAlbumName() %></h3>
                                <p class="text-gray-400 mb-2">By <%= album.getArtist() %></p>
                                <div class="flex justify-between items-center">
                                    <div>
                                        <span class="text-xs bg-gray-700 text-gray-300 px-2 py-1 rounded-full"><%= album.getGenre() %></span>
                                        <span class="text-xs text-gray-400 ml-2"><%= album.getReleaseDate() != null ? album.getReleaseDate() : "No release date" %></span>
                                    </div>
                                    <div class="flex">
                                        <a href="<%=request.getContextPath()%>/albums/edit?id=<%= album.getAlbumId() %>" class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="<%=request.getContextPath()%>/albums/delete?id=<%= album.getAlbumId() %>" 
                                           onclick="return confirm('Are you sure you want to delete this album?')" 
                                           class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } 
                    } %>
                </div>
                
                <!-- Pagination -->
                <div class="mt-6 flex justify-between items-center">
                    <div class="text-gray-400 text-sm">
                        Showing <span class="font-medium"><%= allAlbums.size() %></span> albums
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
        document.getElementById('searchAlbum').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const albums = document.querySelectorAll('.grid > div[data-genre]');
            
            albums.forEach(album => {
                const albumName = album.querySelector('h3').textContent.toLowerCase();
                const artist = album.querySelector('p').textContent.toLowerCase();
                
                if (albumName.includes(searchValue) || artist.includes(searchValue)) {
                    album.style.display = '';
                } else {
                    album.style.display = 'none';
                }
            });
        });
        
        // Genre filter
        document.getElementById('filterGenre').addEventListener('change', function() {
            const genre = this.value;
            const albums = document.querySelectorAll('.grid > div[data-genre]');
            
            if (!genre) {
                albums.forEach(album => album.style.display = '');
                return;
            }
            
            albums.forEach(album => {
                if (album.getAttribute('data-genre') === genre) {
                    album.style.display = '';
                } else {
                    album.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
