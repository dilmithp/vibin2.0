<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
<%@ page import="com.vibin.service.ArtistService" %>
<%@ page import="com.vibin.service.SongService" %>
<%@ page import="com.vibin.service.AlbumService" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Dashboard</title>
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
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        
        // Get artist details
        Artist artist = artistService.getArtist(artistId);
        
        // Get artist's songs and albums
        List<Song> artistSongs = songService.getSongsByArtist(artistName);
        List<Album> artistAlbums = albumService.getAlbumsByArtist(artistName);
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
                        <i class="fas fa-user-music text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold"><%= artistName %></h3>
                        <p class="text-sm text-gray-400">Artist</p>
                    </div>
                </div>
            </div>
            
            <nav class="space-y-2">
                <a href="#dashboard" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
                    <i class="fas fa-tachometer-alt mr-3"></i> Dashboard
                </a>
                <a href="#albums" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-compact-disc mr-3"></i> My Albums
                </a>
                <a href="#songs" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-music mr-3"></i> My Songs
                </a>
                <a href="#add-album" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-plus mr-3"></i> Add Album
                </a>
                <a href="#add-song" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-plus mr-3"></i> Add Song
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
                    <h2 class="text-xl font-bold">Artist Dashboard</h2>
                    <div class="flex items-center">
                        <span class="text-sm text-gray-400">Today: May 10, 2025</span>
                    </div>
                </div>
            </div>
            
            <!-- Dashboard Content -->
            <div class="p-6">
                <!-- Stats Overview -->
                <div id="dashboard" class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-music text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Songs</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= artistSongs.size() %></p>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-compact-disc text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Albums</h4>
                        </div>
                        <p class="text-2xl font-bold"><%= artistAlbums.size() %></p>
                    </div>
                    <div class="bg-gray-800 p-4 rounded-lg">
                        <div class="flex items-center mb-2">
                            <i class="fas fa-calendar-alt text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Joined</h4>
                        </div>
                        <p class="text-2xl font-bold">May 2025</p>
                    </div>
                </div>
                
                <!-- Albums Section -->
                <div id="albums" class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">My Albums</h3>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <% if (artistAlbums.isEmpty()) { %>
                            <div class="col-span-3 text-center py-8">
                                <i class="fas fa-compact-disc text-gray-600 text-4xl mb-4"></i>
                                <p class="text-gray-400">You haven't created any albums yet.</p>
                            </div>
                        <% } else { 
                            for (Album album : artistAlbums) { %>
                                <div class="bg-gray-700 rounded-lg overflow-hidden">
                                    <div class="h-40 bg-gray-600 flex items-center justify-center">
                                        <i class="fas fa-compact-disc text-4xl text-gray-400"></i>
                                    </div>
                                    <div class="p-4">
                                        <h4 class="font-bold mb-1"><%= album.getAlbumName() %></h4>
                                        <p class="text-sm text-gray-400 mb-2">
                                            <%= album.getGenre() %> • <%= album.getReleaseDate() %>
                                        </p>
                                        <div class="flex justify-end">
                                            <a href="<%=request.getContextPath()%>/artist/edit-album?id=<%= album.getAlbumId() %>" class="text-gray-400 hover:text-white px-2">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="<%=request.getContextPath()%>/artist/delete-album?id=<%= album.getAlbumId() %>" 
                                               onclick="return confirm('Are you sure you want to delete this album?')" 
                                               class="text-gray-400 hover:text-white px-2">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <% } 
                        } %>
                    </div>
                </div>
                
                <!-- Songs Section -->
                <div id="songs" class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">My Songs</h3>
                    
                    <div class="overflow-x-auto">
                        <% if (artistSongs.isEmpty()) { %>
                            <div class="text-center py-8">
                                <i class="fas fa-music text-gray-600 text-4xl mb-4"></i>
                                <p class="text-gray-400">You haven't added any songs yet.</p>
                            </div>
                        <% } else { %>
                            <table class="min-w-full">
                                <thead>
                                    <tr class="text-left text-gray-400 border-b border-gray-700">
                                        <th class="py-3 px-4">Title</th>
                                        <th class="py-3 px-4">Album</th>
                                        <th class="py-3 px-4">Lyricist</th>
                                        <th class="py-3 px-4">Music Director</th>
                                        <th class="py-3 px-4 text-right">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Song song : artistSongs) { %>
                                        <tr class="border-b border-gray-700 hover:bg-gray-750">
                                            <td class="py-3 px-4"><%= song.getSongName() %></td>
                                            <td class="py-3 px-4">
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
                                            <td class="py-3 px-4"><%= song.getLyricist() != null ? song.getLyricist() : "-" %></td>
                                            <td class="py-3 px-4"><%= song.getMusicDirector() != null ? song.getMusicDirector() : "-" %></td>
                                            <td class="py-3 px-4 text-right">
                                                <a href="<%=request.getContextPath()%>/artist/edit-song?id=<%= song.getSongId() %>" class="text-gray-400 hover:text-white px-2">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="<%=request.getContextPath()%>/artist/delete-song?id=<%= song.getSongId() %>" 
                                                   onclick="return confirm('Are you sure you want to delete this song?')" 
                                                   class="text-gray-400 hover:text-white px-2">
                                                    <i class="fas fa-trash-alt"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
                
                <!-- Add Album Form -->
                <div id="add-album" class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">Add New Album</h3>
                    
                    <form action="<%=request.getContextPath()%>/artist/add-album" method="post" class="space-y-4">
                        <div>
                            <label for="albumName" class="block text-sm font-medium text-gray-400 mb-2">Album Title</label>
                            <input type="text" id="albumName" name="albumName" required
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
                            <label for="releaseDate" class="block text-sm font-medium text-gray-400 mb-2">Release Date</label>
                            <input type="date" id="releaseDate" name="releaseDate" required
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div>
                            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                Add Album
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Add Song Form -->
                <div id="add-song" class="bg-gray-800 rounded-lg p-6">
                    <h3 class="text-xl font-bold mb-4">Add New Song</h3>
                    
                    <form action="<%=request.getContextPath()%>/artist/add-song" method="post" class="space-y-4">
                        <div>
                            <label for="songName" class="block text-sm font-medium text-gray-400 mb-2">Song Title</label>
                            <input type="text" id="songName" name="songName" required
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div>
                            <label for="albumId" class="block text-sm font-medium text-gray-400 mb-2">Album</label>
                            <select id="albumId" name="albumId"
                                    class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                <option value="0">No Album (Single)</option>
                                <% for (Album album : artistAlbums) { %>
                                    <option value="<%= album.getAlbumId() %>"><%= album.getAlbumName() %></option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div>
                            <label for="lyricist" class="block text-sm font-medium text-gray-400 mb-2">Lyricist</label>
                            <input type="text" id="lyricist" name="lyricist"
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div>
                            <label for="musicDirector" class="block text-sm font-medium text-gray-400 mb-2">Music Director</label>
                            <input type="text" id="musicDirector" name="musicDirector"
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div>
                            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md">
                                Add Song
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
