Radium.DraggableMixin = Ember.Mixin.create
  layoutName: 'components/drag-fileuploader'

  dragOver: (e) ->
    @$('.dropbox').addClass('hover')
    false

  dragEnd: (e) ->
    @$('.dropbox').removeClass('hover')
    false

  dragLeave: (e) ->
    @$('.dropbox').removeClass('hover')
    false

  drop: (e) ->
    throw new Error('Override drop in actual component')
