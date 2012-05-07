CONFIG.api = $.cookie('user_api_key');
CONFIG.userId = $.cookie('user_account_id');
CONFIG.ajax = {
  dataType: 'json',
  contentType: 'application/json',
  headers: {
    "X-Radium-User-API-Key": CONFIG.api,
    "Accept": "application/json"
  }
};