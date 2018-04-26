export default class AnchorScroller {
  // Summary: 
  //   Calling this scrolls to the current location hash id (eg. /current/path/#foobar) if one exists.
  // DOM Effects: 
  //   For this to work
  //     - There must be an element with a matching data-anchor-id (eg. <a data-anchor-id="foobar"></a>)
  //     - The scroller must have finished all current actions
  //   Otherwise the action is ignored.
  //   Note that the scroll destination is computed after the delay, just before animation.
  // Params:
  //   delay - scrolling animation delay in milliseconds
  //   duration - scrolling animation duration in milliseconds
  static scrollToCurrentAnchor(delay, duration) {
    if (document.location.hash.length >= 1) {
      AnchorScroller.scrollToDataAnchorDelay(document.location.hash.substr(1), delay, duration);
    }
  }

  static scrollToDataAnchorDelay(id, delay, duration) {
    setTimeout(AnchorScroller.scrollToDataAnchor, delay, id, duration);
  }

  static scrollToDataAnchor(id, duration) {
    if (AnchorScroller.scrollDebounce === false) {
      AnchorScroller.scrollDebounce = true
      let element = AnchorScroller.getElementByDataAnchorId(id)
      if (element === undefined) {
        AnchorScroller.scrollDebounce = false
        return
      } else {
        $("html, body").animate(
          { scrollTop: $(element).offset().top },
          duration,
          () => { 
            setTimeout(() => {
              AnchorScroller.scrollDebounce = false
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
    let hash_match = event.delegateTarget.getAttribute("href").match(/#[a-zA-Z0-9_-]+/)
    if (hash_match !== null) {
      let hash = hash_match[0].substr(1)
      if (AnchorScroller.getElementByDataAnchorId(hash) !== undefined) {
        event.preventDefault();
        document.location.hash = hash;
        AnchorScroller.scrollToCurrentAnchor(1, 500)
      }
    }
  }

}

AnchorScroller.scrollDebounce = false;