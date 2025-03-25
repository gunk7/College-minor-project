document.addEventListener("DOMContentLoaded", function() {
    const buttons = document.querySelectorAll(".service button");
    
    buttons.forEach(button => {
        button.addEventListener("click", function() {
            alert("Service booked successfully!");
        });
    });
});
