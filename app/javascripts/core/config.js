CONFIG.api = $.cookie('user_api_key');

//TODO: Why not use $.ajaxSetup
CONFIG.ajax = {
  dataType: 'json',
  contentType: 'application/json',
  headers: {
    "X-Radium-User-API-Key": CONFIG.api,
    "Accept": "application/json"
  }
};

CONFIG.dates = {
  timezone: new Date().getTimezoneOffset()
}
