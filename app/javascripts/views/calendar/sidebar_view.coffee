require 'views/fixed_sidebar_view'

Radium.CalendarSidebarView = Radium.FixedSidebarView.extend
  elementId: ['calendar-sidebar-panel']

  classNameBindings: ['controller.isDifferentUser']
