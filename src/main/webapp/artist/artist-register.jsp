<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Registration</title>
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
    <div class="min-h-screen flex items-center justify-center py-12 px-4">
        <div class="bg-gray-800 p-8 rounded-lg shadow-xl w-full max-w-lg">
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Artist Registration</p>
            </div>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="<%=request.getContextPath()%>/artist/register" method="post" onsubmit="return validateForm(this)">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="artistName" class="block text-sm font-medium text-gray-400 mb-2">Artist/Band Name</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-500"></i>
                            </div>
                            <input type="text" id="artistName" name="artistName" 
                                   class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                    </div>
                    
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email Address</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-envelope text-gray-500"></i>
                            </div>
                            <input type="email" id="email" name="email" 
                                   class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-500"></i>
                            </div>
                            <input type="password" id="password" name="password" 
                                   class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                    </div>
                    
                    <div>
                        <label for="confirmPassword" class="block text-sm font-medium text-gray-400 mb-2">Confirm Password</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-500"></i>
                            </div>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                    </div>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                    <div>
                        <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-music text-gray-500"></i>
                            </div>
                            <select id="genre" name="genre" 
                                   class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                <option value="">Select Genre</option>
                                <option value="Rock">Rock</option>
                                <option value="Pop">Pop</option>
                                <option value="Hip Hop">Hip Hop</option>
                                <option value="Electronic">Electronic</option>
                                <option value="Jazz">Jazz</option>
                                <option value="Classical">Classical</option>
                                <option value="R&B">R&B</option>
                                <option value="Country">Country</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>
                    
                    <div>
                        <label for="country" class="block text-sm font-medium text-gray-400 mb-2">Country</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-globe text-gray-500"></i>
                            </div>
                            <input type="text" id="country" name="country" 
                                   class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="bio" class="block text-sm font-medium text-gray-400 mb-2">Bio</label>
                    <textarea id="bio" name="bio" rows="4" 
                              class="w-full p-3 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                              placeholder="Tell us about yourself or your band..."></textarea>
                </div>
                
                <div class="flex items-center mb-6">
                    <input id="agree-term" name="agree-term" type="checkbox" 
                           class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-600 rounded bg-gray-700">
                    <label for="agree-term" class="ml-2 block text-sm text-gray-400">
                        I agree to the <a href="#" class="text-purple-400 hover:text-purple-300">Terms of Service</a> and confirm that I own or have rights to the music I will upload
                    </label>
                </div>
                
                <button type="submit" 
                        class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 rounded-md font-medium transition duration-200">
                    Register as Artist
                </button>
                
                <div class="mt-6 text-center">
                    <p class="text-gray-400">
                        Already registered? 
                        <a href="<%=request.getContextPath()%>/artist/artist-login.jsp" class="text-purple-400 hover:text-purple-300">Login here</a>
                    </p>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function validateForm(form) {
            if (form.artistName.value === "") {
                alert("Please enter your artist/band name");
                form.artistName.focus();
                return false;
            }
            if (form.email.value === "") {
                alert("Please enter your email");
                form.email.focus();
                return false;
            }
            if (form.password.value === "") {
                alert("Please enter a password");
                form.password.focus();
                return false;
            }
            if (form.confirmPassword.value === "") {
                alert("Please confirm your password");
                form.confirmPassword.focus();
                return false;
            }
            if (form.password.value !== form.confirmPassword.value) {
                alert("Passwords do not match");
                form.confirmPassword.focus();
                return false;
            }
            if (form.genre.value === "") {
                alert("Please select a genre");
                form.genre.focus();
                return false;
            }
            if (form.country.value === "") {
                alert("Please enter your country");
                form.country.focus();
                return false;
            }
            if (!form["agree-term"].checked) {
                alert("Please agree to the Terms of Service");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
