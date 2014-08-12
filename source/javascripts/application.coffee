#= require ZeroClipboard

$ ->
  TAG_TEMPLATE = '<a href="http://justyo.co/h/:hashtag" class="yo-counter" data-hashtag=":hashtag">#:hashtag</a>'

  format_number = (num) ->
    if !num || isNaN(num)
      '?'
    else
      String(num).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,')

  $('#generator-form').submit (event) ->
    event.preventDefault()

  $('#hashtag-input').keyup (event) ->
    hashtag = $(this).val().toUpperCase()
    is_valid = hashtag && !!hashtag.match(/^[A-Z][0-9A-Z]*$/)

    if hashtag && is_valid
      $('#a-textarea').val(TAG_TEMPLATE.replace(/:hashtag/g, hashtag))
      $('.sample-hashtag').html(hashtag)
      $('.sample-count').html(format_number(1000 + Math.floor(Math.random() * 9000)))
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

#  $('#text-color-input').change ->
#    csstext = "color:##{$(this).val()}!important;"
#    $('.yo-counter .__yo-counter-wrapper .__yo-counter-content *').css({ cssText: csstext + 'display:inline;' })
#    $('#css-textarea').val(".yo-counter *{#{csstext}}")

  $('.copy').click ->
    $(this).html('<i class="fa fa-check-circle"></i> Copied!')
    setTimeout(=>
      $(this).html('<i class="fa fa-copy"></i> Copy')
    , 2000)

  $('#hashtag-input').focus()

  new ZeroClipboard($('.copy'))
