# Constants
COUNTER_CLASS_NAME = 'yo-counter'
HASHTAG_ATTR_NAME = 'data-hashtag'
STYLESHEET_ID = '__yo-counter-css'

@__yo_counter =
  # jQuery-like selector
  $: (selector) ->
    if selector.substr(0, 1) is '#'
      document.getElementById(selector.substr(1))
    else if selector.substr(0, 1) is '.'
      document.getElementsByClassName(selector.substr(1))

  # Finds Elements by hashtag
  $by_hashtag: (hashtag) ->
    elements = []
    for _ in @$('.' + COUNTER_CLASS_NAME)
      elements.push(_) if _.getAttribute(HASHTAG_ATTR_NAME) is hashtag
    elements

  # Format number style
  format_number: (num) ->
    if !num || isNaN(num)
      '?'
    else if num >= 9950
      Math.round(count / 1000) + 'K'
    else if num >= 1000
      (Math.round(count / 100) / 10) + 'K'
    else
      num

  # Includes specific Javascript
  include_js: ->
    alert('HELLO')

  callback: (data) ->
    hashtag = data.result.hashtag
    if hashtag
      for _ in @$by_hashtag(hashtag)
        _.innerHTML = data.result.yoCount

  init: ->
    script = document.createElement('script')
    script.setAttribute('type', 'text/javascript')
    script.setAttribute('src', 'http://api.justyo.co/yo_count/?hashtag=' + 'ILOVECOOKIES' + '&jsonp=__yo_counter.callback')
    (document.head || document.getElementsByTagName('head')[0]).appendChild(script)

window.onload = ->
  @__yo_counter.init()
