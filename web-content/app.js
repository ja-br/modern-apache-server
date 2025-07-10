// Update server information dynamically
function updateServerInfo() {
    // Update timestamp
    document.getElementById('last-updated').textContent = 
        new Date().toLocaleString();
    
    // In a real setup, these would come from server-side endpoints
    // For now, we'll simulate with static data
    document.getElementById('environment').textContent = 
        'Development (Docker)';
}

// Check if server is responding
async function checkServerHealth() {
    try {
        // Try to fetch a basic server status
        // Apache server-status module would provide real data
        const response = await fetch('/server-status', {
            method: 'HEAD'
        });
        
        if (response.ok || response.status === 404) {
            document.getElementById('server-health').textContent = '✅ Healthy';
            document.getElementById('server-status').textContent = 'Server Running';
        } else {
            throw new Error('Server not responding');
        }
    } catch (error) {
        document.getElementById('server-health').textContent = '❌ Check Failed';
        document.getElementById('server-status').textContent = 'Status Unknown';
    }
}

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Initialize page
document.addEventListener('DOMContentLoaded', function() {
    updateServerInfo();
    checkServerHealth();
    
    // Update info every 30 seconds
    setInterval(updateServerInfo, 30000);
    setInterval(checkServerHealth, 30000);
});