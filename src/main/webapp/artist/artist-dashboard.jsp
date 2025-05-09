<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.vibin.model.Artist" %>
<%@ page import="com.vibin.model.Song" %>
<%@ page import="com.vibin.model.Album" %>
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
        SongService songService = new SongService();
        AlbumService albumService = new AlbumService();
        
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
                    <div class="h-12 w-12 rounded-full bg-purple-700 flex items-center justify-center mr-3">
                        <i class="fas fa-user text-xl"></i>
                    </div>
                    <div>
                        <h3 class="font-bold"><%= artistName %></h3>
                        <p class="text-sm text-gray-400">Artist</p>
                    </div>
                </div>
            </div>
            
            <nav class="space-y-2">
                <a href="#" class="flex items-center p-2 rounded-md bg-gray-700 text-white">
                    <i class="fas fa-chart-line mr-3"></i> Dashboard
                </a>
                <a href="#albums" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-compact-disc mr-3"></i> My Albums
                </a>
                <a href="#songs" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-music mr-3"></i> My Songs
                </a>
                <a href="#addAlbum" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
                    <i class="fas fa-plus-circle mr-3"></i> Add Album
                </a>
                <a href="#addSong" class="flex items-center p-2 rounded-md hover:bg-gray-700 text-gray-300 hover:text-white">
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
                        <span class="mr-4 text-sm text-gray-400">Today: May 9, 2025</span>
                    </div>
                </div>
            </div>
            
            <!-- Dashboard Content -->
            <div class="p-6">
                <!-- Stats Overview -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
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
                            <i class="fas fa-calendar text-purple-500 mr-2 text-xl"></i>
                            <h4 class="font-medium">Joined</h4>
                        </div>
                        <p class="text-2xl font-bold">May 2025</p>
                    </div>
                </div>
                
                <!-- My Albums -->
                <div id="albums" class="mb-8">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-xl font-bold">My Albums</h3>
                        <a href="#addAlbum" class="text-purple-400 hover:text-purple-300 text-sm">
                            <i class="fas fa-plus mr-1"></i> Add New Album
                        </a>
                    </div>
                    
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <% if (artistAlbums.isEmpty()) { %>
                            <div class="col-span-full bg-gray-800 p-8 rounded-lg text-center">
                                <i class="fas fa-compact-disc text-4xl text-gray-600 mb-4"></i>
                                <h4 class="text-lg font-medium mb-2">No albums yet</h4>
                                <p class="text-gray-400 mb-4">Create your first album to organize your songs</p>
                                <a href="#addAlbum" class="inline-block bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                                    Create Album
                                </a>
                            </div>
                        <% } else { 
                            for (Album album : artistAlbums) { %>
                            <div class="bg-gray-800 p-4 rounded-lg hover:bg-gray-700 transition duration-200">
                                <div class="bg-gray-700 h-40 rounded-md mb-3 flex items-center justify-center">
                                    <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                                </div>
                                <h4 class="font-medium truncate"><%= album.getAlbumName() %></h4>
                                <p class="text-sm text-gray-400 truncate">
                                    <%= album.getReleaseDate() != null ? album.getReleaseDate() : "No release date" %> • <%= album.getSongCount() %> songs
                                </p>
                                <div class="mt-2 flex justify-end">
                                    <a href="<%=request.getContextPath()%>/albums/edit?id=<%= album.getAlbumId() %>" class="text-gray-400 hover:text-white px-2">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="<%=request.getContextPath()%>/albums/delete?id=<%= album.getAlbumId() %>" 
                                       onclick="return confirm('Are you sure you want to delete this album?')" 
                                       class="text-gray-400 hover:text-white px-2">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </div>
                            </div>
                        <% } 
                        } %>
                    </div>
                </div>
                
                <!-- My Songs -->
                <div id="songs" class="mb-8">
                    <div class="flex justify-between items-center mb-4">
                        <h3 class="text-xl font-bold">My Songs</h3>
                        <a href="#addSong" class="text-purple-400 hover:text-purple-300 text-sm">
                            <i class="fas fa-plus mr-1"></i> Add New Song
                        </a>
                    </div>
                    
                    <div class="bg-gray-800 rounded-lg overflow-hidden">
				    <table class="w-full">
				    <thead class="border-b border-gray-700">
				        <tr class="text-gray-400 text-left">
				            <th class="p-4">Title</th>
				            <th class="p-4">Album</th>
				            <th class="p-4">Lyricist</th>
				            <th class="p-4">Music Director</th>
				            <th class="p-4 text-right">Actions</th>
				        </tr>
				    </thead>
				    <tbody>
				        <% if (artistSongs.isEmpty()) { %>
				            <tr>
				                <td colspan="5" class="p-4 text-center text-gray-400">
				                    No songs found. Add your first song!
				                </td>
				            </tr>
				        <% } else { 
				            for (Song song : artistSongs) { %>
				            <tr class="border-b border-gray-700 hover:bg-gray-700">
				                <td class="p-4">
				                    <div class="flex items-center">
				                        <div class="bg-gray-700 h-10 w-10 rounded-md mr-3 flex items-center justify-center">
				                            <i class="fas fa-music text-gray-400"></i>
				                        </div>
				                        <%= song.getSongName() %>
				                    </div>
				                </td>
				                <td class="p-4 text-gray-300">
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
				                <td class="p-4 text-gray-300"><%= song.getLyricist() != null ? song.getLyricist() : "-" %></td>
				                <td class="p-4 text-gray-300"><%= song.getMusicDirector() != null ? song.getMusicDirector() : "-" %></td>
				                <td class="p-4 text-right">
				                    <a href="<%=request.getContextPath()%>/songs/edit?id=<%= song.getSongId() %>" class="text-gray-400 hover:text-white px-2">
				                        <i class="fas fa-edit"></i>
				                    </a>
				                    <a href="<%=request.getContextPath()%>/songs/delete?id=<%= song.getSongId() %>" 
				                       onclick="return confirm('Are you sure you want to delete this song?')" 
				                       class="text-gray-400 hover:text-white px-2">
				                        <i class="fas fa-trash-alt"></i>
				                    </a>
				                </td>
				            </tr>
				        <% } 
				        } %>
				    </tbody>
				</table>

                    </div>
                </div>
                
                <!-- Add Album Form (Simple) -->
                <div id="addAlbum" class="bg-gray-800 rounded-lg p-6 mb-8">
                    <h3 class="text-xl font-bold mb-4">Add New Album</h3>
                    
                    <form action="<%=request.getContextPath()%>/albums/add" method="post" class="space-y-4">
                        <input type="hidden" name="artist" value="<%= artistName %>">
                        
                        <div>
                            <label for="albumName" class="block text-sm font-medium text-gray-400 mb-2">Album Title</label>
                            <input type="text" id="albumName" name="albumName" required
                                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label for="albumGenre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                                <select id="albumGenre" name="genre" required
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
                        </div>
                        
                        <div class="flex justify-end">
                            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-md">
                                Create Album
                            </button>
                        </div>
                    </form>
                </div>
				<!-- Add Song Form (Simple) -->
				<div id="addSong" class="bg-gray-800 rounded-lg p-6 mb-8">
				    <h3 class="text-xl font-bold mb-4">Add New Song</h3>
				    
				    <form action="<%=request.getContextPath()%>/songs/add" method="post" class="space-y-4">
				        <input type="hidden" name="singer" value="<%= artistName %>">
				        
				        <div>
				            <label for="songName" class="block text-sm font-medium text-gray-400 mb-2">Song Title</label>
				            <input type="text" id="songName" name="song_name" required
				                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
				        </div>
				        
				        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
				            <div>
				                <label for="album" class="block text-sm font-medium text-gray-400 mb-2">Album</label>
				                <select id="album" name="album_id" 
				                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
				                    <option value="0">No Album (Single)</option>
				                    <% for (Album album : artistAlbums) { %>
				                        <option value="<%= album.getAlbumId() %>"><%= album.getAlbumName() %></option>
				                    <% } %>
				                </select>
				            </div>
				            
				            <div>
				                <label for="music_director" class="block text-sm font-medium text-gray-400 mb-2">Music Director</label>
				                <input type="text" id="music_director" name="music_director"
				                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
				            </div>
				        </div>
				        
				        <div>
				            <label for="lyricist" class="block text-sm font-medium text-gray-400 mb-2">Lyricist</label>
				            <input type="text" id="lyricist" name="lyricist"
				                   class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
				        </div>
				        
				        <div class="flex justify-end">
				            <button type="submit" class="bg-purple-600 hover:bg-purple-700 text-white px-6 py-2 rounded-md">
				                Add Song
				            </button>
				        </div>
				    </form>
				</div>

                </div>
            </div>
        </div>
    </div>
</body>
</html>
