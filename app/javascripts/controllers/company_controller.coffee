Radium.CompanyController = Radium.ObjectController.extend
  needs: ['users', 'tags', 'companies', 'countries']

  # FIXME: How do we determine this?
  isEditable: true
