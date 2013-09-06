Radium.ProgressBar = Ember.View.extend
  classNameBindings: [':progress', ':progress-success',':active', 'percentage:has-percentage']

  style: ( ->
    "width: #{@get('percentage')}%"
  ).property('percentage')

  template: Ember.Handlebars.compile """
    <div class="bar" {{bindAttr style="view.style"}}></div>
  """
