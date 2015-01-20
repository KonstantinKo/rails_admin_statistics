buildGraphs = ->

  graphWrapper = $('.graph-wrapper')
  graphWrapper.each (index, wrapper) ->
    $wrapper = $(wrapper)
    rawData = $wrapper.data('stats');
    graphData = []
    seriesInfo = {}
    colors = [
      '#71C73E', '#77B7C5', '#D4D137', '#B474CE', '#7A3A20', '#6979FF',
      '#FC4FFF', '#CC582B', '#FFA24F', '#871C1F'
    ]

    for key, value of rawData
      seriesInfo[graphData.length] = key

      series =
        data: value
        color: colors[graphData.length]

      graphData.push series

    # Line Chart
    lines = $wrapper.find('.graph-lines')
    plot = $.plot lines, graphData,
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
      xaxis:
        mode: "time"
        timeformat: "%b %Y"

    linesBtn = $wrapper.find('.lines')

    previousPoint = null

    $wrapper.find('.graph-lines').bind 'plothover', (event, pos, item) ->
      if item
        if previousPoint isnt item.dataIndex
          previousPoint = item.dataIndex
          $('#tooltip').remove()
          x = item.datapoint[0]
          y = item.datapoint[1]
          week = new Date(x).getWeek()
          showTooltip(item.pageX, item.pageY, "#{y} #{seriesInfo[item.seriesIndex]} in calendar week #{week}")
      else
        $('#tooltip').remove()
        previousPoint = null

    # Visibility toggle on legend click
    $wrapper.find('.legend.btn').on 'click', (e) ->
      $(this).toggleClass 'active'
      idx = $(this).data('idx')
      dataSet = plot.getData()
      dataSet[idx].lines.show = !dataSet[idx].lines.show
      dataSet[idx].points.show = !dataSet[idx].points.show
      plot.setData(dataSet)
      plot.draw()

showTooltip = (x, y, contents) ->
  $('<div id="tooltip">' + contents + '</div>').css(
    top: y - 16
    left: x + 20
  ).appendTo('body').fadeIn()

$(document).on 'rails_admin.dom_ready', ->
  setTimeout buildGraphs, 10
