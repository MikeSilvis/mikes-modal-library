#= require spin.min.js

$.fn.mikesModal = (action) ->
  @modal = new MikesModal $(this)

class MikesModal
  constructor: (modalBox) ->
    @modalBox = modalBox
    @bindMethods()
    @createAllClasses()
    @modalBox.trigger "open"
    @imageLoaded()
    @addClose()
    @triggerClose()

  createAllClasses: =>
    new Scrolling(@modalBox)
    new Loading(@modalBox)
    new TheLights(@modalBox)

  bindMethods: =>
    @opened()
    @loaded()
    @closed()

  opened: =>
    @modalBox.bind "open", =>
      @modalBox.find("img").css "max-width": @imageMaxWidth(), "max-height": @imageMaxHeight()

  closed: =>
    @modalBox.bind "close", =>
      @modalBox.hide()

  loaded: =>
    @modalBox.bind "loaded", =>
      @modalBox.fadeIn("slow")

  imageLoaded: =>
    @modalBox.find("img").first().load =>
      @imagePosition()
    if @modalBox.find("img")[0].complete
      @imagePosition()

  imagePosition: =>
    @modalBox.trigger("loaded").css "margin-top": @marginTop(), "margin-left": @marginLeft()
    @modalBox.css "margin-top": @marginTop(), "margin-left": @marginLeft() # Nasty hack to deal with image being resized for some reason...
    @modalBox.css "margin-top": @marginTop(), "margin-left": @marginLeft() # Nasty hack to deal with image being resized for some reason...
    @modalBox.find(".description").css "height" : (@modalBox.find("img").height() - 20)

  triggerClose: =>
    $(document).keyup (e) =>
      @modalBox.trigger "close" if e.keyCode is 27
    @modalBox.find(".close").click =>
      @modalBox.trigger "close"

  imageMaxWidth: =>
    (window.innerWidth * .8) - 300

  imageMaxHeight: =>
    window.innerHeight * .8

  marginTop: =>
    if document.width > 700
      "-#{(@modalBox.height() / 2)}px"
    else
      "-#{(@modalBox.height() / 2 - 80)}px"


  marginLeft: =>
    "-#{@modalBox.width() / 2}px"

  addClose: =>
    $(".description").before("<div class='close'>&times;</div>")

class TheLights
  constructor: (modalBox) ->
    @modalBox = modalBox
    @bindLoaded()
    @bindClosed()
    @bindClicks()

  bindLoaded: =>
    @modalBox.bind "loaded", =>
      if $("#the-lights").length
        @theLights = $("#the-lights")
      else
        @theLights = $("<div id='the-lights'></div>")
        @theLights.appendTo("body")

  bindClosed: =>
    @modalBox.bind "close", =>
      @theLights.remove()

  bindClicks: =>
    $('body').on "click touchstart", "#the-lights", (event) =>
      event.preventDefault()
      event.stopPropagation()
      @modalBox.trigger 'close'

class Scrolling
  constructor: (modalBox) ->
    @modalBox = modalBox
    if document.width > 700
      @bindFullLoaded()
      @bindFullClosed()
    @html = $("html")

  bindFullLoaded: =>
    @modalBox.bind "loaded", =>
      @html.css("overflow","hidden")

  bindFullClosed: =>
    @modalBox.bind "close", =>
      @html.css("overflow","auto")

class Loading
  constructor: (modalBox) ->
    @modalBox = modalBox
    @bindOpened()
    @bindLoaded()

  bindOpened: =>
    @modalBox.bind "open", =>
      @loading = $("<div id='loading-modal'></div>")
      @loading.appendTo("body").css top: $(window).scrollTop() + 300 + "px"
      spinner = new Spinner(@opts()).spin(document.getElementById("loading-modal"))

  bindLoaded: =>
    @modalBox.bind "loaded", =>
      @loading.remove()

  opts: =>
    lines: 9
    length: 30
    width: 20
    radius: 40
    corners: 1
    rotate: 19
    color: "#fff"
    speed: 1.2
    trail: 42
    shadow: false
    hwaccel: false
    className: "spinner"
    zIndex: 2e9
    top: "auto"
    left: "auto"
