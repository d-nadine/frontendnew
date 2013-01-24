window.click = (object) ->
  if object.hasOwnProperty 'click'
    object.click()
  else
    $F(object).click()

window.selectDropDownOption = (selector, optionIndex) ->
  if $F(selector).length == 0
    throw "Could not find #{selector}"

  $F(selector).val($F("#{selector} option:eq(#{optionIndex})").val())
  $F(selector).trigger('change')

window.fillIn = (selector, text) ->
  # keyup with any char to trigger bindings sync
  event = jQuery.Event("keyup")
  event.keyCode = 46
  if $F(selector).length == 0
    throw "Could not find #{selector}"
  $F(selector).val(text).trigger(event)

window.pressEnter = (selector) ->
  event = jQuery.Event("keypress")
  event.keyCode = 13
  if $F(selector).length == 0
    throw "Could not find #{selector}"
  $F(selector).trigger(event)

window.fillInAndPressEnter = (selector, text) ->
  fillIn(selector, text)
  pressEnter(selector)

window.openNotifications = (callback) ->
  click '.notifications-link'
  waitForSelector "#notifications", callback

window.clickNotification = (notification) ->
  click "li[data-notification-id=\"#{notification.get('id')}\"] .content"

window.clickReminder = (reminder) ->
  click "li[data-reminder-id=\"#{reminder.get('id')}\"] .content"

window.clickEmail = (email) ->
  click "#sidebar [data-email-id=\"#{email.get('id')}\"]"
