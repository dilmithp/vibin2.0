<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.service.ArtistService" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Add New Album</title>
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
        
        String artistName = (String) session.getAttribute("artistName");
        int artistId = (int) session.getAttribute("artistId");
        
        // Initialize services
        ArtistService artistService = new ArtistService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/artist/artist-dashboard.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <span class="ml-2 text-sm text-gray-400">Artist Portal</span>
                </div>
                <div class="flex items-center">
                    <div class="text-gray-300 mr-4">
                        <span class="mr-2"><%= artistName %></span>
                    </div>
                    <a href="<%=request.getContextPath()%>/artist/logout" class="text-gray-300 hover:text-white">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <div class="max-w-3xl mx-auto">
            <!-- Back to Dashboard Link -->
            <div class="mb-6">
