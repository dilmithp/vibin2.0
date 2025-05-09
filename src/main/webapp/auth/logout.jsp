<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Logout</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-gray-800 p-8 rounded-lg shadow-xl w-full max-w-md text-center">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin</h1>
                <p class="text-gray-400">Online Music Store</p>
            </div>
            
            <%
                // Get the user's name from the session
                String userName = (String) session.getAttribute("name");
                
                // Invalidate the session
                session.invalidate();
            %>
            
            <div class="bg-green-800 text-white px-4 py-3 rounded mb-6">
                <% if(userName != null) { %>
                    <p>Goodbye, <%= userName %>! You have been successfully logged out.</p>
                <% } else { %>
                    <p>You have been successfully logged out.</p>
                <% } %>
            </div>
            
            <p class="mb-6 text-gray-300">Thank you for using Vibin Music Store.</p>
            
            <a href="<%=request.getContextPath()%>/auth/login" 
               class="inline-block w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 rounded-md font-medium transition duration-200">
                Return to Login
            </a>
        </div>
    </div>
</body>
</html>
