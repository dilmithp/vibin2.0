<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Album" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Edit Album</title>
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
        
        // Get album from request attribute
        Album album = (Album) request.getAttribute("album");
        
        if (album == null) {
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
            
            <!-- Edit Album Form -->
            <div class="bg-gray-800 rounded-lg p-6">
                <h2 class="text-2xl font-bold mb-6">Edit Album: <%= album.getAlbumName() %></h2>
                
                <% if(request.getAttribute("error") != null) { %>
                    <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                
                <form action="<%=request.getContextPath()%>/artist/update-album" method="post" class="space-y-6">
                    <input type="hidden" name="id" value="<%= album.getAlbumId() %>">
                    
                    <div>
                        <label for="albumName" class="block text-sm font-medium text-gray-400 mb-2">Album Title</label>
                        <input type="text" id="albumName" name="albumName" value="<%= album.getAlbumName() %>" required
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                        <select id="genre" name="genre" required
                                class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <option value="">Select Genre</option>
                            <option value="Pop" <%= "Pop".equals(album.getGenre()) ? "selected" : "" %>>Pop</option>
                            <option value="Rock" <%= "Rock".equals(album.getGenre()) ? "selected" : "" %>>Rock</option>
                            <option value="Hip Hop" <%= "Hip Hop".equals(album.getGenre()) ? "selected" : "" %>>Hip Hop</option>
                            <option value="R&B" <%= "R&B".equals(album.getGenre()) ? "selected" : "" %>>R&B</option>
                            <option value="Electronic" <%= "Electronic".equals(album.getGenre()) ? "selected" : "" %>>Electronic</option>
                            <option value="Jazz" <%= "Jazz".equals(album.getGenre()) ? "selected" : "" %>>Jazz</option>
                            <option value="Classical" <%= "Classical".equals(album.getGenre()) ? "selected" : "" %>>Classical</option>
                            <option value="Country" <%= "Country".equals(album.getGenre()) ? "selected" : "" %>>Country</option>
                            <option value="Folk" <%= "Folk".equals(album.getGenre()) ? "selected" : "" %>>Folk</option>
                            <option value="Other" <%= "Other".equals(album.getGenre()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    
                    <div>
                        <label for="releaseDate" class="block text-sm font-medium text-gray-400 mb-2">Release Date</label>
                        <input type="date" id="releaseDate" name="releaseDate" value="<%= album.getReleaseDate() %>" required
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
