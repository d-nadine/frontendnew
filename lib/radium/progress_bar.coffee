Radium.ProgressBar = Ember.View.extend
  classNameBindings: [':progress', ':progress-info',':active']

  style: ( ->
    "width: #{@get('percentage')}%"
  ).property('percentage')

  template: Ember.Handlebars.compile """
    <div class="bar" {{bindAttr style="view.style"}}></div>
  """
