Radium.ReportIconsComponent = Ember.Component.extend
  icon: "user"
  totalDidChange: (-> @rerender()).observes('total')
  render: (buffer) ->
    total = @get 'total'
    icon = @get 'icon'
    fontFamily = @get 'fontFamily'

    until total is 0
      buffer.push "<i class=\"#{fontFamily} #{icon}\"></i>"
      total--
