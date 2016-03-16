module.exports = function(environment){
  var ENV = {
  };

  if (environment === 'staging') {
    ENV['scp'] = {
        username: 'deployer',
        host: '45.55.51.62',
        path: '/var/www/radium-front'
    }
  };

  if (environment === 'production') {
    ENV['scp'] = {
        username: '<your-username>',
        host: '<your-host>',
        path: '<your-serverpath>'
    }
  };
  return ENV;
};
