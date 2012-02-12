({
  // name: 'main',
  out: 'main-built.js',
  baseUrl: '.',
  dir: '.',
  modules: [ 
    {name: "main"} 
  ], 
  paths: {
    jquery: 'libs/jquery/jquery',
    jqueryUI: 'libs/jquery/jquery-ui.min',
    ember: 'libs/ember/ember',
    datetime: 'libs/ember/ember-datetime',
    router: 'libs/davis',
    data: 'libs/ember/ember-data',
    adapter: 'mixins/adapter',
    radium: 'core/radium',
    text: 'libs/require/require.text',
  },
  priority: [
    'jquery',
    'jqueryUI',
    'ember',
    'datetime',
    'router',
    'data',
    'adapter',
    'mixins/data',
    'radium',
    'core/app'
  ]
})
