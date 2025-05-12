<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.AlbumService" %>

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
        
        int artistId = (int) session.getAttribute("artistId");
        String artistName = (String) session.getAttribute("artistName");
        
        // Get album ID from request
        String albumIdParam = request.getParameter("id");
        if (albumIdParam == null || albumIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-albums.jsp");
            return;
        }
        
        int albumId = Integer.parseInt(albumIdParam);
        
        // Initialize services
        ArtistService artistService = new ArtistService();
        AlbumService albumService = new AlbumService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
        
        // Get album details
        Album album = albumService.getAlbum(albumId);
        
        // Check if album exists and belongs to the artist
        if (album == null || !album.getArtist().equals(artistName)) {
            response.sendRedirect(request.getContextPath() + "/artist/artist-albums.jsp");
            return;
        }
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
                <a href="<%=request.getContextPath()%>/artist/artist-songs.jsp" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
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
                    <h2 class="text-xl font-bold">Edit Album</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400">Tuesday, May 13, 2025, 3:51 AM +0530</span>
                    </div>
                </div>
            </div>
            
            <!-- Edit Album Form -->
            <div class="p-6">
                <div class="max-w-2xl mx-auto bg-gray-800 rounded-lg shadow-lg p-6">
                    <h3 class="text-2xl font-bold mb-6">Edit Album: <%= album.getAlbumName() %></h3>
                    
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="bg-red-600 bg-opacity-25 border border-red-600 text-red-500 px-4 py-3 rounded mb-4">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <form action="<%=request.getContextPath()%>/artist/update-album" method="post" class="space-y-6" id="albumForm" onsubmit="return validateForm()">
                        <input type="hidden" name="id" value="<%= album.getAlbumId() %>">
                        
                        <div>
                            <label for="albumName" class="block text-sm font-medium text-gray-400 mb-2">Album Title</label>
                            <input type="text" id="albumName" name="albumName" value="<%= album.getAlbumName() %>" required minlength="4" maxlength="150"
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <p id="albumNameError" class="text-red-500 text-xs mt-1 hidden">Album title must be at least 4 characters long</p>
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
                            <p id="genreError" class="text-red-500 text-xs mt-1 hidden">Please select a genre</p>
                        </div>
                        
                        <div>
                            <label for="releaseDate" class="block text-sm font-medium text-gray-400 mb-2">Release Date</label>
                            <input type="date" id="releaseDate" name="releaseDate" value="<%= album.getReleaseDate() %>" required
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <p id="releaseDateError" class="text-red-500 text-xs mt-1 hidden">Please select a release date</p>
                        </div>
                        
                        <div>
                            <label for="coverImage" class="block text-sm font-medium text-gray-400 mb-2">Cover Image (Optional)</label>
                            <% if (album.getCoverImage() != null && !album.getCoverImage().isEmpty()) { %>
                                <div class="mb-2 flex items-center">
                                    <img src="<%=request.getContextPath()%>/images/albums/<%= album.getCoverImage() %>" alt="<%= album.getAlbumName() %>" class="h-16 w-16 object-cover rounded mr-2">
                                    <span class="text-sm text-gray-400">Current cover image</span>
                                </div>
                            <% } %>
                            <input type="file" id="coverImage" name="coverImage" accept="image/*"
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            <p class="text-gray-500 text-xs mt-1">Recommended size: 500x500 pixels</p>
                        </div>
                        
                        <div>
                            <label for="description" class="block text-sm font-medium text-gray-400 mb-2">Description (Optional)</label>
                            <textarea id="description" name="description" rows="4"
                                      class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"><%= album.getDescription() != null ? album.getDescription() : "" %></textarea>
                        </div>
                        
                        <div class="flex justify-end space-x-4">
                            <a href="<%=request.getContextPath()%>/artist/artist-albums.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
                                Cancel
                            </a>
                            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            const albumName = document.getElementById('albumName').value;
            const genre = document.getElementById('genre').value;
            const releaseDate = document.getElementById('releaseDate').value;
            
            const albumNameError = document.getElementById('albumNameError');
            const genreError = document.getElementById('genreError');
            const releaseDateError = document.getElementById('releaseDateError');
            
            let isValid = true;
            
            // Check if album name has at least 4 characters
            if (albumName.length < 4) {
                albumNameError.classList.remove('hidden');
                isValid = false;
            } else {
                albumNameError.classList.add('hidden');
            }
            
            // Check if genre is selected
            if (!genre) {
                genreError.classList.remove('hidden');
                isValid = false;
            } else {
                genreError.classList.add('hidden');
            }
            
            // Check if release date is selected
            if (!releaseDate) {
                releaseDateError.classList.remove('hidden');
                isValid = false;
            } else {
                releaseDateError.classList.add('hidden');
            }
            
            return isValid;
        }
        
        // Real-time validation
        document.getElementById('albumName').addEventListener('input', function() {
            const albumName = this.value;
            const albumNameError = document.getElementById('albumNameError');
            
            if (albumName.length < 4 && albumName.length > 0) {
                albumNameError.classList.remove('hidden');
            } else {
                albumNameError.classList.add('hidden');
            }
        });
        
        document.getElementById('genre').addEventListener('change', function() {
            const genre = this.value;
            const genreError = document.getElementById('genreError');
            
            if (!genre) {
                genreError.classList.remove('hidden');
            } else {
                genreError.classList.add('hidden
