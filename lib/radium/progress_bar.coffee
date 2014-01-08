Radium.ProgressBar = Ember.View.extend
  classNameBindings: [':progress', ':progress-success',':active', 'percentage:has-percentage']

  style: ( ->
    "width: #{@get('percentage')}%"
  ).property('percentage')

  template: Ember.Handlebars.compile """
    <div class="bar" {{bind-attr style="view.style"}}></div>
  """
