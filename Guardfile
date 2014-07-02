require 'open-uri'

watch(/.*(coffee|js)$/) do |file|
  p "regenerating application.js"
  open("http://localhost:8080")
end
