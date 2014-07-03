require 'open-uri'

ignore %r{\.#.*$}
watch(/javascripts.*(coffee|js)$/) do |file|
  p "regenerating application.js <- #{file.first}"
  open("http://localhost:8080")
end
