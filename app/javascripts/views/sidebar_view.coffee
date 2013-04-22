Radium.SidebarView = Radium.View.extend
  classNames: ['sidebar-panel']
  layout: Ember.Handlebars.compile """
    <div class="panel-content">
      {{yield}}
    </div>
  """
