Radium.GapView = Em.View.extend
  templateName: 'gap'
  classNames: ['gap']
  loadLimit: 3

  sectionBinding: 'parentView.content'

  # I don't want to make everything go through adapter, but
  # it seems that there are no good examples for loading data
  # that's not actually a model. That's why I make "findQuery"
  # to make request to /gaps?first=2012-01-01&last=2012-02-02,
  # the only problem is that it returns an array, not single item
  content: (->
    @get('gaps.firstObject')
  ).property('gaps', 'gaps.length')

  gaps: (->
    section = @get('section.id')
    next    = @get('nextSection.id')

    if section && next
      Radium.Gap.find
        first: section
        last:  next
  ).property('section', 'nextSection')

  nextSection: (->
    sections = @get('parentView.parentView.content')
    current  = sections.indexOf @get('section')
    sections.objectAt(current - 1)
  ).property()

  click: ->
    section = @get('section')
    limit   = @get('loadLimit')

    @get('controller').loadAfterSection section, limit
