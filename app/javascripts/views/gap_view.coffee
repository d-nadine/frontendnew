Radium.GapView = Em.View.extend
  templateName: 'gap'
  classNames: ['gap']
  loadLimit: 3

  sectionBinding: 'parentView.content'

  click: ->
    section = @get('section')
    limit   = @get('loadLimit')

    @get('controller').loadAfterSection section, limit
