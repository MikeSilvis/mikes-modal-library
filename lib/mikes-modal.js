var addListeners, addLoading, disableScrolling, enableScrolling, mikesModal, scrollPosition, theLights;

jQuery.fn.mikesModal = function(action) {
  if (action === "remove") {
    theLights($(this), "remove");
    mikesModal($(this), "remove");
    $("#loading-modal").remove();
    enableScrolling();
  } else if (action === "hide") {
    theLights($(this), "remove");
    mikesModal($(this), "hide");
    $("#loading-modal").hide();
    enableScrolling();
  } else {
    addLoading();
    disableScrolling();
    theLights($(this));
    mikesModal($(this));
  }
  return $(this);
};

theLights = function(modalBox, action) {
  if (action === "remove") {
    return $("#the-lights").remove();
  } else {
    $("body").append("<div id='the-lights'></div>");
    return $("#the-lights").css({
      "height": $(document).height()
    });
  }
};

mikesModal = function(modalBox, action) {
  if (action === "hide") {
    return modalBox.hide();
  } else if (action === "remove") {
    modalBox.remove();
    return $(document).trigger('modal-removed', modalBox);
  } else {
    addListeners(modalBox);
    modalBox.find("img").css({
      "max-width": (window.innerWidth * .9) - 300,
      "max-height": window.innerHeight * .8
    });
    modalBox.css({
      "margin-left": "-" + (modalBox.width() / 2),
      "margin-top": "-" + (modalBox.height() / 2)
    }).fadeIn("slow");
    $("#loading-modal").remove();
    $(document).trigger('modal-created', modalBox);
  }
};

addLoading = function() {
  var opts, spinner;
  opts = {
    lines: 9,
    length: 30,
    width: 20,
    radius: 40,
    corners: 1,
    rotate: 19,
    color: "#fff",
    speed: 1.2,
    trail: 42,
    shadow: false,
    hwaccel: false,
    className: "spinner",
    zIndex: 2e9,
    top: "auto",
    left: "auto"
  };
  $("body").append("<div id='loading-modal'></div>");
  $("#loading-modal").css({
    "top": $(window).scrollTop() + 300 + "px"
  });
  return spinner = new Spinner(opts).spin(document.getElementById("loading-modal"));
};

addListeners = function(modalBox) {
  $(document).keyup(function(e) {
    if (e.keyCode === 27) {
      return $(".close").click();
    }
  });
  $(document).click(function(e) {
    if (e.target.id === "the-lights") {
      return $(".close").click();
    }
  });
  return modalBox.find(".close").click(function(e) {
    return modalBox.mikesModal("hide");
  });
};

scrollPosition = function() {
  return [self.pageXOffset || document.documentElement.scrollLeft || document.body.scrollLeft, self.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop];
};

disableScrolling = function() {
  var html;
  html = jQuery("html");
  html.data("scroll-position", scrollPosition);
  html.data("previous-overflow", html.css("overflow"));
  html.css("overflow", "hidden");
  return window.scrollTo(scrollPosition()[0], scrollPosition()[1]);
};

enableScrolling = function() {
  var html;
  html = jQuery("html");
  scrollPosition = html.data("scroll-position");
  html.css("overflow", html.data("previous-overflow"));
  return window.scrollTo(scrollPosition()[0], scrollPosition()[1]);
};
