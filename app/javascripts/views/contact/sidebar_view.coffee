Radium.ContactSidebarView = Radium.SidebarView.extend
  classNames: ['sidebar-panel-bordered']

  statusText: ( ->
    @get('controller.leadStatuses').find((leadStatus) =>
      leadStatus.value == @get('controller.status')
    ).name
  ).property('controller.status')
