# Use official Apache image as base
FROM httpd:2.4-alpine

# Install curl for health checks
RUN apk add --no-cache curl

# Copy custom configuration
COPY apache-config/httpd.conf /usr/local/apache2/conf/httpd.conf

# Copy website content
COPY web-content/ /usr/local/apache2/htdocs/

# Ensure proper permissions (use daemon for Alpine Linux)
RUN chown -R daemon:daemon /usr/local/apache2/htdocs/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Expose port 80
EXPOSE 80

# Start Apache in foreground
CMD ["httpd-foreground"]