# FIXME: these should use URLS, but they don't play
# nicely with the iframe. Using 'history' and URL manipulation
# with the router causes the tests to blow up. So for now,
# we have to use the path names.
window.campaignPath = (campaign) ->
  "root.campaigns.campaign"

window.contactPath = (contact) ->
  "root.contacts.contact"

window.groupPath = (group) ->
  "root.groups.group"
