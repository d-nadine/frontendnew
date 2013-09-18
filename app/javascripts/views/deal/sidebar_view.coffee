require 'lib/radium/user_picker'
require 'mixins/views/uploading_mixin'

Radium.DealSidebarView = Radium.View.extend(Radium.UploadingMixin, Radium.ScrollableMixin)