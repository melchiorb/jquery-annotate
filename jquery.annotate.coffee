###
 *
 * jQuery annotate Plugin v0.1.0
 * https://github.com/melchior-b/jquery-annotate
 *
 * @author Melchior Brislinger
 * @license MIT
 *
###

setup = ($, window) ->
  # generate html for marker object
  markerHtml = (d, tag='div') ->
    $("<#{tag}>").addClass('marker').text(d.label)

  # generate html for popup
  popupHtml = (d, tag='div') ->
    $("<#{tag}>").addClass('popup').text(d.text)

  # extract info from marker element
  markerInfo = (i, element) ->
    [x, y]  = $(element).data('pos').split(/\D/)
    { x, y, text: $(element).text(), label: $(element).attr('title') }

  # calculate marker position
  markerPosition = (element, d) ->
    left: parseInt (d.x / 100) * element.width()
    top:  parseInt (d.y / 100) * element.height()

  # create annotations
  annotate = (input) ->
    # get marker markers
    if $.isArray(input)
      markers = input
    else
      markers = []
      @next(input ? '.annotations').children().each (i, element) ->
        markers.push markerInfo(i, element)

    # on image load
    @on 'load', =>
      # create markers
      $.each markers, (i, d) =>
        css     = markerPosition(@, d)
        marker  = markerHtml(d).css(css).attr(id: "marker-#{i}")
        popup   = popupHtml(d).hide()
        marker.append(popup).appendTo(@parent())

    # show/hide popup on hover
    @parent().on 'mouseover', '.marker', -> $(@).find('.popup').show()
    @parent().on 'mouseout', '.marker', -> $(@).find('.popup').hide()

    # recalculate positions on window resize
    $(window).on 'resize', =>
      $.each markers, (i, d) => $("#marker-#{i}").css markerPosition(@, d)

  $.extend $.fn, { annotate }

setup jQuery, window
