<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.User" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.service.PlaylistService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - User Details</title>
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
        
        // Get user from request attribute
        User user = (User) request.getAttribute("user");
        List<Song> likedSongs = (List<Song>) request.getAttribute("likedSongs");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/admin/admin-users.jsp");
            return;
        }
        
        // Initialize services
        PlaylistService playlistService = new PlaylistService();
        
        // Get user's playlists
        List<Playlist> userPlaylists = playlistService.getUserPlaylists(user.getId());
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
                <a href="<%=request.getContextPath()%>/admin/admin-albums.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-compact-disc mr-3"></i> Albums
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-artists.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-user-music mr-3"></i> Artists
                </a>
                <a href="<%=request.getContextPath()%>/admin/admin-users.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold">User Details</h2>
                    <div class="flex items-center">
                        <a href="<%=request.getContextPath()%>/admin/admin-users.jsp" class="text-gray-400 hover:text-white">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Users
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- User Details -->
            <div class="p-6">
                <!-- User Profile Card -->
                <div class="bg-gray-800 rounded-lg p-6 mb-8">
                    <div class="flex flex-col md:flex-row items-center md:items-start">
                        <div class="h-32 w-32 rounded-full bg-gray-700 flex items-center justify-center mb-4 md:mb-0 md:mr-6">
                            <i class="fas fa-user text-5xl text-gray-500"></i>
                        </div>
                        <div class="text-center md:text-left">
                            <h3 class="text-2xl font-bold mb-2"><%= user.getName() %></h3>
                            <p class="text-gray-400 mb-4"><%= user.getEmail() %></p>
                            
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                                <div class="bg-gray-700 p-4 rounded-lg">
                                    <p class="text-sm text-gray-400">Contact</p>
                                    <p class="font-medium"><%= user.getContactNo() != null ? user.getContactNo() : "Not provided" %></p>
                                </div>
                                <div class="bg-gray-700 p-4 rounded-lg">
                                    <p class="text-sm text-gray-400">Playlists</p>
                                    <p class="font-medium"><%= userPlaylists.size() %></p>
                                </div>
                                <div class="bg-gray-700 p-4 rounded-lg">
                                    <p class="text-sm text-gray-400">Liked Songs</p>
                                    <p class="font-medium"><%= likedSongs != null ? likedSongs.size() : 0 %></p>
                                </div>
                            </div>
                            
                            <div class="flex justify-center md:justify-start space-x-3">
                                <a href="<%=request.getContextPath()%>/users/edit?id=<%= user.getId() %>" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                    <i class="fas fa-edit mr-2"></i> Edit User
                                </a>
                                <a href="<%=request.getContextPath()%>/users/delete?id=<%= user.getId() %>" 
                                   onclick="return confirm('Are you sure you want to delete this user? This action cannot be undone.')" 
                                   class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md">
                                    <i class="fas fa-trash-alt mr-2"></i> Delete User
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- User Playlists -->
                <div class="mb-8">
                    <h3 class="text-xl font-bold mb-4">User Playlists</h3>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <% if (userPlaylists.isEmpty()) { %>
                            <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                                <i class="fas fa-list text-4xl text-gray-600 mb-4"></i>
                                <h4 class="text-lg font-medium mb-2">No playlists found</h4>
                                <p class="text-gray-400">This user hasn't created any playlists yet.</p>
                            </div>
                        <% } else { 
                            for (Playlist playlist : userPlaylists) { %>
                            <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                                <div class="h-40 bg-gray-700 flex items-center justify-center">
                                    <i class="fas fa-list text-4xl text-gray-500"></i>
                                </div>
                                <div class="p-4">
                                    <h4 class="font-bold text-lg mb-1"><%= playlist.getPlaylistName() %></h4>
                                    <p class="text-gray-400 mb-2"><%= playlist.getSongs().size() %> songs</p>
                                    <div class="flex justify-end">
                                        <a href="<%=request.getContextPath()%>/playlists/view?id=<%= playlist.getPlaylistId() %>" class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <% } 
                        } %>
                    </div>
                </div>
                
                <!-- Liked Songs -->
                <div>
                    <h3 class="text-xl font-bold mb-4">Liked Songs</h3>
                    
                    <div class="bg-gray-800 rounded-lg overflow-hidden">
                        <% if (likedSongs == null || likedSongs.isEmpty()) { %>
                            <div class="p-8 text-center">
                                <i class="fas fa-heart text-4xl text-gray-600 mb-4"></i>
                                <h4 class="text-lg font-medium mb-2">No liked songs</h4>
                                <p class="text-gray-400">This user hasn't liked any songs yet.</p>
                            </div>
                        <% } else { %>
                            <table class="w-full">
                                <thead class="border-b border-gray-700">
                                    <tr class="text-gray-400 text-left">
                                        <th class="p-4">#</th>
                                        <th class="p-4">Title</th>
                                        <th class="p-4">Artist</th>
                                        <th class="p-4">Album</th>
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
                                            <td class="p-4 text-gray-300">
                                                <%= song.getAlbumId() > 0 ? "Album Name" : "-" %>
                                            </td>
                                            <td class="p-4 text-right">
                                                <a href="<%=request.getContextPath()%>/songs/view?id=<%= song.getSongId() %>" class="text-gray-400 hover:text-white px-2">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
