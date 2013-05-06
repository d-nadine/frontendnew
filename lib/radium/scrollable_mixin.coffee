Radium.ScrollableMixin = Em.Mixin.create
  didInsertElement: ->
    @shouldScroll()

    @$(window).on 'resize', @get('windowDidResize')

  shouldScroll: ->
    if @get 'scroller'
      @get('scroller').tinyscrollbar_update('relative')
    else
      scroller = @$('.scroller').tinyscrollbar()
      @set 'scroller', scroller

  removeScrolling: ->
    @get('scroller').unbindAll() if @get('scroller')
    @$('scroller .scrollbar').hide()
    @$('.scrollcontainer').find("*").andSelf().unbind()
    @set('scroller', null)

  willDestroyElement: ->
    @removeScrolling()
    @$(window).off 'resize', @get('windowDidResize')

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
