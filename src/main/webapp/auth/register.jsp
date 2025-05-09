<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Sign Up</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="<%=request.getContextPath()%>/js/validation.js"></script>
</head>
<body class="bg-gray-900 text-white">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-gray-800 p-8 rounded-lg shadow-xl w-full max-w-md">
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Create Your Account</p>
            </div>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="<%=request.getContextPath()%>/auth/register" method="post" onsubmit="return validateRegisterForm(this)">
                <div class="mb-4">
                    <label for="name" class="block text-sm font-medium text-gray-400 mb-2">Full Name</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-user text-gray-500"></i>
                        </div>
                        <input type="text" id="name" name="name" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email Address</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-envelope text-gray-500"></i>
                        </div>
                        <input type="email" id="email" name="email" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="contact" class="block text-sm font-medium text-gray-400 mb-2">Contact Number</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-phone text-gray-500"></i>
                        </div>
                        <input type="text" id="contact" name="contact" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="mb-4">
                    <label for="pass" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-500"></i>
                        </div>
                        <input type="password" id="pass" name="pass" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="mb-6">
                    <label for="re_pass" class="block text-sm font-medium text-gray-400 mb-2">Confirm Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-500"></i>
                        </div>
                        <input type="password" id="re_pass" name="re_pass" 
                               class="w-full pl-10 pr-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                </div>
                
                <div class="flex items-center mb-6">
                    <input id="agree-term" name="agree-term" type="checkbox" 
                           class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-600 rounded bg-gray-700">
                    <label for="agree-term" class="ml-2 block text-sm text-gray-400">
                        I agree to the <a href="#" class="text-purple-400 hover:text-purple-300">Terms of Service</a>
                    </label>
                </div>
                
                <button type="submit" 
                        class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 rounded-md font-medium transition duration-200">
                    Create Account
                </button>
                
                <div class="mt-6 text-center">
                    <p class="text-gray-400">
                        Already have an account? 
                        <a href="login.jsp" class="text-purple-400 hover:text-purple-300">Sign in</a>
                    </p>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function validateRegisterForm(form) {
            if (form.name.value === "") {
                alert("Please enter your name");
                form.name.focus();
                return false;
            }
            if (form.email.value === "") {
                alert("Please enter your email");
                form.email.focus();
                return false;
            }
            if (form.contact.value === "") {
                alert("Please enter your contact number");
                form.contact.focus();
                return false;
            }
            if (form.pass.value === "") {
                alert("Please enter a password");
                form.pass.focus();
                return false;
            }
            if (form.re_pass.value === "") {
                alert("Please confirm your password");
                form.re_pass.focus();
                return false;
            }
            if (form.pass.value !== form.re_pass.value) {
                alert("Passwords do not match");
                form.re_pass.focus();
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
