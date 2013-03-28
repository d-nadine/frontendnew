Radium.FixedSidebarView = Em.View.extend Radium.ScrollableMixin,
  classNames: ['sidebar-panel', 'sidebar-panel-fixed']

  layout: Ember.Handlebars.compile """
    <div class="scroller">
      <div class="scrollbar">
        <div class="track">
          <div class="thumb">
            <div class="end"></div>
          </div>
        </div>
      </div>
      <div class="viewport">
        <div class="overview">
          <div class="panel-content">
            {{yield}}
          </div>
        </div>
      </div>
    </div>
  """
