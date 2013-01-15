require 'radium/views/inbox/sidebar_mail_item_view'

Radium.InboxSidebarView = Em.CollectionView.extend
  contentBinding: 'controller'
  tagName: 'ul'
  classNames: 'messages selectable'
  itemViewClass: Radium.SidebarMailItemView
  emptyView: Ember.View.extend
    templateName: 'radium/inbox/empty_sidebar'

  # didInsertElement: ->
  #   scrollbar = $("""
  #             <div class="scrollcontainer">
  #               <div id="scroller" class="scrollbar">
  #                 <div class="track">
  #                   <div class="thumb">
  #                     <div class="end"></div>
  #                   </div>
  #                 </div>
  #               </div>
  #             </div> """)

  #   $('.viewport').before(scrollbar)

  #   scroller = $('#scrollarea').tinyscrollbar()
  #   @set('scroller', scroller )

  #   active = $('ul.messages li.active')

  #   $(window).on('resize', =>
  #     @get('scroller').tinyscrollbar_update()) if @get('scroller')

  # willDestroyElement: ->
  #   $(window).off('resize')
  #   $('.thumb').off('contentScrolled')
  #   @get('scroller').unbindAll() if @get('scroller')
  #   scrollContainer = $('.scrollcontainer')
  #   scrollContainer.find("*").andSelf().unbind()
  #   scrollContainer.remove()
