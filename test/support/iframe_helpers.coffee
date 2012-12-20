$ ->
  document.getElementById('app').onload = ->
    window.$F = document.getElementById('app').contentWindow.jQuery
    window.$A = document.getElementById('app').contentWindow.Radium
    window.$W = document.getElementById('app').contentWindow
