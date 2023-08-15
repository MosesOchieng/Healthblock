document.getElementById("startLoading").addEventListener("click", function() {
    // Show the loader container
    document.getElementById("loaderContainer").style.display = "block";

    // Set a timeout to redirect after a certain duration (e.g., 5 seconds)
    setTimeout(function() {
        // Redirect to the desired page
        window.location.href = 'your-redirect-page.html';
    }, 5000); // 5000 milliseconds = 5 seconds
});
