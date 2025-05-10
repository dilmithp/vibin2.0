<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.service.SongService" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Delete Song</title>
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
        
        // Get song ID from request parameter
        String songIdParam = request.getParameter("id");
        if (songIdParam == null || songIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-dashboard.jsp");
            return;
        }
        
        int songId = Integer.parseInt(songIdParam);
        
        // Get song details
        SongService songService = new SongService();
        Song song = songService.getSong(songId);
        
        // Verify this song belongs to the logged-in artist
        if (song == null || !song.getSinger().equals(artistName)) {
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
        <div class="max-w-md mx-auto">
            <!-- Back to Dashboard Link -->
            <div class="mb-6">
                <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="text-gray-400 hover:text-white">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
            </div>
            
            <!-- Delete Confirmation -->
            <div class="bg-gray-800 rounded-lg p-6 text-center">
                <div class="text-red-500 text-5xl mb-4">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h2 class="text-2xl font-bold mb-4">Delete Song</h2>
                <p class="mb-6">Are you sure you want to delete the song "<%= song.getSongName() %>"? This action cannot be undone.</p>
                
                <div class="flex justify-center space-x-4">
                    <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-6 py-2 rounded-md">
                        Cancel
                    </a>
                    <form action="<%=request.getContextPath()%>/artist/delete-song" method="post" class="inline">
                        <input type="hidden" name="id" value="<%= song.getSongId() %>">
                        <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-6 py-2 rounded-md">
                            Delete
                        </button>
                    </form>
                </div>
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
