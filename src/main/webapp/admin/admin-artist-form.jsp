<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Form</title>
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
        
        // Check if editing existing artist
        Artist artist = (Artist) request.getAttribute("artist");
        boolean isEditing = (artist != null);
        String formTitle = isEditing ? "Edit Artist" : "Add New Artist";
        String submitButtonText = isEditing ? "Update Artist" : "Add Artist";
        String formAction = isEditing ? request.getContextPath() + "/artists/update" : request.getContextPath() + "/artists/insert";
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
                <a href="<%=request.getContextPath()%>/admin/admin-artists.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold"><%= formTitle %></h2>
                    <div class="flex items-center">
                        <a href="<%=request.getContextPath()%>/admin/admin-artists.jsp" class="text-gray-400 hover:text-white">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Artists
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Form Content -->
            <div class="p-6">
                <div class="bg-gray-800 rounded-lg p-6">
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <form action="<%= formAction %>" method="post" class="space-y-6">
                        <% if(isEditing) { %>
                            <input type="hidden" name="id" value="<%= artist.getArtistId() %>">
                        <% } %>
                        
                        <div>
                            <label for="artistName" class="block text-sm font-medium text-gray-400 mb-2">Artist Name</label>
                            <input type="text" id="artistName" name="artistName" 
                                   value="<%= isEditing ? artist.getArtistName() : "" %>"
                                   required
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                                <select id="genre" name="genre" required
                                        class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                    <option value="">Select Genre</option>
                                    <option value="Pop" <%= isEditing && "Pop".equals(artist.getGenre()) ? "selected" : "" %>>Pop</option>
                                    <option value="Rock" <%= isEditing && "Rock".equals(artist.getGenre()) ? "selected" : "" %>>Rock</option>
                                    <option value="Hip Hop" <%= isEditing && "Hip Hop".equals(artist.getGenre()) ? "selected" : "" %>>Hip Hop</option>
                                    <option value="R&B" <%= isEditing && "R&B".equals(artist.getGenre()) ? "selected" : "" %>>R&B</option>
                                    <option value="Electronic" <%= isEditing && "Electronic".equals(artist.getGenre()) ? "selected" : "" %>>Electronic</option>
                                    <option value="Jazz" <%= isEditing && "Jazz".equals(artist.getGenre()) ? "selected" : "" %>>Jazz</option>
                                    <option value="Classical" <%= isEditing && "Classical".equals(artist.getGenre()) ? "selected" : "" %>>Classical</option>
                                    <option value="Country" <%= isEditing && "Country".equals(artist.getGenre()) ? "selected" : "" %>>Country</option>
                                    <option value="Folk" <%= isEditing && "Folk".equals(artist.getGenre()) ? "selected" : "" %>>Folk</option>
                                    <option value="Other" <%= isEditing && "Other".equals(artist.getGenre()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            
                            <div>
                                <label for="country" class="block text-sm font-medium text-gray-400 mb-2">Country</label>
                                <input type="text" id="country" name="country" 
                                       value="<%= isEditing && artist.getCountry() != null ? artist.getCountry() : "" %>"
                                       required
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                        </div>
                        
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                            <input type="email" id="email" name="email" 
                                   value="<%= isEditing && artist.getEmail() != null ? artist.getEmail() : "" %>"
                                   required
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div>
                            <label for="bio" class="block text-sm font-medium text-gray-400 mb-2">Biography</label>
                            <textarea id="bio" name="bio" rows="4"
                                      class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"><%= isEditing && artist.getBio() != null ? artist.getBio() : "" %></textarea>
                        </div>
                        
                        <div class="flex justify-end">
                            <a href="<%=request.getContextPath()%>/admin/admin-artists.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                                Cancel
                            </a>
                            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                <%= submitButtonText %>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
