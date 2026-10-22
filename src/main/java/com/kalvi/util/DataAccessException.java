package com.kalvi.util;

/** Unchecked wrapper for SQL errors so servlets stay clean; handled by error.jsp. */
public class DataAccessException extends RuntimeException {
    private static final long serialVersionUID = 1L;
    public DataAccessException(String message, Throwable cause) { super(message, cause); }
}
