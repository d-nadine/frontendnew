import Ember from 'ember';

export function avatar(params, options) {
  const resource = params[0];

  var resourceAvatar, img, props, style;

  style = options.style || options.size || 'small';

  switch(style) {
  case 'dash':
    props = {
      height: 244,
      width: 244
    };
    break;
  case 'large':
    props = {
      height: 124,
      width: 124
    };
    break;
  case 'sidebar':
    props = {
      height: 72,
      width: 72
    };
    break;
  case 'medium':
    props = {
      height: 64,
      width: 64
    };
    break;
  case 'contacts-table':
    props = {
      height: 32,
      width: 32
    };
    break;
  case 'small':
    props = {
      height: 30,
      width: 30
    };
    break;
  case 'tiny':
    props = {
      height: 22,
      width: 22
    };
    break;
  default:
    props = {
      height: 32,
      width: 32
    };
    break;
  }

  props.crop = 'fill';
  props.gravity = 'face';

  if (resource && resource.get('avatarKey')) {
    resourceAvatar = resource.get('avatarKey');
  } else {
    if(resource && resource.constructor === Radium.Company) {
      resourceAvatar = "/assets/default_avatars/company";
    } else {
      resourceAvatar = "default_avatars/large";
    }
  }

  img = $.cloudinary.image(resourceAvatar + ".jpg", props);

  return Ember.String.htmlSafe(img.get(0).outerHTML);
}

export default Ember.HTMLBars.makeBoundHelper(avatar);
