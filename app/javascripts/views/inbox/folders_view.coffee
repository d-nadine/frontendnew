require 'radium/views/drawer_view'

Radium.FoldersView = Radium.DrawerView.extend
  templateName: 'radium/inbox/folders'
  contentBinding: 'controller.folders'
