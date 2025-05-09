package com.vibin.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Utility class for logging in the Vibin online music store application.
 */
public class LoggerUtil {

    /**
     * Private constructor to prevent instantiation
     */
    private LoggerUtil() {
        // Utility class, no instantiation needed
    }
    
    /**
     * Gets a logger for the specified class
     * 
     * @param clazz The class to get a logger for
     * @return Logger instance for the class
     */
    public static Logger getLogger(Class<?> clazz) {
        return LoggerFactory.getLogger(clazz);
    }
    
    /**
     * Logs debug information
     * 
     * @param logger The logger to use
     * @param message The message to log
     */
    public static void debug(Logger logger, String message) {
        if (logger.isDebugEnabled()) {
            logger.debug(message);
        }
    }
    
    /**
     * Logs debug information with exception details
     * 
     * @param logger The logger to use
     * @param message The message to log
     * @param exception The exception to log
     */
    public static void debug(Logger logger, String message, Throwable exception) {
        if (logger.isDebugEnabled()) {
            logger.debug(message, exception);
        }
    }
    
    /**
     * Logs info information
     * 
     * @param logger The logger to use
     * @param message The message to log
     */
    public static void info(Logger logger, String message) {
        if (logger.isInfoEnabled()) {
            logger.info(message);
        }
    }
    
    /**
     * Logs warning information
     * 
     * @param logger The logger to use
     * @param message The message to log
     */
    public static void warn(Logger logger, String message) {
        if (logger.isWarnEnabled()) {
            logger.warn(message);
        }
    }
    
    /**
     * Logs warning information with exception details
     * 
     * @param logger The logger to use
     * @param message The message to log
     * @param exception The exception to log
     */
    public static void warn(Logger logger, String message, Throwable exception) {
        if (logger.isWarnEnabled()) {
            logger.warn(message, exception);
        }
    }
    
    /**
     * Logs error information
     * 
     * @param logger The logger to use
     * @param message The message to log
     */
    public static void error(Logger logger, String message) {
        if (logger.isErrorEnabled()) {
            logger.error(message);
        }
    }
    
    /**
     * Logs error information with exception details
     * 
     * @param logger The logger to use
     * @param message The message to log
     * @param exception The exception to log
     */
    public static void error(Logger logger, String message, Throwable exception) {
        if (logger.isErrorEnabled()) {
            logger.error(message, exception);
        }
    }
}
