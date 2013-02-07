Radium.MessagesDiscussionPanelController = Em.ObjectController.extend
  deleteDiscussion: (discussion) ->
    # FIXME: delete for real

    # discussion.deleteRecord()
    # discussion.store.commit()

    Radium.Utils.notify "discussion deleted."

