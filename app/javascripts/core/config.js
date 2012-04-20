CONFIG.api = $.cookie('user_api_key');
CONFIG.ajax = {
  dataType: 'json',
  contentType: 'application/json',
  accepts: 'application/json',
  headers: {
    "X-Radium-User-API-Key": CONFIG.api
  }
};