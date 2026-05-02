// Preloader
var loader = document.getElementById("preloader");

window.addEventListener("load", function () {
  loader.style.display = "none";
});

// Settings & Light/Dark Mode Toggle
function settingtoggle() {
  document.getElementById("setting-container").classList.toggle("settingactivate");
  document.getElementById("visualmodetogglebuttoncontainer").classList.toggle("visualmodeshow");
}

function visualmode() {
  document.body.classList.toggle("light-mode");
  document.querySelectorAll(".needtobeinvert").forEach(function (e) {
    e.classList.toggle("invertapplied");
  });
}

// Mobile Menu Toggle
let emptyArea = document.getElementById("emptyarea");
let mobileTogglemenu = document.getElementById("mobiletogglemenu");

function hamburgerMenu() {
  document.body.classList.toggle("stopscrolling");
  document.getElementById("mobiletogglemenu").classList.toggle("show-toggle-menu");
  document.getElementById("burger-bar1").classList.toggle("hamburger-animation1");
  document.getElementById("burger-bar2").classList.toggle("hamburger-animation2");
  document.getElementById("burger-bar3").classList.toggle("hamburger-animation3");
}

function hidemenubyli() {
  document.body.classList.toggle("stopscrolling");
  document.getElementById("mobiletogglemenu").classList.remove("show-toggle-menu");
  document.getElementById("burger-bar1").classList.remove("hamburger-animation1");
  document.getElementById("burger-bar2").classList.remove("hamburger-animation2");
  document.getElementById("burger-bar3").classList.remove("hamburger-animation3");
}

// Scroll Spy (Highlights the navigation bar based on scroll position)
const sections = document.querySelectorAll("section");
const navLi = document.querySelectorAll(".navbar .navbar-tabs .navbar-tabs-ul li");
const mobilenavLi = document.querySelectorAll(".mobiletogglemenu .mobile-navbar-tabs-ul li");

window.addEventListener("scroll", () => {
  let e = "";
  sections.forEach((t) => {
    let o = t.offsetTop;
    t.clientHeight;
    if (pageYOffset >= o - 200) {
      e = t.getAttribute("id");
    }
  });
  mobilenavLi.forEach((t) => {
    t.classList.remove("activeThismobiletab");
    if (t.classList.contains(e)) {
      t.classList.add("activeThismobiletab");
    }
  });
  navLi.forEach((t) => {
    t.classList.remove("activeThistab");
    if (t.classList.contains(e)) {
      t.classList.add("activeThistab");
    }
  });
});

// Developer Console Signature
console.log(
  "%c Designed and Developed by Abdulrahman Almohaimeed ",
  "background-image: linear-gradient(90deg,#0078d4,#00b4d8); color: white;font-weight:900;font-size:1rem; padding:20px;"
);

// Back to Top Button Logic
let mybutton = document.getElementById("backtotopbutton");

function scrollFunction() {
  if (document.body.scrollTop > 400 || document.documentElement.scrollTop > 400) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
}

function scrolltoTopfunction() {
  document.body.scrollTop = 0;
  document.documentElement.scrollTop = 0;
}

window.onscroll = function () {
  scrollFunction();
};

// Prevent Right-Clicking on Images
document.addEventListener(
  "contextmenu",
  function (e) {
    if ("IMG" === e.target.nodeName) {
      e.preventDefault();
    }
  },
  false
);