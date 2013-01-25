Radium.ContactSearchController = Em.ArrayController.extend
  contentBinding: 'pipelineTableController.visibleContent'
  sources: ( ->
    return [] unless @get('content')
    @get('content').map( (contact) -> 
      contact.get("source")
    ).uniq().sort()
    .filter( (source) -> source)
  ).property('content', 'content.length')
