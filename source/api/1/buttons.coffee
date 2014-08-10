# Buttons.coffee
# Consider multiple YoCounter Buttons to be embedded in a single web page!
# Put the identical id on each <script> and <link> tags that are loaded dynamically!

# Constants
COUNTER_CLASS_NAME = 'yo-counter'
CLASS_NAME_PREFIX = '__yo-counter-'
HASHTAG_ATTR_NAME = 'data-hashtag'
STYLESHEET_ID = '__yo-counter-css'
FONT_STYLESHEET_ID = '__yo-counter-font'

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
    else
      String(num).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,')

  # Appends the specific Element to head
  # Does nothing if the Element with the specific id already exists
  append_to_head: (element) ->
    id = element.getAttribute('id')
    unless (id && @$('#' + id))
      (document.head || document.getElementsByTagName('head')[0]).appendChild(element)

  # Includes specific Javascript
  include_js: (src, id = undefined) ->
    script = document.createElement('script')
    script.setAttribute('type', 'text/javascript')
    script.setAttribute('src', src)
    script.setAttribute('id', id) if id
    @append_to_head(script)

  # Includes specific Stylesheet
  link_css: (href, id = undefined) ->
    link = document.createElement('link')
    link.setAttribute('type', 'text/css')
    link.setAttribute('rel', 'stylesheet')
    link.setAttribute('href', href)
    link.setAttribute('id', id) if id
    @append_to_head(link)

  # Includes JSONP API
  include_count_js: (hashtag) ->
    @include_js('http://api.justyo.co/yo_count/?hashtag=' + hashtag + '&jsonp=__yo_counter.callback', '__yo-counter-js-' + hashtag)

  # Returns path to the asset for each environment
  asset_path: (path) ->
    if !!location.href.match(/^https?:\/\/localhost[\:\/]/)
      path
    else
      '//counter.justyo.co' + path

  # Treats JSONP API return and renders counter to DOM
  callback: (data) ->
    hashtag = data.result.hashtag
    if hashtag
      for _ in @$by_hashtag(hashtag)
        count = _.getElementsByClassName("#{CLASS_NAME_PREFIX}count")[0]
        count.innerHTML = @format_number(data.result.yoCount)
        count.style.display = 'inline'

  init: ->
    # Includes CSS
    @link_css('//fonts.googleapis.com/css?family=Montserrat:700,400', FONT_STYLESHEET_ID)
    @link_css(@asset_path('/api/1/buttons.css'), STYLESHEET_ID)

    for _ in @$('.' + COUNTER_CLASS_NAME)
      # Gets a hashtag
      hashtag = _.getAttribute(HASHTAG_ATTR_NAME)

      if hashtag
        # Includes JSONP API
        @include_count_js(hashtag)

        # Fixes design
        _.innerHTML = """
          <div class="#{CLASS_NAME_PREFIX}wrapper">
            <div class="#{CLASS_NAME_PREFIX}icon"></div>
            <div class="#{CLASS_NAME_PREFIX}content">
              <span class="#{CLASS_NAME_PREFIX}hashtag">#{hashtag}</span>
              <span class="#{CLASS_NAME_PREFIX}count"></span>
            </div>
          </div>
        """

@__yo_counter.init()
