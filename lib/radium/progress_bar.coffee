Radium.ProgressBar = Ember.View.extend
  classNameBindings: [':progress', ':progress-info']
  percentage: (->
    total = @get('total')
    length = @get('length')

    return 0 if total == 0 || length == 0


    percent = Math.floor((length / total) * 100)

    percent
  ).property('total', 'length')

  bar: Ember.View.extend
    classNameBindings: [':bar']
    # FIXME: need a style helper for more styles than width
    attributeBindings: ['style']
    style: ( ->
      "width: #{@get('parentView.percentage')}%"
    ).property('parentView.percentage')


  template: Ember.Handlebars.compile """
      {{!#if hasPercentage}}
        {{view view.bar}}
      {{!/if}}

    """

  hasPercentage: ( ->
    @get('percentage') > 0
  ).property('percentage')
