<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.User" %>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.UserService" %>
<%@ page import="com.vibin.service.PlaylistService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Admin Dashboard</title>
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
        ArtistService artistService = new ArtistService();
        UserService userService = new UserService();
        PlaylistService playlistService = new PlaylistService();
        
        // Get counts for dashboard stats
        int songCount = songService.getAllSongs().size();
        int albumCount = albumService.getAllAlbums().size();
        int artistCount = artistService.getAllArtists().size();
        int userCount = userService.getAllUsers().size();
        int playlistCount = playlistService.getAllPlaylists().size();
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
                <a href="<%=request.getContextPath()%>/admin/admin-dashboard.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold">Admin Dashboard</h2>
                    <div class="flex items-center">
                        <span class="mr-4 text-sm text-gray-400">Welcome, <%= adminName %></span>
                    </div>
                </div>
            </div>
            
            <!-- Dashboard Content -->
            <div class="p-6">
                <!-- Stats Overview -->
                <div class="grid grid-cols-1 md:grid-cols-5 gap-4 mb-8">
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-music text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Songs</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= songCount %></p>
                        <a href="<%=request.getContextPath()%>/admin/admin-songs.jsp" class="text-sm text-purple-400 hover:text-purple-300">Manage Songs →</a>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-compact-disc text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Albums</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= albumCount %></p>
                        <a href="<%=request.getContextPath()%>/admin/admin-albums.jsp" class="text-sm text-purple-400 hover:text-purple-300">Manage Albums →</a>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-user-music text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Artists</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= artistCount %></p>
                        <a href="<%=request.getContextPath()%>/admin/admin-artists.jsp" class="text-sm text-purple-400 hover:text-purple-300">Manage Artists →</a>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-users text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Users</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= userCount %></p>
                        <a href="<%=request.getContextPath()%>/admin/admin-users.jsp" class="text-sm text-purple-400 hover:text-purple-300">Manage Users →</a>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-list text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Playlists</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= playlistCount %></p>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">Quick Actions</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <a href="<%=request.getContextPath()%>/songs/new" class="bg-gray-700 hover:bg-gray-600 p-4 rounded-lg flex items-center">
                            <div class="h-10 w-10 rounded-full bg-purple-700 flex items-center justify-center mr-3">
                                <i class="fas fa-plus text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Add New Song</h4>
                                <p class="text-sm text-gray-400">Upload music to the platform</p>
                            </div>
                        </a>
                        <a href="<%=request.getContextPath()%>/albums/new" class="bg-gray-700 hover:bg-gray-600 p-4 rounded-lg flex items-center">
                            <div class="h-10 w-10 rounded-full bg-purple-700 flex items-center justify-center mr-3">
                                <i class="fas fa-plus text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Add New Album</h4>
                                <p class="text-sm text-gray-400">Create a new album</p>
                            </div>
                        </a>
                        <a href="<%=request.getContextPath()%>/artists/new" class="bg-gray-700 hover:bg-gray-600 p-4 rounded-lg flex items-center">
                            <div class="h-10 w-10 rounded-full bg-purple-700 flex items-center justify-center mr-3">
                                <i class="fas fa-plus text-white"></i>
                            </div>
                            <div>
                                <h4 class="font-medium">Add New Artist</h4>
                                <p class="text-sm text-gray-400">Register a new artist</p>
                            </div>
                        </a>
                    </div>
                </div>
                
                <!-- System Information -->
                <div class="bg-gray-800 rounded-lg p-6">
                    <h3 class="text-xl font-bold mb-4">System Information</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <h4 class="font-medium text-gray-400 mb-2">Server Information</h4>
                            <p class="mb-1"><span class="text-gray-400">Java Version:</span> <%= System.getProperty("java.version") %></p>
                            <p class="mb-1"><span class="text-gray-400">Server:</span> <%= application.getServerInfo() %></p>
                            <p class="mb-1"><span class="text-gray-400">Servlet Version:</span> <%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></p>
                            <p><span class="text-gray-400">JSP Version:</span> <%= JspFactory.getDefaultFactory().getEngineInfo().getSpecificationVersion() %></p>
                        </div>
                        <div>
                            <h4 class="font-medium text-gray-400 mb-2">Database Information</h4>
                            <p class="mb-1"><span class="text-gray-400">Songs:</span> <%= songCount %> records</p>
                            <p class="mb-1"><span class="text-gray-400">Albums:</span> <%= albumCount %> records</p>
                            <p class="mb-1"><span class="text-gray-400">Artists:</span> <%= artistCount %> records</p>
                            <p><span class="text-gray-400">Users:</span> <%= userCount %> records</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
