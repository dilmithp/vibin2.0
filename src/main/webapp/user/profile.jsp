<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.User" %>
<%@ page import="com.vibin.service.UserService" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Your Profile</title>
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
        
        int userId = (int) session.getAttribute("id");
        String userName = (String) session.getAttribute("name");
        String userEmail = (String) session.getAttribute("email");
        
        // Initialize services
        UserService userService = new UserService();
        
        // Get full user details
        User user = userService.getUserById(userId);
        
        // Check for success message
        String successMessage = (String) request.getAttribute("successMessage");
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
                        <a href="<%=request.getContextPath()%>/playlists" class="text-gray-300 hover:text-white">Playlists</a>
                    </nav>
                </div>
                <div class="flex items-center">
                    <div class="relative mr-4">
                        <input type="text" placeholder="Search..." class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                        <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <div class="relative group">
                        <button class="flex items-center text-white">
                            <span class="mr-2"><%= userName %></span>
                            <i class="fas fa-user-circle text-xl"></i>
                        </button>
                        <div class="absolute right-0 mt-2 w-48 bg-gray-800 rounded-md shadow-lg py-1 z-10 hidden group-hover:block">
                            <a href="<%=request.getContextPath()%>/user/profile.jsp" class="block px-4 py-2 text-sm text-white bg-gray-700">Profile</a>
                            <a href="<%=request.getContextPath()%>/auth/logout" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">Logout</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <div class="max-w-3xl mx-auto">
            <!-- Success Message -->
            <% if (successMessage != null) { %>
                <div class="bg-green-600 text-white px-4 py-3 rounded mb-6">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <!-- Profile Header -->
            <div class="bg-gray-800 rounded-lg p-6 mb-8">
                <div class="flex flex-col md:flex-row items-center">
                    <div class="h-32 w-32 rounded-full bg-purple-700 flex items-center justify-center mb-4 md:mb-0 md:mr-6">
                        <span class="text-4xl font-bold"><%= userName.substring(0, 1).toUpperCase() %></span>
                    </div>
                    <div class="text-center md:text-left">
                        <h1 class="text-3xl font-bold mb-2"><%= userName %></h1>
                        <p class="text-gray-400 mb-4"><%= userEmail %></p>
                        <div class="flex flex-wrap justify-center md:justify-start gap-2">
                            <a href="<%=request.getContextPath()%>/user/library.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
                                <i class="fas fa-heart mr-2"></i> Liked Songs
                            </a>
                            <a href="<%=request.getContextPath()%>/playlists" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
                                <i class="fas fa-list mr-2"></i> Playlists
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Profile Form -->
            <div class="bg-gray-800 rounded-lg p-6">
                <h2 class="text-xl font-bold mb-6">Edit Profile</h2>
                
                <form action="<%=request.getContextPath()%>/users/update" method="post" class="space-y-6">
                    <input type="hidden" name="id" value="<%= userId %>">
                    
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-400 mb-2">Name</label>
                        <input type="text" id="name" name="name" value="<%= userName %>" required
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                        <input type="email" id="email" name="email" value="<%= userEmail %>" required
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="contactNo" class="block text-sm font-medium text-gray-400 mb-2">Contact Number</label>
                        <input type="text" id="contactNo" name="contactNo" value="<%= user.getContactNo() != null ? user.getContactNo() : "" %>"
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="currentPassword" class="block text-sm font-medium text-gray-400 mb-2">Current Password (required to save changes)</label>
                        <input type="password" id="currentPassword" name="currentPassword" required
                               class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div class="pt-4 border-t border-gray-700">
                        <h3 class="text-lg font-medium mb-4">Change Password (Optional)</h3>
                        
                        <div class="space-y-4">
                            <div>
                                <label for="newPassword" class="block text-sm font-medium text-gray-400 mb-2">New Password</label>
                                <input type="password" id="newPassword" name="newPassword"
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="confirmPassword" class="block text-sm font-medium text-gray-400 mb-2">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                        </div>
                    </div>
                    
                    <div class="flex justify-end">
                        <a href="<%=request.getContextPath()%>/user/index.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md mr-2">
                            Cancel
                        </a>
                        <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                            Save Changes
                        </button>
                    </div>
                </form>
                
				<!-- Delete Account Section -->
				<div class="mt-8 pt-6 border-t border-gray-700">
				    <h3 class="text-lg font-medium text-red-500 mb-4">Danger Zone</h3>
				    <p class="text-gray-400 mb-4">Once you delete your account, there is no going back. Please be certain.</p>
				    
				    <button type="button" id="deleteAccountBtn" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md">
				        Delete Account
				    </button>
				    
				    <!-- Delete Account Confirmation Modal -->
				    <div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
				        <div class="bg-gray-800 p-6 rounded-lg max-w-md">
				            <h4 class="text-xl font-bold mb-4">Confirm Account Deletion</h4>
				            <p class="text-gray-300 mb-6">Are you sure you want to delete your account? All your data including playlists and liked songs will be permanently removed.</p>
				            
				            <form action="<%=request.getContextPath()%>/users/delete-account" method="post">
				                <div class="flex justify-end space-x-4">
				                    <button type="button" id="cancelDeleteBtn" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
				                        No
				                    </button>
				                    <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md">
				                        Yes
				                    </button>
				                </div>
				            </form>
				        </div>
				    </div>
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
                <div class="flex space-x-4">
                    <a href="#" class="text-gray-400 hover:text-white">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white">
                        <i class="fab fa-instagram"></i>
                    </a>
                </div>
            </div>
        </div>
    </footer>

    <script>
        const form = document.querySelector('form');
        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        
        form.addEventListener('submit', function(e) {
            if (newPassword.value || confirmPassword.value) {
                if (newPassword.value !== confirmPassword.value) {
                    e.preventDefault();
                    alert('New passwords do not match!');
                    return;
                }
                
                if (newPassword.value.length < 8) {
                    e.preventDefault();
                    alert('Password must be at least 8 characters long!');
                    return;
                }
            }
        });
        
        const deleteAccountBtn = document.getElementById('deleteAccountBtn');
        const deleteModal = document.getElementById('deleteModal');
        const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

        deleteAccountBtn.addEventListener('click', function() {
            deleteModal.classList.remove('hidden');
        });

        cancelDeleteBtn.addEventListener('click', function() {
            deleteModal.classList.add('hidden');
        });

        window.addEventListener('click', function(e) {
            if (e.target === deleteModal) {
                deleteModal.classList.add('hidden');
            }
        });
    </script>
</body>
</html>
