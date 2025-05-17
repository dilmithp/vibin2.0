<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Admin Artists</title>
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
        ArtistService artistService = new ArtistService();
        SongService songService = new SongService();
        
        // Get all artists
        List<Artist> allArtists = artistService.getAllArtists();
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
                    <h2 class="text-xl font-bold">Artists Management</h2>
                    <div class="flex items-center">
                        <a href="<%=request.getContextPath()%>/artists/new" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            <i class="fas fa-plus mr-2"></i> Add New Artist
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Artists Content -->
            <div class="p-6">
                <!-- Search and Filter -->
                <div class="bg-gray-800 p-4 rounded-lg mb-6">
                    <div class="flex flex-col md:flex-row gap-4">
                        <div class="flex-1">
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-search text-gray-500"></i>
                                </div>
                                <input type="text" id="searchArtist" placeholder="Search artists..." 
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
                
                <!-- Artists Table -->
                <div class="bg-gray-800 rounded-lg overflow-hidden">
                    <table class="w-full">
                        <thead class="border-b border-gray-700">
                            <tr class="text-gray-400 text-left">
                                <th class="p-4">ID</th>
                                <th class="p-4">Artist Name</th>
                                <th class="p-4">Genre</th>
                                <th class="p-4">Country</th>
                                <th class="p-4">Email</th>
                                <th class="p-4">Songs</th>
                                <th class="p-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allArtists.isEmpty()) { %>
                                <tr>
                                    <td colspan="7" class="p-4 text-center text-gray-400">
                                        No artists found in the database.
                                    </td>
                                </tr>
                            <% } else { 
                                for (Artist artist : allArtists) { 
                                    int songCount = songService.getSongsByArtist(artist.getArtistName()).size();
                                %>
                                <tr class="border-b border-gray-700 hover:bg-gray-700" data-genre="<%= artist.getGenre() %>">
                                    <td class="p-4"><%= artist.getArtistId() %></td>
                                    <td class="p-4">
                                        <div class="flex items-center">
                                            <div class="h-10 w-10 rounded-full bg-gray-700 flex items-center justify-center mr-3">
                                                <i class="fas fa-user text-gray-400"></i>
                                            </div>
                                            <%= artist.getArtistName() %>
                                        </div>
                                    </td>
                                    <td class="p-4 text-gray-300"><%= artist.getGenre() != null ? artist.getGenre() : "-" %></td>
                                    <td class="p-4 text-gray-300"><%= artist.getCountry() != null ? artist.getCountry() : "-" %></td>
                                    <td class="p-4 text-gray-300"><%= artist.getEmail() != null ? artist.getEmail() : "-" %></td>
                                    <td class="p-4 text-gray-300"><%= songCount %></td>
                                    <td class="p-4 text-right">
                                        <a href="<%=request.getContextPath()%>/artists/view?id=<%= artist.getArtistId() %>" class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="<%=request.getContextPath()%>/artists/edit?id=<%= artist.getArtistId() %>" class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="<%=request.getContextPath()%>/artists/delete?id=<%= artist.getArtistId() %>" 
                                           onclick="return confirm('Are you sure you want to delete this artist?')" 
                                           class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </td>
                                </tr>
                            <% } 
                            } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination -->
                <div class="mt-4 flex justify-between items-center">
                    <div class="text-gray-400 text-sm">
                        Showing <span class="font-medium"><%= allArtists.size() %></span> artists
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
        document.getElementById('searchArtist').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr[data-genre]');
            
            rows.forEach(row => {
                const artistName = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const country = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                
                if (artistName.includes(searchValue) || country.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
        
        document.getElementById('filterGenre').addEventListener('change', function() {
            const genre = this.value;
            const rows = document.querySelectorAll('tbody tr[data-genre]');
            
            if (!genre) {
                rows.forEach(row => row.style.display = '');
                return;
            }
            
            rows.forEach(row => {
                if (row.getAttribute('data-genre') === genre) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
