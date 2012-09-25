jQuery.fn.mikesModal = (action) ->
  if action == "remove"
    theLights($(this), "hide")
    mikesModal($(this), "remove")
  else if action == "hide"
    theLights($(this), "hide")
    mikesModal($(this), "hide")
  else
    addLoading()
    theLights($(this))
    mikesModal($(this))

  $(this)


theLights = (modalBox, action) ->
  if action == "hide"
    $("#the-lights").remove()
  else
    $("body").append("<div id='the-lights'></div>").css("height": $(document).height())

mikesModal = (modalBox, action) ->
  if action == "hide"
    modalBox.hide()
  else if action == "remove"
    modalBox.remove()
  else
    addListeners(modalBox)
    modalBox.css("top":($(window).scrollTop() + 50 + "px"))
    modalBox.find("img").load ->
      marginLeft = ($(window).width() - modalBox.width()) / 2
      modalBox.css("margin-left":(marginLeft + "px")).fadeIn("slow")
      $("#loading-modal").remove()

addLoading = () ->
  opts =
    lines: 9 # The number of lines to draw
    length: 30 # The length of each line
    width: 20 # The line thickness
    radius: 40 # The radius of the inner circle
    corners: 1 # Corner roundness (0..1)
    rotate: 19 # The rotation offset
    color: "#fff" # #rgb or #rrggbb
    speed: 1.2 # Rounds per second
    trail: 42 # Afterglow percentage
    shadow: false # Whether to render a shadow
    hwaccel: false # Whether to use hardware acceleration
    className: "spinner" # The CSS class to assign to the spinner
    zIndex: 2e9 # The z-index (defaults to 2000000000)
    top: "auto" # Top position relative to parent in px
    left: "auto" # Left position relative to parent in px

  $("body").append("<div id='loading-modal'></div>").css("top":($(window).scrollTop() + 300 + "px"))
  spinner = new Spinner(opts).spin(document.getElementById("loading-modal"))

addListeners = (modalBox) ->
  $(document).keyup (e) ->
    modalBox.find(".close").click() if e.keyCode is 27
  $(document).click (e) ->
    modalBox.find(".close").click() if e.target.id is "the-lights"
  modalBox.find(".close").click (e) ->
    modalBox.mikesModal("remove")
