require 'views/sidebar_view'

Radium.CalendarSidebarView = Radium.SidebarView.extend
  classNameBindings: ['controller.isDifferentUser']
