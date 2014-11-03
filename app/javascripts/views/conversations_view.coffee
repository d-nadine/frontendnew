Radium.ConversationsView = Radium.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'

  isAtBottom: false

  elementSelector: 'table.convo tbody'

  resizeTable: ->
    conversations = @$(@get('elementSelector'))

    height = (window.innerHeight - conversations.offset().top) - 100

    conversations.css 'max-height', height

    headers = @$('table.convo thead th')
    cells = conversations.find('tr:first').children()

    colWidths = cells.each (index, cell) ->
                  width = $(cell).width()
                  $(headers[index]).width(width)

  atContentEnd: ->
    conversations = @$(@get('elementSelector'))

    scrollTop = conversations.scrollTop()
    height = conversations.innerHeight()
    scrollHeight = conversations.get(0).scrollHeight

    current = scrollTop + height + 50

    @set 'isAtBottom', (current >= scrollHeight)

  setup: (->
    $(window).on 'resize.resizeTable', @resizeTable.bind(this)

    @$(@get('elementSelector')).on 'scroll.conversations', @atContentEnd.bind(this)

    @resizeTable()
  ).on 'didInsertElement'

  teardown: (->
    @$(@get('elementSelector')).off 'scroll.conversations'
  ).on 'willDestroyElement'