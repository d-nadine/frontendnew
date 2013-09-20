Radium.ScrollableMixin = Em.Mixin.create
  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', this, ->
      @setScroller()

    Ember.$(window).on('stickyChange', @setSidebarHeight.bind this)
    Ember.$(window).on 'resize', @setScroller.bind this

  setSidebarHeight: ->
    console.log('hi!!!')
    # Use the .sidebar for the height, since notifications is laid out differently
    return unless  @get('state') is 'inDOM'

    height = Em.$('.sidebar').outerHeight(true)

    Ember.run.next =>
      $(".viewport").css('height': height + 'px')
      @$('.scroller').tinyscrollbar_update('relative')

  setScroller: ->
    if @get('state') == 'destroying'
      return

    if @get 'scroller'
      @setSidebarHeight()
    else
      scroller = @$('.scroller').tinyscrollbar()
      @setSidebarHeight()
      @set 'scroller', scroller

  removeScrolling: ->
    @get('scroller').unbindAll() if @get('scroller')
    @$('scroller .scrollbar').hide()
    @$('.scrollcontainer').find("*").andSelf().unbind()
    @set('scroller', null)

  willDestroyElement: ->
    @removeScrolling()

  layout: Ember.Handlebars.compile """
    <div class="scroller">
      <div class="scrollbar">
        <div class="track">
          <div class="thumb">
            <div class="end"></div>
          </div>
        </div>
      </div>
      <div class="viewport">
        <div class="overview">
          <div class="panel-content">
            {{yield}}
          </div>
        </div>
      </div>
    </div>
  """
