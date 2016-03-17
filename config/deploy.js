module.exports = function(environment){
  var ENV = {
  };

  if (environment === 'staging') {
    ENV['scp'] = {
        username: 'deployer',
        host: '45.55.51.62',
        path: '/var/www/radium-front'
    }
    ENV['build'] = {
      environment: 'staging'
    };
  };

  if (environment === 'production') {
    ENV['scp'] = {
        username: '<your-username>',
        host: '<your-host>',
        path: '<your-serverpath>'
    }
    ENV['build'] = {
      environment: 'production'
    };
  };
  return ENV;
};
