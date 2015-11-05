$.fn.setCursorPosition = function() {
  return this.each(function() {
    const v = $(this).val();

    $(this).focus().val('').val(v);

    return this;
  });
};

$.fn.restoreCursor = function(pos) {
  const element = $(this).get(0);
  const range = document.createRange();

  range.setStart(element.firstChild, pos);

  range.setEnd(element.firstChild, pos);

  const selection = window.getSelection();

  selection.removeAllRanges();

  return selection.addRange(range);
};

$.fn.setEndOfContentEditble = function() {
  const range = document.createRange();

  range.selectNodeContents(this.get(0));

  range.collapse(false);

  const selection = window.getSelection();

  selection.removeAllRanges();

  return selection.addRange(range);
};

$.fn.selectText = function() {
  const doc = document;
  const element = this[0];

  if (doc.body.createTextRange) {
    let range = document.body.createTextRange();
    range.moveToElementText(element);
    return range.select();
  } else if (window.getSelection) {
    const selection = window.getSelection();

    let range = document.createRange();

    range.selectNodeContents(element);

    selection.removeAllRanges();

    return selection.addRange(range);
  }
};