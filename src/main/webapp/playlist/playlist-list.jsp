<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - My Playlists</title>
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
        
        String userName = (String) session.getAttribute("name");
        
        // Get playlists from request attribute
        List<Playlist> listPlaylist = (List<Playlist>) request.getAttribute("listPlaylist");
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <nav class="ml-10 hidden md:flex space-x-6">
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="text-gray-300 hover:text-white">Home</a>
                        <a href="<%=request.getContextPath()%>/user/library.jsp" class="text-gray-300 hover:text-white">Library</a>
                        <a href="<%=request.getContextPath()%>/user/playlists.jsp" class="text-white">Playlists</a>
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
                            <a href="<%=request.getContextPath()%>/auth/logout" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-bold">My Playlists</h2>
            <a href="<%=request.getContextPath()%>/playlists/new" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                <i class="fas fa-plus mr-2"></i> Create New Playlist
            </a>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <% if (listPlaylist == null || listPlaylist.isEmpty()) { %>
                <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                    <i class="fas fa-list text-4xl text-gray-600 mb-4"></i>
                    <h4 class="text-lg font-medium mb-2">No playlists yet</h4>
                    <p class="text-gray-400 mb-4">Create your first playlist to organize your favorite songs.</p>
                    <a href="<%=request.getContextPath()%>/playlists/new" class="inline-block bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                        Create Playlist
                    </a>
                </div>
            <% } else { 
                for (Playlist playlist : listPlaylist) { %>
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-list text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-lg mb-1"><%= playlist.getPlaylistName() %></h3>
                        <p class="text-gray-400 mb-2"><%= playlist.getSongs().size() %> songs</p>
                        <div class="flex justify-between">
                            <a href="<%=request.getContextPath()%>/playlists/view?id=<%= playlist.getPlaylistId() %>" class="text-purple-400 hover:text-purple-300">
                                View
                            </a>
                            <div>
                                <a href="<%=request.getContextPath()%>/playlists/edit?id=<%= playlist.getPlaylistId() %>" class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<%=request.getContextPath()%>/playlists/delete?id=<%= playlist.getPlaylistId() %>" 
                                   onclick="return confirm('Are you sure you want to delete this playlist?')" 
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
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 border-t border-gray-700 p-6 mt-12">
        <div class="container mx-auto">
            <div class="flex flex-col md:flex-row justify-between items-center">
                <div class="mb-4 md:mb-0">
                    <h3 class="text-xl font-bold text-purple-500">Vibin</h3>
                    <p class="text-gray-400">© 2025 Vibin Music Store. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
