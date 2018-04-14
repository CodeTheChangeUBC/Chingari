// "use strict";
// Object.defineProperty(exports, "__esModule", { value: true });
class AnchorScroller {



  // Calling this scrolls to the current location hash (if possible)
  static scrollToCurrentAnchor(delay, duration) {
    if (document.location.hash.length >= 1) {
      AnchorScroller.scrollToDataAnchorDelay(document.location.hash.substr(1), delay, duration);
    }
  }

  // Scroll to the first anchor element with a matching data-anchor-id
  // Can specify delay and duration
  static scrollToDataAnchorDelay(id, delay, duration) {
    setTimeout(AnchorScroller.scrollToDataAnchor, delay, id, duration);
  }

  static scrollToDataAnchor(id, duration) {
    if (document.scrollDebounce === false) {
      document.scrollDebounce = true
      let element = AnchorScroller.getElementByDataAnchorId(id)
      if (element === undefined) {
        document.scrollDebounce = false
        return
      } else {
        $("html, body").animate(
          { scrollTop: $(element).offset().top },
          duration,
          () => { 
            setTimeout(() => {
              document.scrollDebounce = false
            }, 100) 
          }
        );
      }
    }
  }

  static getElementByDataAnchorId(id) {
    let matches = $(document).find("*[data-anchor-id='" + id + "']");
    return matches.length >= 1 ? matches[0] : undefined
  }


  static overrideAnchorClick(event, delay, duration) {
    if (event.delegateTarget.getAttribute("href") == null) { return }
    let hash_match = event.delegateTarget.getAttribute("href").match(/#\w+/)
    if (hash_match !== null) {
      let hash = hash_match[0].substr(1)
      if (AnchorScroller.getElementByDataAnchorId(hash) !== undefined) {
        event.preventDefault();
        AnchorScroller.scrollToCurrentAnchor(1, 500)
      }
    }
  }

}

document.scrollDebounce = false;

// // Scroll to the first anchor element with a matching data-anchor-id
// // Can specify delay and duration
// function scrollToDataAnchorDelay(id, delay, duration) {
//   if (window.scrollDebounce === false) {
//     window.scrollDebounce = true
//     setTimeout(scrollToElement, delay, id, duration);
//   }
// }

// // Calling this scrolls to the current location hash (if possible)
// function scrollToAnchor(delay, duration) {
//   if (document.location.hash.length >= 1) {
//     scrollToDataAnchorDelay(document.location.hash.substr(1), delay, duration);
//   }
// }

// /* PRIVATE METHODS */

// function getElementByDataAnchorId(id) {
//   let matches = $(document).find("a[data-anchor-id='" + id + "']");
//   return matches.length >= 1 ? matches[0] : undefined
// }

// function scrollToDataAnchor(id, duration) {
//   let element = getElementByDataAnchorId(id)
//   if (element === undefined) {
//     window.scrollDebounce = false
//     return
//   } else {
//     $("html, body").animate({
//       scrollTop: $(element).offset().top,
//       duration: duration,
//       complete: () => { setTimeout(() => window.scrollDebounce = false, 100) }
//     });
//   }
// }