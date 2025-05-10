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
    <div class="min-h-screen flex items-center justify-center py-12">
        <div class="max-w-md w-full bg-gray-800 rounded-lg shadow-lg p-8">
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Artist Portal</p>
            </div>
            
            <h2 class="text-2xl font-bold mb-6">Artist Registration</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="bg-red-600 text-white px-4 py-3 rounded mb-4">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="<%=request.getContextPath()%>/artist/register" method="post" class="space-y-4">
                <div>
                    <label for="artistName" class="block text-sm font-medium text-gray-400 mb-2">Artist Name</label>
                    <input type="text" id="artistName" name="artistName" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                    <input type="email" id="email" name="email" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                    <input type="password" id="password" name="password" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div>
                    <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                    <select id="genre" name="genre" required
                            class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <option value="">Select Genre</option>
                        <option value="Pop">Pop</option>
                        <option value="Rock">Rock</option>
                        <option value="Hip Hop">Hip Hop</option>
                        <option value="R&B">R&B</option>
                        <option value="Electronic">Electronic</option>
                        <option value="Jazz">Jazz</option>
                        <option value="Classical">Classical</option>
                        <option value="Country">Country</option>
                        <option value="Folk">Folk</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                
                <div>
                    <label for="country" class="block text-sm font-medium text-gray-400 mb-2">Country</label>
                    <input type="text" id="country" name="country" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div>
                    <label for="bio" class="block text-sm font-medium text-gray-400 mb-2">Biography</label>
                    <textarea id="bio" name="bio" rows="4"
                              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"></textarea>
                </div>
                
                <div class="flex items-center">
                    <input type="checkbox" id="agree-term" name="agree-term" required
                           class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded">
                    <label for="agree-term" class="ml-2 block text-sm text-gray-400">
                        I agree to the <a href="#" class="text-purple-400 hover:text-purple-300">Terms and Conditions</a>
                    </label>
                </div>
                
                <div>
                    <button type="submit" class="w-full bg-purple-600 hover:bg-purple-700 text-white py-2 px-4 rounded-md">
                        Register
                    </button>
                </div>
            </form>
            
            <div class="mt-6 text-center">
                <p class="text-gray-400">Already have an account? <a href="<%=request.getContextPath()%>/artist/artist-login.jsp" class="text-purple-400 hover:text-purple-300">Login</a></p>
            </div>
            
            <div class="mt-8 text-center">
                <a href="<%=request.getContextPath()%>/" class="text-gray-400 hover:text-gray-300">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Home
                </a>
            </div>
        </div>
    </div>
</body>
</html>
