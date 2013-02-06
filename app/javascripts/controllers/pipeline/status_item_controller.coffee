Radium.StatusItemController = Em.ArrayController.extend
  needs: ['pipeline']

  total: Ember.computed.alias('controllers.pipeline.negotiatingTotal')
  status: Ember.computed.alias('controllers.pipeline.currentStatus')

  expand: ->
    @toggleProperty 'isExpanded'

  statusDidChange: (->
    status = @get 'status'
    return unless status

    @set('isExpanded', @get('status') == status)
  ).observes('controllers.pipeline.currentStatus')

  percentage: (->
    total = @get 'total'
    length = @get 'length'

    return 0 unless total || total == 0 || length == 0

    Math.floor((length / total) * 100)
  ).property('total', 'content.length')

  total: (->
    return 0 if @get('length') == 0

    sum = @reduce (preVal, item) ->
      value = if preVal.get
                value = preVal.get('value')
              else
                preVal

      value + (item.get('value') || 0)

    sum
  ).property('length')

  title: ( ->
    "#{@get('status')} - (#{@get('length')})"
  ).property('status', 'deals.length')
