export default {
  resolve(url) {
    if(/([A-Za-z]{3,9}:(?:\/\/)?)/.test(url)) {
      return url;
    } else {
      return `//${url}`;
    }
  }
};