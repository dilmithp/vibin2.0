<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.User" %>
<%@ page import="com.vibin.model.Playlist" %>
<%@ page import="com.vibin.service.UserService" %>
<%@ page import="com.vibin.service.PlaylistService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Admin Users</title>
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
        UserService userService = new UserService();
        PlaylistService playlistService = new PlaylistService();
        
        // Get all users
        List<User> allUsers = userService.getAllUsers();
        
        // Get playlist counts for each user
        Map<Integer, Integer> userPlaylistCounts = new HashMap<>();
        for (User user : allUsers) {
            List<Playlist> userPlaylists = playlistService.getUserPlaylists(user.getId());
            userPlaylistCounts.put(user.getId(), userPlaylists.size());
        }
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
                    <h2 class="text-xl font-bold">Users Management</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400">Today: May 9, 2025</span>
                    </div>
                </div>
            </div>
            
            <!-- Users Content -->
            <div class="p-6">
                <!-- Search and Filter -->
                <div class="bg-gray-800 p-4 rounded-lg mb-6">
                    <div class="flex flex-col md:flex-row gap-4">
                        <div class="flex-1">
                            <div class="relative">
                                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                    <i class="fas fa-search text-gray-500"></i>
                                </div>
                                <input type="text" id="searchUser" placeholder="Search users..." 
                                       class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Users Stats -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-users text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Total Users</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= allUsers.size() %></p>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-user-plus text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">New Users (Last 30 Days)</h4>
                        </div>
                        <p class="text-2xl font-bold">12</p>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-headphones text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Active Users</h4>
                        </div>
                        <p class="text-2xl font-bold">45</p>
                    </div>
                </div>
                
                <!-- Users Table -->
                <div class="bg-gray-800 rounded-lg overflow-hidden">
                    <table class="w-full">
                        <thead class="border-b border-gray-700">
                            <tr class="text-gray-400 text-left">
                                <th class="p-4">ID</th>
                                <th class="p-4">Name</th>
                                <th class="p-4">Email</th>
                                <th class="p-4">Contact</th>
                                <th class="p-4">Playlists</th>
                                <th class="p-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allUsers.isEmpty()) { %>
                                <tr>
                                    <td colspan="6" class="p-4 text-center text-gray-400">
                                        No users found in the database.
                                    </td>
                                </tr>
                            <% } else { 
                                for (User user : allUsers) { %>
                                <tr class="border-b border-gray-700 hover:bg-gray-700">
                                    <td class="p-4"><%= user.getId() %></td>
                                    <td class="p-4">
                                        <div class="flex items-center">
                                            <div class="h-10 w-10 rounded-full bg-gray-700 flex items-center justify-center mr-3">
                                                <i class="fas fa-user text-gray-400"></i>
                                            </div>
                                            <%= user.getName() %>
                                        </div>
                                    </td>
                                    <td class="p-4 text-gray-300"><%= user.getEmail() %></td>
                                    <td class="p-4 text-gray-300"><%= user.getContactNo() != null ? user.getContactNo() : "-" %></td>
                                    <td class="p-4 text-gray-300"><%= userPlaylistCounts.get(user.getId()) %></td>
                                    <td class="p-4 text-right">
                                        <a href="<%=request.getContextPath()%>/users/view?id=<%= user.getId() %>" class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="<%=request.getContextPath()%>/users/delete?id=<%= user.getId() %>" 
                                           onclick="return confirm('Are you sure you want to delete this user?')" 
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
                        Showing <span class="font-medium"><%= allUsers.size() %></span> users
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
        // Simple search functionality
        document.getElementById('searchUser').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const userName = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const userEmail = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                
                if (userName.includes(searchValue) || userEmail.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
