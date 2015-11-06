export default {
  getSelection() {
    return window.getSelection();
  },

  getRange() {
    return this.getSelection().getRangeAt(0);
  }
};