#!/bin/bash
set -e

echo "🧪 Testing Apache Web Server..."

# Wait for server to be ready
echo "⏳ Waiting for server to start..."
sleep 5

# Test 1: Check if server is responding
echo "🔍 Test 1: Server responds to HTTP requests"
if curl -f http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ PASS: Server is responding"
else
    echo "❌ FAIL: Server is not responding"
    exit 1
fi

# Test 2: Check health endpoint
echo "🔍 Test 2: Health check endpoint"
if curl -f http://localhost:8080/health > /dev/null 2>&1; then
    echo "✅ PASS: Health check endpoint working"
else
    echo "❌ FAIL: Health check endpoint not working"
    exit 1
fi

# Test 3: Check if HTML content is served
echo "🔍 Test 3: HTML content is served correctly"
if curl -s http://localhost:8080 | grep -q "Modern Apache Web Server"; then
    echo "✅ PASS: HTML content is being served"
else
    echo "❌ FAIL: HTML content not found"
    exit 1
fi

# Test 4: Check security headers
echo "🔍 Test 4: Security headers are present"
if curl -I http://localhost:8080 2>/dev/null | grep -q "X-Frame-Options"; then
    echo "✅ PASS: Security headers are present"
else
    echo "❌ FAIL: Security headers missing"
    exit 1
fi

# Test 5: Check server status page
echo "🔍 Test 5: Server status page is accessible"
if curl -f http://localhost:8080/server-status > /dev/null 2>&1; then
    echo "✅ PASS: Server status page accessible"
else
    echo "❌ FAIL: Server status page not accessible"
    exit 1
fi

echo ""
echo "🎉 All tests passed! Apache server is working correctly."