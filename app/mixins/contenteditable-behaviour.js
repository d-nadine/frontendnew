import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  setEndOfContentEditble: function(node) {
    const ele = node ? node : this.$();
    if (!ele) {
      return null;
    }

    return ele.setEndOfContentEditble();
  },

  insertLineBreak: function() {
    const selection = window.getSelection();
    const range = selection.getRangeAt(0);
    const br = document.createElement('br');
    const textNode = document.createTextNode('\u00a0');

    range.deleteContents();
    range.insertNode(br);
    range.collapse(false);
    range.insertNode(textNode);
    range.selectNodeContents(textNode);
    selection.removeAllRanges();
    selection.addRange(range);

    Ember.run.next(() => {
      this.setEndOfContentEditble();
    });
  },
  insertHtml: function(html) {
    if (window.getSelection) {
      const sel = window.getSelection();

      if (sel.getRangeAt && sel.rangeCount) {
        let range = sel.getRangeAt(0);

        range.deleteContents();

        const el = document.createElement('div');

        el.innerHTML = html;

        const frag = document.createDocumentFragment();

        let node, lastNode;

        while ((node = el.firstChild)) {
          lastNode = frag.appendChild(node);
        }

        range.insertNode(frag);

        if (lastNode) {
          range = range.cloneRange();
          range.setStartAfter(lastNode);
          range.collapse(true);
          sel.removeAllRanges();
          return sel.addRange(range);
        }
      }
    } else if (document.selection && document.selection.type !== 'Control') {
      document.selection.createRange().pasteHTML(html);
    }
  },
  getCaretPosition: function(range, node) {
    const treeWalker = document.createTreeWalker(node, NodeFilter.SHOW_TEXT, (function(n) {
      var nodeRange;
      nodeRange = document.createRange();
      nodeRange.selectNode(n);
      if (nodeRange.compareBoundaryPoints(window.Range.END_TO_END, range) < 1) {
        return NodeFilter.FILTER_ACCEPT;
      }
      return NodeFilter.FILTER_REJECT;
    }), false);

    let charCount = 0;

    while (treeWalker.nextNode()) {
      charCount += treeWalker.currentNode.length;
    }

    if (range.startContainer.nodeType === 3) {
      charCount += range.startOffset;
    }

    return charCount;
  },

  setCaretPos: function(el, pos) {
    var charIndex, foundStart, i, nextCharIndex, node, nodeStack, range, selection, stop;
    charIndex = 0;
    range = document.createRange();
    range.setStart(el, 0);
    range.collapse(true);
    nodeStack = [el];
    node = void 0;
    foundStart = false;
    stop = false;
    while (!stop && (node = nodeStack.pop())) {
      if (node.nodeType === 3) {
        nextCharIndex = charIndex + node.length;
        if (!foundStart && pos >= charIndex && pos <= nextCharIndex) {
          range.setStart(node, pos - charIndex);
          foundStart = true;
        }
        if (foundStart && pos >= charIndex && pos <= nextCharIndex) {
          range.setEnd(node, pos - charIndex);
          stop = true;
        }
        charIndex = nextCharIndex;
      } else {
        i = node.childNodes.length;
        while (i--) {
          nodeStack.push(node.childNodes[i]);
        }
      }
    }
    selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
  }
});
