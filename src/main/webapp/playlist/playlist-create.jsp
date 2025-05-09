<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Playlist" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Create Playlist</title>
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
        
        // Check if editing existing playlist
        Playlist playlist = (Playlist) request.getAttribute("playlist");
        boolean isEditing = (playlist != null);
        String formTitle = isEditing ? "Edit Playlist" : "Create New Playlist";
        String submitButtonText = isEditing ? "Save Changes" : "Create Playlist";
        String formAction = isEditing ? request.getContextPath() + "/playlists/update" : request.getContextPath() + "/playlists/create";
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
        <div class="max-w-md mx-auto">
            <div class="bg-gray-800 rounded-lg p-6">
                <h2 class="text-2xl font-bold mb-6"><%= formTitle %></h2>
                
                <form action="<%= formAction %>" method="post" class="space-y-4">
                    <% if (isEditing) { %>
                        <input type="hidden" name="id" value="<%= playlist.getPlaylistId() %>">
                    <% } %>
                    
                    <div>
                        <label for="playlistName" class="block text-sm font-medium text-gray-400 mb-2">Playlist Name</label>
                        <input type="text" id="playlistName" name="playlistName" 
                               value="<%= isEditing ? playlist.getPlaylistName() : "" %>"
                               required
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="description" class="block text-sm font-medium text-gray-400 mb-2">Description (Optional)</label>
                        <textarea id="description" name="description" rows="3"
                                  class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"><%= isEditing && playlist.getDescription() != null ? playlist.getDescription() : "" %></textarea>
                    </div>
                    
                    <div class="flex justify-end pt-4">
                        <a href="<%=request.getContextPath()%>/user/playlists.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                            Cancel
                        </a>
                        <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            <%= submitButtonText %>
                        </button>
                    </div>
                </form>
            </div>
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
