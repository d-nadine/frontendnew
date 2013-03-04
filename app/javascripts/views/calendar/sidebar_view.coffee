require 'views/fixed_sidebar_view'

Radium.CalendarSidebarView = Radium.FixedSidebarView.extend
  classNameBindings: ['controller.isDifferentUser']
