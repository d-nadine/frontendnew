Radium.SidebarAboutView = Radium.InlineEditorView.extend
  textArea: Radium.TextArea.extend(Ember.TargetActionSupport,
     click: (event) ->
      event.stopPropagation()

    insertNewline: ->
      @get('parentView').toggleEditor()
  )
#   template: Ember.Handlebars.compile """
#     <div>
#       {{#if view.isEditing}}
#         <h2>About</h2>
#         <div>
#           {{view view.textArea class="field" valueBinding=view.value placeholder="About"}}
#         </div>
#       {{else}}
#         <h2>About <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></h2>
#         <div>
#           {{#if about}}
#           <span>{{about}}</span>
#           {{else}}
#           <span>&nbsp;</span>
#           {{/if}}
#         </div>
#       {{/if}}
#     </div>
#   """
