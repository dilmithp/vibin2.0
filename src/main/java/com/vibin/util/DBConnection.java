package com.vibin.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Database connection utility class for the Vibin online music store.
 * Provides methods to establish and manage database connections.
 */
public class DBConnection {
    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);
    
    // Database connection parameters
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:8889/loginjsp";
    private static final String USER = "root";
    private static final String PASSWORD = "root";
    /**
     * Private constructor to prevent instantiation
     */
    private DBConnection() {
        // Utility class, no instantiation needed
    }
    
    /**
     * Registers the JDBC driver
     */
    static {
        try {
            Class.forName(DRIVER);
            logger.info("MySQL JDBC Driver registered successfully");
        } catch (ClassNotFoundException e) {
            logger.error("Failed to register MySQL JDBC driver", e);
            throw new RuntimeException("Failed to register MySQL JDBC driver", e);
        }
    }
    
    /**
     * Gets a database connection
     * 
     * @return Connection object to the database
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
            logger.info("Database connection established successfully");
            return connection;
        } catch (SQLException e) {
            logger.error("Database connection failed: {}", e.getMessage());
            throw e;
        }
    }
    
    /**
     * Closes the database connection safely
     * 
     * @param connection The connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                logger.info("Database connection closed successfully");
            } catch (SQLException e) {
                logger.error("Error closing database connection: {}", e.getMessage());
            }
        }
    }
}
