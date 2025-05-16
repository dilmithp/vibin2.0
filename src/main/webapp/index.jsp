<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vibin - Online Music Store</title>
    <link rel="stylesheet" href="index1.css">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins" rel="stylesheet">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/index1.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }
    </style>
</head>

<body>
    <header class="bg-gray-800 shadow-md">
        <div class="container mx-auto px-6 py-3">
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <div class="logo"><img src="images/VIBIN.svg" alt="vibin" width="50%"></div>
                </div>
                <div class="flex items-center">
                    <div class="relative mr-4">
                        <input type="text" placeholder="Search..."
                            class="bg-gray-700 rounded-full px-4 py-1 text-sm focus:outline-none focus:ring-1 focus:ring-purple-500">
                        <button class="absolute right-0 top-0 h-full px-3 text-gray-400 hover:text-white">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                    <a href="<%=request.getContextPath()%>/auth/login.jsp"
                        class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-md mr-2">
                        Login
                    </a>
                    <a href="<%=request.getContextPath()%>/auth/register.jsp"
                        class="bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded-md">
                        Sign Up
                    </a>
                </div>
            </div>
        </div>
    </header>
    <main>
        <section class="hero">
            <img src="images/marcela-laskoski-YrtFlrLo2DQ-unsplash.jpg" alt="Hero Image">
            <div class="hero-text">
                <h1>Music, sports, news, talk, and podcasts</h1>
                <p>The best in audio entertainment wherever you choose to listen—in your car, on your phone, at home on
                    your TV, speakers, and other smart devices.</p>
                
            </div>
        </section>

        <section class="trending-songs">
            <h2>Trending Songs</h2>
            <div class="carousel-container">
                <div class="song-cards">
                    <!-- Original song cards -->
                    <div class="song-card">
                        <img src="images/hathpethi.jpg" alt="Hathpethi Mal">
                        <h3>Hathpethi Mal</h3>
                        <p>Iman Fernando, DILU Beats</p>
                    </div>
                    <div class="song-card">
                        <img src="images/nana.jpg" alt="Naana Vile Voice of the Island">
                        <h3>Naana Vile Voice of the Island</h3>
                        <p>Pasan Liyanage, Rihan Fernando, Lucky Lakmina...</p>
                    </div>
                    <div class="song-card">
                        <img src="images/raveen.jpg" alt="Himi Nathi Adareka">
                        <h3>Himi Nathi Adareka</h3>
                        <p>Raveen Tharuka</p>
                    </div>
                    <div class="song-card">
                        <img src="images/priyawee.jpg" alt="Priyawee">
                        <h3>Priyawee</h3>
                        <p>Piyath Rajapaksha</p>
                    </div>
                    <div class="song-card">
                        <img src="images/thala.jpg" alt="Pathu Thala">
                        <h3>Pathu Thala</h3>
                        <p>A.R. Rahman, Sid Sriram</p>
                    </div>
                    <div class="song-card">
                        <img src="images/hama.jpg" alt="Hāma Heenema">
                        <h3>Hāma Heenema</h3>
                        <p>Induja</p>
                    </div>
                    <!-- Duplicated song cards for seamless loop -->
                    <div class="song-card">
                        <img src="images/hathpethi.jpg" alt="Hathpethi Mal">
                        <h3>Hathpethi Mal</h3>
                        <p>Iman Fernando, DILU Beats</p>
                    </div>
                    <div class="song-card">
                        <img src="images/nana.jpg" alt="Naana Vile Voice of the Island">
                        <h3>Naana Vile </h3>
                        <p>Pasan Liyanage, Rihan Fernando, Lucky Lakmina...</p>
                    </div>
                    <div class="song-card">
                        <img src="images/raveen.jpg" alt="Himi Nathi Adareka">
                        <h3>Himi Nathi Adareka</h3>
                        <p>Raveen Tharuka</p>
                    </div>
                    <div class="song-card">
                        <img src="images/priyawee.jpg" alt="Priyawee">
                        <h3>Priyawee</h3>
                        <p>Piyath Rajapaksha</p>
                    </div>
                    <div class="song-card">
                        <img src="images/thala.jpg" alt="Pathu Thala">
                        <h3>Pathu Thala</h3>
                        <p>A.R. Rahman, Sid Sriram</p>
                    </div>
                    <div class="song-card">
                        <img src="images/hama.jpg" alt="Hāma Heenema">
                        <h3>Hāma Heenema</h3>
                        <p>Induja</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="artists">
            <h2>Popular Artists</h2>
            <div class="artist-cards">
                <div class="artist-card">
                    <img src="images/dilu.jpg" alt="DILU Beats">
                    <h3>DILU Beats</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/dhy.jpg" alt="Dhyan Hewage">
                    <h3>Dhyan Hewage</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/wasthi.jpg" alt="Wasthi">
                    <h3>Anirudh </h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/mihiran.jpg" alt="Mihiran">
                    <h3>Mihiran</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/dinesh.jpg" alt="Dinesh Gamage">
                    <h3>A.R. Rahman</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/iraj.jpg" alt="Iraj">
                    <h3>Dhyan Hewage</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/lahiru.jpg" alt="la signore">
                    <h3>Dhyan Hewage</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/piyath.jpg" alt="Piyath Rajapaksha">
                    <h3>Dhyan Hewage</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/yasas.jpg" alt="Yasas Madagedara">
                    <h3>Dhyan Hewage</h3>
                    <p>Artist</p>
                </div>
                <div class="artist-card">
                    <img src="images/cen.jpg" alt="Centigradz">
                    <h3>Dhyan Hewage</h3>
                    <p>Artist</p>
                </div>
            </div>
        </section>

        <section class="events">
            <h2>Upcoming Events</h2>
            <div class="event-cards">
                <div class="event-card">
                    <img src="https://www.ticketsministry.com/_next/image?url=https%3A%2F%2Fticketsministry.s3.ap-south-1.amazonaws.com%2Fpublic%2Fevents%2F5YVqjsOSHOLUFvS6fUIoe5Y1x4fIh2IX0GFeCdCn.jpg&w=1920&q=75"
                        alt="Event 1">
                    <h3>PRAUDHA – THE GREATEST OF ALL TIME</h3>
                    <p>10 May 2025, 7:00 PM</p>
                    <p>Musaeus College Auditorium</p>
                    <p>Indoor Musical Concert</p>
                </div>
                <div class="event-card">
                    <img src="https://www.ticketsministry.com/_next/image?url=https%3A%2F%2Fticketsministry.s3.ap-south-1.amazonaws.com%2Fpublic%2Fevents%2F202505040011-echoes-of-the-shore-thumbnail.jpg&w=1920&q=75"
                        alt="Event 2">
                    <h3>CAMELLIA</h3>
                    <p>23 May 2025, 7:00 PM</p>
                    <p>Viharamadevi Open Air Theatre – Colombo</p>
                    <p>Outdoor Musical Concert</p>
                </div>
                <div class="event-card">
                    <img src="https://www.ticketsministry.com/_next/image?url=https%3A%2F%2Fticketsministry.s3.ap-south-1.amazonaws.com%2Fpublic%2Fevents%2FQ4VLG6BIpgHoUpKA4pWeHlbQbqif8shebk4fL6mG.jpg&w=1920&q=75"
                        alt="Event 3">
                    <h3>AN EVENING WITH THE MASTERS</h3>
                    <p>7 May 2025, 7:30 PM</p>
                    <p>The Lionel Wendt</p>
                    <p>Indoor Musical Concert</p>
                </div>
                <div class="event-card">
                    <img src="https://www.ticketsministry.com/_next/image?url=https%3A%2F%2Fticketsministry.s3.ap-south-1.amazonaws.com%2Fpublic%2Fevents%2F202503241701-kolamba-sanniya-02---devani-arudaya-thumbnail.jpg&w=1920&q=75"
                        alt="Event 4">
                    <h3>KOLAMBA SANNIYA 02 DEVANI ARUDAYA</h3>
                    <p>9 May 2025, 7:30 PM</p>
                    <p>Lotus Tower Colombo</p>
                    <p>Outdoor Musical Concert</p>
                </div>
            </div>
        </section>

        <section class="contact-us">
            <h2>Contact Us</h2>
            <div class="contact-details">
                <p><strong>Email:</strong> contact@vibin.com</p>
                <p><strong>Phone:</strong> 0777123379</p>
                <div class="social-media">
                    <a href="https://www.instagram.com/vibin" target="_blank" class="social-link">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png"
                            alt="Instagram" class="social-icon"> Instagram
                    </a>
                    <a href="https://www.facebook.com/vibin" target="_blank" class="social-link">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Facebook_f_logo_%282019%29.svg"
                            alt="Facebook" class="social-icon"> Facebook
                    </a>
                    <a href="https://twitter.com/vibin" target="_blank" class="social-link">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/6/6f/Logo_of_Twitter.svg" alt="Twitter"
                            class="social-icon"> Twitter
                    </a>
                    <a href="https://telegram.me/vibin" target="_blank" class="social-link">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/8/82/Telegram_logo.svg" alt="Telegram"
                            class="social-icon"> Telegram
                    </a>
                    <a href="https://wa.me/1234567890" target="_blank" class="social-link">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg" alt="WhatsApp"
                            class="social-icon"> WhatsApp
                    </a>
                </div>
            </div>
        </section>



    </main>
    <footer>
        <p>&copy; 2025 Vibin. All rights reserved.</p>
    </footer>
</body>

</html>