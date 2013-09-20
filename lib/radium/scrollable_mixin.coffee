Radium.ScrollableMixin = Em.Mixin.create
  didInsertElement: ->
    Ember.run.scheduleOnce 'afterRender', this, ->
      @shouldScroll()

    Ember.$(window).on('stickyChange', @setSidebarHeight.bind this)
    Ember.$(window).on 'resize', @shouldScroll.bind this

  setSidebarHeight: ->
    # Use the .sidebar for the height, since notifications is laid out differently
    return unless  @get('state') is 'inDOM'

    height = Em.$('.sidebar').outerHeight(true)

    Ember.run.next =>
      $(".viewport").css('height': height + 'px')
      @$('.scroller').tinyscrollbar_update('relative')

  shouldScroll: ->
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

  # Do this to ensure that our event handler always
  # executes in the right context. This also gives
  # a variable we can pass to `off` later to remove
  # the specific event handler.
  windowDidResize: (->
    @shouldScroll.bind this
  ).property()

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
