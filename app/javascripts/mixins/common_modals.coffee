Radium.CommonModals = Ember.Mixin.create
  actions:
    createList: (list, parentModel) ->
      @closeModal()

      if list && list.constructor != Radium.List
        list = Ember.Object.create
                 isNew: true
                 name: list.get('email')
                 itemName: ''
                 type: 'companies'

      unless list
        list = Ember.Object.create
                 isNew: true
                 name: ''
                 itemName: ''
                 type: 'companies'

      @set 'modalModel', list
      @set 'parentModel', parentModel

      config = {
        bindings: [
          {name: "list", value: "modalModel"},
          {name: "parentModel", value: "parentModel"},
          {name: "parent", value: "this"}
        ],
        actions: [
          {name: "closeModal", value: "closeModal"},
          {name: "updateTotals", value: "updateTotals"}
        ]
        component: 'list-editor'
      }

      @set 'modalParams', config

      @set 'showModal', true

      false

    closeModal: ->
      @closeModal()

      false

  closeModal: ->
    @set 'showModal', false
    @set 'modalModel', null
    @set 'modalParams', null
    @set 'parentModel', null
