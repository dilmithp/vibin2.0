<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Music Store</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/index2.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }
    </style>
</head>
<body class="bg-gray-900 text-white">
    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <nav class="ml-10 hidden md:flex space-x-6">
                        <a href="<%=request.getContextPath()%>/" class="text-white">Home</a>
                        <a href="<%=request.getContextPath()%>/songs" class="text-gray-300 hover:text-white">Songs</a>
                        <a href="<%=request.getContextPath()%>/albums" class="text-gray-300 hover:text-white">Albums</a>
                        <a href="<%=request.getContextPath()%>/artists" class="text-gray-300 hover:text-white">Artists</a>
                    </nav>
                </div>
                <div class="flex items-center">
                    <div class="relative mr-4">
                        <input type="text" placeholder="Search..." class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                        <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <a href="<%=request.getContextPath()%>/auth/login.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md mr-2">
                        Login
                    </a>
                    <a href="<%=request.getContextPath()%>/auth/register.jsp" class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
                        Sign Up
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="relative">
        <div class="h-96 bg-gradient-to-r from-purple-900 to-indigo-900 flex items-center">
            <div class="container mx-auto px-6">
                <div class="max-w-xl">
                    <h1 class="text-4xl font-bold mb-4">Discover, Stream, and Share Music</h1>
                    <p class="text-lg text-gray-300 mb-6">Unlimited access to millions of songs, podcasts, and playlists. Start your musical journey today.</p>
                    <a href="<%=request.getContextPath()%>/auth/register.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-3 rounded-full">
                        Get Started
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Section -->
    <section class="py-12">
        <div class="container mx-auto px-6">
            <h2 class="text-2xl font-bold mb-8">Featured Albums</h2>
            
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-sm mb-1 truncate">Sanda Thurule</h3>
                        <p class="text-gray-400 text-xs truncate">Bathiya and Santhush</p>
                        <p class="text-gray-500 text-xs">2003</p>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-sm mb-1 truncate">Sulanga Matha Mohothak</h3>
                        <p class="text-gray-400 text-xs truncate">Nilan Hettiarachchi</p>
                        <p class="text-gray-500 text-xs">2010</p>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-sm mb-1 truncate">Hadawatha Gee</h3>
                        <p class="text-gray-400 text-xs truncate">Kasun Kalhara</p>
                        <p class="text-gray-500 text-xs">2008</p>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-sm mb-1 truncate">Sihina Lowak</h3>
                        <p class="text-gray-400 text-xs truncate">Sangeeth Wijesuriya</p>
                        <p class="text-gray-500 text-xs">2012</p>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-sm mb-1 truncate">Ran Kurahan</h3>
                        <p class="text-gray-400 text-xs truncate">Iraj</p>
                        <p class="text-gray-500 text-xs">2007</p>
                    </div>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                    <div class="h-40 bg-gray-700 flex items-center justify-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                    </div>
                    <div class="p-4">
                        <h3 class="font-bold text-sm mb-1 truncate">Sanda Eliya</h3>
                        <p class="text-gray-400 text-xs truncate">Rookantha Gunathilake</p>
                        <p class="text-gray-500 text-xs">1998</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Popular Artists Section -->
    <section class="py-12 bg-gray-850">
        <div class="container mx-auto px-6">
            <h2 class="text-2xl font-bold mb-8">Popular Artists</h2>
            
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                <div class="text-center">
                    <div class="h-24 w-24 rounded-full bg-gray-700 mx-auto mb-3 flex items-center justify-center">
                        <i class="fas fa-user text-3xl text-gray-500"></i>
                    </div>
                    <h3 class="font-bold">Bathiya and Santhush</h3>
                    <p class="text-gray-400 text-sm">Pop</p>
                </div>
                
                <div class="text-center">
                    <div class="h-24 w-24 rounded-full bg-gray-700 mx-auto mb-3 flex items-center justify-center">
                        <i class="fas fa-user text-3xl text-gray-500"></i>
                    </div>
                    <h3 class="font-bold">Nilan Hettiarachchi</h3>
                    <p class="text-gray-400 text-sm">Classical</p>
                </div>
                
                <div class="text-center">
                    <div class="h-24 w-24 rounded-full bg-gray-700 mx-auto mb-3 flex items-center justify-center">
                        <i class="fas fa-user text-3xl text-gray-500"></i>
                    </div>
                    <h3 class="font-bold">Kasun Kalhara</h3>
                    <p class="text-gray-400 text-sm">Pop</p>
                </div>
                
                <div class="text-center">
                    <div class="h-24 w-24 rounded-full bg-gray-700 mx-auto mb-3 flex items-center justify-center">
                        <i class="fas fa-user text-3xl text-gray-500"></i>
                    </div>
                    <h3 class="font-bold">Sangeeth Wijesuriya</h3>
                    <p class="text-gray-400 text-sm">Rock</p>
                </div>
                
                <div class="text-center">
                    <div class="h-24 w-24 rounded-full bg-gray-700 mx-auto mb-3 flex items-center justify-center">
                        <i class="fas fa-user text-3xl text-gray-500"></i>
                    </div>
                    <h3 class="font-bold">Iraj</h3>
                    <p class="text-gray-400 text-sm">Hip Hop</p>
                </div>
                
                <div class="text-center">
                    <div class="h-24 w-24 rounded-full bg-gray-700 mx-auto mb-3 flex items-center justify-center">
                        <i class="fas fa-user text-3xl text-gray-500"></i>
                    </div>
                    <h3 class="font-bold">Rookantha Gunathilake</h3>
                    <p class="text-gray-400 text-sm">Classical</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Top Songs Section -->
    <section class="py-12">
        <div class="container mx-auto px-6">
            <h2 class="text-2xl font-bold mb-8">Top Songs</h2>
            
            <div class="bg-gray-800 rounded-lg overflow-hidden">
                <table class="w-full">
                    <thead class="border-b border-gray-700">
                        <tr class="text-gray-400 text-left">
                            <th class="p-4 w-12">#</th>
                            <th class="p-4">Title</th>
                            <th class="p-4">Artist</th>
                            <th class="p-4 hidden md:table-cell">Album</th>
                            <th class="p-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="border-b border-gray-700 hover:bg-gray-700">
                            <td class="p-4 text-gray-400">1</td>
                            <td class="p-4">
                                <div class="flex items-center">
                                    <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                        <i class="fas fa-music text-gray-400"></i>
                                    </div>
                                    Sanda Thurule
                                </div>
                            </td>
                            <td class="p-4 text-gray-300">Bathiya and Santhush</td>
                            <td class="p-4 text-gray-300 hidden md:table-cell">Sanda Thurule</td>
                            <td class="p-4 text-right">
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="far fa-heart"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </td>
                        </tr>
                        
                        <tr class="border-b border-gray-700 hover:bg-gray-700">
                            <td class="p-4 text-gray-400">2</td>
                            <td class="p-4">
                                <div class="flex items-center">
                                    <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                        <i class="fas fa-music text-gray-400"></i>
                                    </div>
                                    Sulanga Matha
                                </div>
                            </td>
                            <td class="p-4 text-gray-300">Nilan Hettiarachchi</td>
                            <td class="p-4 text-gray-300 hidden md:table-cell">Sulanga Matha Mohothak</td>
                            <td class="p-4 text-right">
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="far fa-heart"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </td>
                        </tr>
                        
                        <tr class="border-b border-gray-700 hover:bg-gray-700">
                            <td class="p-4 text-gray-400">3</td>
                            <td class="p-4">
                                <div class="flex items-center">
                                    <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                        <i class="fas fa-music text-gray-400"></i>
                                    </div>
                                    Mal Piyambanna
                                </div>
                            </td>
                            <td class="p-4 text-gray-300">Kasun Kalhara</td>
                            <td class="p-4 text-gray-300 hidden md:table-cell">Hadawatha Gee</td>
                            <td class="p-4 text-right">
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="far fa-heart"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </td>
                        </tr>
                        
                        <tr class="border-b border-gray-700 hover:bg-gray-700">
                            <td class="p-4 text-gray-400">4</td>
                            <td class="p-4">
                                <div class="flex items-center">
                                    <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                        <i class="fas fa-music text-gray-400"></i>
                                    </div>
                                    Sihina Lowak
                                </div>
                            </td>
                            <td class="p-4 text-gray-300">Sangeeth Wijesuriya</td>
                            <td class="p-4 text-gray-300 hidden md:table-cell">Sihina Lowak</td>
                            <td class="p-4 text-right">
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="far fa-heart"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </td>
                        </tr>
                        
                        <tr class="border-b border-gray-700 hover:bg-gray-700">
                            <td class="p-4 text-gray-400">5</td>
                            <td class="p-4">
                                <div class="flex items-center">
                                    <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                        <i class="fas fa-music text-gray-400"></i>
                                    </div>
                                    Ran Kurahan
                                </div>
                            </td>
                            <td class="p-4 text-gray-300">Iraj feat. Randhir</td>
                            <td class="p-4 text-gray-300 hidden md:table-cell">Ran Kurahan</td>
                            <td class="p-4 text-right">
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="far fa-heart"></i>
                                </button>
                                <button class="text-gray-400 hover:text-white px-2">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- Join Now Section -->
    <section class="py-16 bg-gradient-to-r from-purple-900 to-indigo-900">
        <div class="container mx-auto px-6 text-center">
            <h2 class="text-3xl font-bold mb-4">Start Listening Today</h2>
            <p class="text-lg text-gray-300 mb-8 max-w-2xl mx-auto">Join Vibin now and get unlimited access to millions of songs, curated playlists, and personalized recommendations.</p>
            <a href="<%=request.getContextPath()%>/auth/register.jsp" class="bg-purple-600 hover:bg-purple-700 text-white px-8 py-3 rounded-full text-lg font-bold">
                Sign Up Now
            </a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-800 border-t border-gray-700 p-6">
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
</body>
</html>
