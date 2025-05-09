<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="<%=request.getContextPath()%>/js/validation.js"></script>
</head>
<body class="bg-gray-900 text-white">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-gray-800 p-8 rounded-lg shadow-xl w-full max-w-md">
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Online Music Store</p>
            </div>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="<%=request.getContextPath()%>/auth/login" method="post" onsubmit="return validateLoginForm(this)">
                <div class="mb-4">
                    <label for="username" class="block text-sm font-medium text-gray-400 mb-2">Username</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-user text-gray-500"></i>
                        </div>
                        <input type="text" id="username" name="username" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="mb-6">
                    <label for="password" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-500"></i>
                        </div>
                        <input type="password" id="password" name="password" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="flex items-center justify-between mb-6">
                    <div class="flex items-center">
                        <input id="remember" name="remember" type="checkbox" 
                               class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-600 rounded bg-gray-700">
                        <label for="remember" class="ml-2 block text-sm text-gray-400">
                            Remember me
                        </label>
                    </div>
                    <a href="#" class="text-sm text-purple-400 hover:text-purple-300">Forgot password?</a>
                </div>
                
                <button type="submit" 
                        class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 rounded-md font-medium transition duration-200">
                    Login
                </button>
                
                <div class="mt-6 text-center">
                    <p class="text-gray-400">
                        Don't have an account? 
                        <a href="register.jsp" class="text-purple-400 hover:text-purple-300">Sign up</a>
                    </p>
                </div>
                
                <div class="mt-6 text-center">
                    <p class="text-gray-400">
                        Are you an artist? 
                        <a href="<%=request.getContextPath()%>/artist/artist-login.jsp" class="text-purple-400 hover:text-purple-300">Artist Login</a>
                    </p>
                </div>
                <div class="mt-6 text-center">
                    <p class="text-gray-400">
                        Are you an Admin? 
                        <a href="<%=request.getContextPath()%>/admin/admin-login.jsp" class="text-purple-400 hover:text-purple-300">Admin Login</a>
                    </p>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function validateLoginForm(form) {
            if (form.username.value === "") {
                alert("Please enter your username");
                form.username.focus();
                return false;
            }
            if (form.password.value === "") {
                alert("Please enter your password");
                form.password.focus();
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
