<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.service.ArtistService" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Profile</title>
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
        
        // Initialize services
        ArtistService artistService = new ArtistService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
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
                <a href="<%=request.getContextPath()%>/artist/artist-profile.jsp" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
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
                    <h2 class="text-xl font-bold">Artist Profile</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400">Thursday, May 15, 2025, 10:38 PM +0530</span>
                    </div>
                </div>
            </div>
            
            <!-- Profile Content -->
            <div class="p-6">
                <div class="max-w-3xl mx-auto">
                    <!-- Profile Header -->
                    <div class="bg-gray-800 rounded-lg p-6 mb-8">
                        <div class="flex flex-col md:flex-row items-center md:items-start">
                            <div class="h-32 w-32 rounded-full bg-gray-700 flex items-center justify-center mb-4 md:mb-0 md:mr-6">
                                <% if (artist.getImageUrl() != null && !artist.getImageUrl().isEmpty()) { %>
                                    <img src="<%=request.getContextPath()%>/images/artists/<%= artist.getImageUrl() %>" alt="<%= artistName %>" class="h-32 w-32 rounded-full object-cover">
                                <% } else { %>
                                    <i class="fas fa-user-music text-5xl text-gray-500"></i>
                                <% } %>
                            </div>
                            <div class="text-center md:text-left">
                                <h1 class="text-3xl font-bold mb-2"><%= artistName %></h1>
                                <p class="text-gray-400 mb-4"><%= artist.getGenre() %> • <%= artist.getCountry() %></p>
                                <button id="editProfileBtn" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                    <i class="fas fa-edit mr-2"></i> Edit Profile
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Profile Information -->
                    <div class="bg-gray-800 rounded-lg p-6 mb-8">
                        <h3 class="text-xl font-bold mb-4">Profile Information</h3>
                        
                        <div class="space-y-4">
                            <div>
                                <h4 class="text-sm font-medium text-gray-400">Artist Name</h4>
                                <p class="text-lg"><%= artistName %></p>
                            </div>
                            
                            <div>
                                <h4 class="text-sm font-medium text-gray-400">Email</h4>
                                <p class="text-lg"><%= artist.getEmail() != null ? artist.getEmail() : "Not provided" %></p>
                            </div>
                            
                            <div>
                                <h4 class="text-sm font-medium text-gray-400">Genre</h4>
                                <p class="text-lg"><%= artist.getGenre() != null ? artist.getGenre() : "Not specified" %></p>
                            </div>
                            
                            <div>
                                <h4 class="text-sm font-medium text-gray-400">Country</h4>
                                <p class="text-lg"><%= artist.getCountry() != null ? artist.getCountry() : "Not specified" %></p>
                            </div>
                            
                            <div>
                                <h4 class="text-sm font-medium text-gray-400">Biography</h4>
                                <p class="text-lg"><%= artist.getBio() != null ? artist.getBio() : "No biography available." %></p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Edit Profile Form (Hidden by default) -->
                    <div id="editProfileForm" class="bg-gray-800 rounded-lg p-6 mb-8 hidden">
                        <h3 class="text-xl font-bold mb-4">Edit Profile</h3>
                        
                        <form action="<%=request.getContextPath()%>/artist/update-profile" method="post" enctype="multipart/form-data" class="space-y-6">
                            <input type="hidden" name="artistId" value="<%= artistId %>">
                            
                            <div>
                                <label for="artistName" class="block text-sm font-medium text-gray-400 mb-2">Artist Name</label>
                                <input type="text" id="artistName" name="artistName" value="<%= artistName %>" required
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                                <input type="email" id="email" name="email" value="<%= artist.getEmail() != null ? artist.getEmail() : "" %>" required
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                                <select id="genre" name="genre" required
                                        class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                    <option value="">Select Genre</option>
                                    <option value="Pop" <%= "Pop".equals(artist.getGenre()) ? "selected" : "" %>>Pop</option>
                                    <option value="Rock" <%= "Rock".equals(artist.getGenre()) ? "selected" : "" %>>Rock</option>
                                    <option value="Hip Hop" <%= "Hip Hop".equals(artist.getGenre()) ? "selected" : "" %>>Hip Hop</option>
                                    <option value="R&B" <%= "R&B".equals(artist.getGenre()) ? "selected" : "" %>>R&B</option>
                                    <option value="Electronic" <%= "Electronic".equals(artist.getGenre()) ? "selected" : "" %>>Electronic</option>
                                    <option value="Jazz" <%= "Jazz".equals(artist.getGenre()) ? "selected" : "" %>>Jazz</option>
                                    <option value="Classical" <%= "Classical".equals(artist.getGenre()) ? "selected" : "" %>>Classical</option>
                                    <option value="Country" <%= "Country".equals(artist.getGenre()) ? "selected" : "" %>>Country</option>
                                    <option value="Folk" <%= "Folk".equals(artist.getGenre()) ? "selected" : "" %>>Folk</option>
                                    <option value="Other" <%= "Other".equals(artist.getGenre()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            
                            <div>
                                <label for="country" class="block text-sm font-medium text-gray-400 mb-2">Country</label>
                                <input type="text" id="country" name="country" value="<%= artist.getCountry() != null ? artist.getCountry() : "" %>" required
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="bio" class="block text-sm font-medium text-gray-400 mb-2">Biography</label>
                                <textarea id="bio" name="bio" rows="4"
                                          class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"><%= artist.getBio() != null ? artist.getBio() : "" %></textarea>
                            </div>
                            
                            <div>
                                <label for="profileImage" class="block text-sm font-medium text-gray-400 mb-2">Profile Image</label>
                                <% if (artist.getImageUrl() != null && !artist.getImageUrl().isEmpty()) { %>
                                    <div class="mb-2 flex items-center">
                                        <img src="<%=request.getContextPath()%>/images/artists/<%= artist.getImageUrl() %>" alt="<%= artistName %>" class="h-16 w-16 rounded-full object-cover mr-2">
                                        <span class="text-sm text-gray-400">Current profile image</span>
                                    </div>
                                <% } %>
                                <input type="file" id="profileImage" name="profileImage" accept="image/*"
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="currentPassword" class="block text-sm font-medium text-gray-400 mb-2">Current Password (required to save changes)</label>
                                <input type="password" id="currentPassword" name="currentPassword" required
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div class="pt-4 border-t border-gray-700">
                                <h4 class="text-lg font-medium mb-4">Change Password (Optional)</h4>
                                
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
                            
                            <div class="flex justify-end space-x-4">
                                <button type="button" id="cancelEditBtn" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
                                    Cancel
                                </button>
                                <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                    Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Change Password Section -->
                    <div class="bg-gray-800 rounded-lg p-6 mb-8">
                        <h3 class="text-xl font-bold mb-4">Security</h3>
                        
                        <div class="flex justify-between items-center">
                            <div>
                                <h4 class="font-medium">Password</h4>
                                <p class="text-gray-400 text-sm">Last changed: 30 days ago</p>
                            </div>
                            <button id="changePasswordBtn" class="text-purple-400 hover:text-purple-300">
                                Change Password
                            </button>
                        </div>
                    </div>
                    
                    <!-- Delete Account Section -->
                    <div class="bg-gray-800 rounded-lg p-6">
                        <h3 class="text-xl font-bold text-red-500 mb-4">Danger Zone</h3>
                        
                        <div class="border border-red-700 rounded-lg p-4">
                            <div class="flex justify-between items-center">
                                <div>
                                    <h4 class="font-medium">Delete Account</h4>
                                    <p class="text-gray-400 text-sm">Once you delete your account, there is no going back. Please be certain.</p>
                                </div>
                                <form action="<%=request.getContextPath()%>/artist/delete-account" method="post" onsubmit="return confirmDelete()">
                                    <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md">
                                        Delete Account
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle edit profile form
        const editProfileBtn = document.getElementById('editProfileBtn');
        const editProfileForm = document.getElementById('editProfileForm');
        const cancelEditBtn = document.getElementById('cancelEditBtn');
        
        editProfileBtn.addEventListener('click', function() {
            editProfileForm.classList.remove('hidden');
            window.scrollTo({
                top: editProfileForm.offsetTop - 100,
                behavior: 'smooth'
            });
        });
        
        cancelEditBtn.addEventListener('click', function() {
            editProfileForm.classList.add('hidden');
        });
        
        // Password validation
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        
        confirmPasswordInput.addEventListener('input', function() {
            if (newPasswordInput.value !== confirmPasswordInput.value) {
                confirmPasswordInput.setCustomValidity("Passwords don't match");
            } else {
                confirmPasswordInput.setCustomValidity('');
            }
        });
        
        // Delete account confirmation
        function confirmDelete() {
            return confirm("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.");
        }
    </script>
</body>
</html>
