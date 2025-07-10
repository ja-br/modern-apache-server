#!/bin/bash
set -e

echo "🚀 Starting Apache Development Server..."

# Build the Docker image
docker build -t modern-apache-server .

# Stop any existing container
docker stop apache-dev 2>/dev/null || true
docker rm apache-dev 2>/dev/null || true

# Run the container
docker run -d \
    --name apache-dev \
    -p 8080:80 \
    -v "$(pwd)/web-content:/usr/local/apache2/htdocs" \
    modern-apache-server

echo "✅ Server started!"
echo "🌐 Open http://localhost:8080 in your browser"
echo "📊 Server status: http://localhost:8080/server-status"
echo "❤️  Health check: http://localhost:8080/health"
echo ""
echo "💡 To view logs: docker logs -f apache-dev"
echo "🛑 To stop: docker stop apache-dev"