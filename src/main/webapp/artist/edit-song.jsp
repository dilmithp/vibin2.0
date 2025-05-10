<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Edit Song</title>
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
        
        String artistName = (String) session.getAttribute("artistName");
        
        // Get song from request attribute
        Song song = (Song) request.getAttribute("song");
        List<Album> artistAlbums = (List<Album>) request.getAttribute("artistAlbums");
        
        if (song == null) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard.jsp");
            return;
        }
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <span class="ml-2 text-sm text-gray-400">Artist Portal</span>
                </div>
                <div class="flex items-center">
                    <div class="text-gray-300 mr-4">
                        <span class="mr-2"><%= artistName %></span>
                    </div>
                    <a href="<%=request.getContextPath()%>/artist/logout" class="text-gray-300 hover:text-white">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <div class="max-w-3xl mx-auto">
            <!-- Back to Dashboard Link -->
            <div class="mb-6">
                <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="text-gray-400 hover:text-white">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
            </div>
            
            <!-- Edit Song Form -->
            <div class="bg-gray-800 rounded-lg p-6">
                <h2 class="text-2xl font-bold mb-6">Edit Song: <%= song.getSongName() %></h2>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <form action="<%=request.getContextPath()%>/artist/update-song" method="post" class="space-y-6">
                    <input type="hidden" name="id" value="<%= song.getSongId() %>">
                    
                    <div>
                        <label for="songName" class="block text-sm font-medium text-gray-400 mb-2">Song Title</label>
                        <input type="text" id="songName" name="songName" value="<%= song.getSongName() %>" required
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="albumId" class="block text-sm font-medium text-gray-400 mb-2">Album</label>
                        <select id="albumId" name="albumId" 
                                class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <option value="0">No Album (Single)</option>
                            <% if (artistAlbums != null) {
                                for (Album album : artistAlbums) { %>
                                    <option value="<%= album.getAlbumId() %>" <%= song.getAlbumId() == album.getAlbumId() ? "selected" : "" %>>
                                        <%= album.getAlbumName() %>
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>
                    
                    <div>
                        <label for="lyricist" class="block text-sm font-medium text-gray-400 mb-2">Lyricist</label>
                        <input type="text" id="lyricist" name="lyricist" value="<%= song.getLyricist() != null ? song.getLyricist() : "" %>"
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="musicDirector" class="block text-sm font-medium text-gray-400 mb-2">Music Director</label>
                        <input type="text" id="musicDirector" name="musicDirector" value="<%= song.getMusicDirector() != null ? song.getMusicDirector() : "" %>"
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div class="pt-4">
                        <p class="text-gray-400 mb-2">Artist: <%= artistName %></p>
                    </div>
                    
                    <div class="flex justify-end">
                        <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                            Cancel
                        </a>
                        <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            Save Changes
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
