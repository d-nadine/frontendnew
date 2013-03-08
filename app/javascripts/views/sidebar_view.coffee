Radium.SidebarView = Ember.View.extend
  classNames: ['sidebar-panel']
  layout: Ember.Handlebars.compile """
    <div class="panel-content">
      {{yield}}
    </div>
  """
