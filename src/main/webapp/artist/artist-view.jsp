<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Details</title>
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
        // Get artist from request attribute
        Artist artist = (Artist) request.getAttribute("artist");
        
        if (artist == null) {
            response.sendRedirect(request.getContextPath() + "/artists");
            return;
        }
        
        // Initialize services
        AlbumService albumService = new AlbumService();
        SongService songService = new SongService();
        
        // Get artist's albums and songs
        List<Album> artistAlbums = albumService.getAlbumsByArtist(artist.getArtistName());
        List<Song> artistSongs = songService.getSongsByArtist(artist.getArtistName());
    %>

    <!-- Header/Navigation -->
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <a href="<%=request.getContextPath()%>/" class="text-2xl font-bold text-purple-500">Vibin</a>
                    <nav class="ml-10 hidden md:flex space-x-6">
                        <a href="<%=request.getContextPath()%>/" class="text-gray-300 hover:text-white">Home</a>
                        <a href="<%=request.getContextPath()%>/browse" class="text-gray-300 hover:text-white">Browse</a>
                        <a href="<%=request.getContextPath()%>/library" class="text-gray-300 hover:text-white">Library</a>
                    </nav>
                </div>
                <div class="flex items-center">
                    <div class="relative">
                        <input type="text" placeholder="Search..." class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                        <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <a href="<%=request.getContextPath()%>/user/profile" class="ml-4 text-gray-300 hover:text-white">
                        <i class="fas fa-user"></i>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto px-6 py-8">
        <!-- Artist Header -->
        <div class="flex flex-col md:flex-row items-center md:items-start mb-10">
            <div class="w-48 h-48 rounded-full bg-gray-800 flex items-center justify-center mb-6 md:mb-0 md:mr-8 overflow-hidden">
                <i class="fas fa-user-music text-6xl text-gray-600"></i>
            </div>
            <div class="text-center md:text-left">
                <h1 class="text-4xl font-bold mb-2"><%= artist.getArtistName() %></h1>
                <p class="text-gray-400 mb-4"><%= artist.getGenre() %> • <%= artist.getCountry() %></p>
                <p class="text-gray-300 max-w-2xl mb-6"><%= artist.getBio() != null ? artist.getBio() : "No biography available." %></p>
                <div class="flex flex-wrap justify-center md:justify-start gap-3">
                    <button class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-full">
                        <i class="fas fa-play mr-2"></i> Play All
                    </button>
                    <button class="bg-transparent border border-gray-600 hover:border-white text-white px-6 py-2 rounded-full">
                        <i class="fas fa-heart mr-2"></i> Follow
                    </button>
                </div>
            </div>
        </div>

        <!-- Albums Section -->
        <section class="mb-12">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">Albums</h2>
                <% if (session != null && "admin".equals(session.getAttribute("userType"))) { %>
                    <a href="<%=request.getContextPath()%>/albums/new?artist=<%= artist.getArtistId() %>" class="text-purple-400 hover:text-purple-300 text-sm">
                        <i class="fas fa-plus mr-1"></i> Add Album
                    </a>
                <% } %>
            </div>
            
            <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
                <% if (artistAlbums.isEmpty()) { %>
                    <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                        <i class="fas fa-compact-disc text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No albums found</h4>
                        <p class="text-gray-400">This artist hasn't released any albums yet.</p>
                    </div>
                <% } else { 
                    for (Album album : artistAlbums) { %>
                    <a href="<%=request.getContextPath()%>/albums/view?id=<%= album.getAlbumId() %>" class="bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 transition duration-200">
                        <div class="h-40 bg-gray-700 flex items-center justify-center">
                            <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-sm mb-1 truncate"><%= album.getAlbumName() %></h3>
                            <p class="text-gray-400 text-xs"><%= album.getReleaseDate() != null ? album.getReleaseDate() : "No release date" %></p>
                        </div>
                    </a>
                <% } 
                } %>
            </div>
        </section>

        <!-- Songs Section -->
        <section>
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold">Popular Songs</h2>
                <% if (session != null && "admin".equals(session.getAttribute("userType"))) { %>
                    <a href="<%=request.getContextPath()%>/songs/new?artist=<%= artist.getArtistId() %>" class="text-purple-400 hover:text-purple-300 text-sm">
                        <i class="fas fa-plus mr-1"></i> Add Song
                    </a>
                <% } %>
            </div>
            
            <div class="bg-gray-800 rounded-lg overflow-hidden">
                <% if (artistSongs.isEmpty()) { %>
                    <div class="p-8 text-center">
                        <i class="fas fa-music text-4xl text-gray-600 mb-4"></i>
                        <h4 class="text-lg font-medium mb-2">No songs found</h4>
                        <p class="text-gray-400">This artist hasn't released any songs yet.</p>
                    </div>
                <% } else { %>
                    <table class="w-full">
                        <thead class="border-b border-gray-700">
                            <tr class="text-gray-400 text-left">
                                <th class="p-4 w-12">#</th>
                                <th class="p-4">Title</th>
                                <th class="p-4 hidden md:table-cell">Album</th>
                                <th class="p-4 hidden md:table-cell">Duration</th>
                                <th class="p-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int songCount = 0;
                            for (Song song : artistSongs) { 
                                songCount++;
                            %>
                                <tr class="border-b border-gray-700 hover:bg-gray-700">
                                    <td class="p-4 text-gray-400"><%= songCount %></td>
                                    <td class="p-4">
                                        <div class="flex items-center">
                                            <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
                                                <i class="fas fa-music text-gray-400"></i>
                                            </div>
                                            <%= song.getSongName() %>
                                        </div>
                                    </td>
                                    <td class="p-4 text-gray-300 hidden md:table-cell">
                                        <% if (song.getAlbumId() > 0) { 
                                            Album album = albumService.getAlbum(song.getAlbumId());
                                            if (album != null) { %>
                                                <%= album.getAlbumName() %>
                                            <% } else { %>
                                                -
                                            <% } 
                                        } else { %>
                                            -
                                        <% } %>
                                    </td>
                                    <td class="p-4 text-gray-300 hidden md:table-cell">3:45</td>
                                    <td class="p-4 text-right">
                                        <button class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-play"></i>
                                        </button>
                                        <button class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                        <button class="text-gray-400 hover:text-white px-2">
                                            <i class="fas fa-ellipsis-h"></i>
                                        </button>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </section>
    </main>

    <!-- Footer with Player -->
    <footer class="fixed bottom-0 left-0 right-0 bg-gray-800 border-t border-gray-700 p-3">
        <div class="container mx-auto flex items-center justify-between">
            <div class="flex items-center w-1/3">
                <div class="bg-gray-700 h-12 w-12 rounded-md mr-3 flex items-center justify-center">
                    <i class="fas fa-music text-gray-400"></i>
                </div>
                <div class="truncate">
                    <p class="font-medium truncate">No song playing</p>
                    <p class="text-sm text-gray-400 truncate">Select a song to play</p>
                </div>
            </div>
            
            <div class="w-1/3 flex flex-col items-center">
                <div class="flex items-center mb-2">
                    <button class="text-gray-400 hover:text-white mx-2">
                        <i class="fas fa-step-backward"></i>
                    </button>
                    <button class="bg-white rounded-full h-8 w-8 flex items-center justify-center text-gray-900 hover:bg-gray-200 mx-2">
                        <i class="fas fa-play"></i>
                    </button>
                    <button class="text-gray-400 hover:text-white mx-2">
                        <i class="fas fa-step-forward"></i>
                    </button>
                </div>
                <div class="w-full flex items-center">
                    <span class="text-xs text-gray-400 mr-2">0:00</span>
                    <div class="h-1 flex-1 bg-gray-700 rounded-full">
                        <div class="h-1 w-0 bg-purple-500 rounded-full"></div>
                    </div>
                    <span class="text-xs text-gray-400 ml-2">0:00</span>
                </div>
            </div>
            
            <div class="w-1/3 flex justify-end items-center">
                <button class="text-gray-400 hover:text-white mx-2">
                    <i class="fas fa-volume-up"></i>
                </button>
                <div class="w-24 h-1 bg-gray-700 rounded-full mx-2">
                    <div class="h-1 w-1/2 bg-purple-500 rounded-full"></div>
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
