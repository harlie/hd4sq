$(window).load(function() {
    $('.flexslider1').flexslider({
      animation: 'slide', // Change Animation Type to fade
      animationLoop: true,
      touch: true,
      directionNav: false,
      slideshowSpeed: 5000, // Slide Intervals
      animationSpeed: 600, // Animation Speeds/times
      slideshow: true,
      pauseOnAction: false,
      controlsContainer: '.flex-container'
    });
 
    $('.flexslider2').flexslider({
      animation: 'fade', // Change Animation Type to slide
      smoothHeight: false,
      animationLoop: true,
      touch: true,
      directionNav: false,
      slideshowSpeed: 7000, // Slide Intervals
      animationSpeed: 300, // Animation Speeds/times
      slideshow: true,
      pauseOnAction: false, 
      controlsContainer: '.flex-container'
    });
  });
  
  
  