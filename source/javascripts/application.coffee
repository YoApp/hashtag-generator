$ ->
  TAG_TEMPLATE = '<a href="http://justyo.co/h/:hashtag" class="yo-counter" data-hashtag=":hashtag">#:hashtag</a>'

  $('#generator-form').submit (event) ->
    event.preventDefault()

  $('#hashtag-input').keyup (event) ->
    hashtag = $(this).val().toUpperCase()
    is_valid = hashtag && !!hashtag.match(/^[A-Z][0-9A-Z]*$/)

    if hashtag && is_valid
      $('#yo-counter-a-textarea').val(TAG_TEMPLATE.replace(/:hashtag/g, hashtag))
      $('#slider').slideDown()
      $('#error').slideUp()
    else
      $('#slider').slideUp()
      if !hashtag
        $('#error').html('Hashtag is required!').slideDown()
      else if hashtag.match(/^[0-9]/)
        $('#error').html('Hashtag has to start with an alphabet!').slideDown()
      else
        $('#error').html('Hashtag can include only alphabets and numbers!').slideDown()

  $('#hashtag-input').focus()
