buildGraphs = ->

  graphWrapper = $('.graph-wrapper')
  graphWrapper.each (index, wrapper) ->
    $wrapper = $(wrapper)
    rawData = $wrapper.data('stats');
    graphData = []
    seriesInfo = {}
    colors = ['#71C73E', '#77B7C5', '#D4D137', '#B474CE', '#7A3A20']

    for key, value of rawData
      seriesInfo[graphData.length] = key

      series =
        data: value
        color: colors[graphData.length]

      graphData.push series

    # Line Chart
    lines = $wrapper.find('.graph-lines')
    $.plot lines, graphData,
      series:
        points:
          show: true
          radius: 5
        lines:
          show: true
        shadowSize: 0
      grid:
        color: '#646464'
        borderColor: 'transparent'
        borderWidth: 20
        hoverable: true

    # Bar Chart
    bars = $wrapper.find('.graph-bars')
    $.plot bars, graphData,
      series:
        bars:
          show: true
          barWidth: 0.9
          align: 'center'
        shadowSize: 0
      grid:
        color: '#646464'
        borderColor: 'transparent'
        borderWidth: 20
        hoverable: true

    bars.hide()

    linesBtn = $wrapper.find('.lines')
    barsBtn = $wrapper.find('.bars')

    linesBtn.on 'click', (e) ->
      barsBtn.removeClass 'active'
      bars.fadeOut()
      $(this).addClass 'active'
      lines.fadeIn()
      e.preventDefault()

    barsBtn.on 'click', (e) ->
      linesBtn.removeClass 'active'
      lines.fadeOut()
      $(this).addClass 'active'
      bars.fadeIn().removeClass 'hidden'
      e.preventDefault()



    previousPoint = null

    $wrapper.find('.graph-lines, .graph-bars').bind 'plothover', (event, pos, item) ->
      if item
        if previousPoint isnt item.dataIndex
          previousPoint = item.dataIndex
          $('#tooltip').remove()
          x = item.datapoint[0]
          y = item.datapoint[1]
          showTooltip(item.pageX, item.pageY, "#{y} #{seriesInfo[item.seriesIndex]} in calendar week #{x}")
      else
        $('#tooltip').remove()
        previousPoint = null

showTooltip = (x, y, contents) ->
  $('<div id="tooltip">' + contents + '</div>').css(
    top: y - 16
    left: x + 20
  ).appendTo('body').fadeIn()

$(document).on 'rails_admin.dom_ready', buildGraphs