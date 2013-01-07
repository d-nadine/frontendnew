Radium.InboxSidebarView = Em.CollectionView.extend
  contentBinding: 'controller'
  tagName: 'ul'
  classNames: 'messages nav nav-tabs nav-stacked'
  itemViewClass: Radium.SidebarMailItemView
  emptyView: Ember.View.extend
    templateName: 'radium/inbox/empty_sidebar'
  didInsertElement: ->
    scrollbar = $("""
              <div class="scrollcontainer">
                <div id="scroller" class="scrollbar">
                  <div class="track">
                    <div class="thumb">
                      <div class="end"></div>
                    </div>
                  </div>
                </div>
              </div> """)

    $('.viewport').before(scrollbar)

    scroller = $('#sidebar').tinyscrollbar()
    @set('scroller', scroller )

    $(window).on('resize', =>
      @get('scroller').tinyscrollbar_update()) if @get('scroller')

    $('.thumb').on('contentScrolled', (event, direction, distance) ->
      arrow = $('div.arrow')
      arrow.hide()
      active = $('ul.messages li.active')
      return if active.length == 0

      setTimeout(( ->
        arrow.show()
        arrow.css(top: active.offset().top - 35))
        , 200)
    )

  willDestroyElement: ->
    $(window).off('resize')
    $('.thumb').off('contentScrolled')
    @get('scroller').unbindAll() if @get('scroller')
    scrollContainer = $('.scrollcontainer')
    scrollContainer.find("*").andSelf().unbind()
    scrollContainer.remove()
