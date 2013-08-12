class Luhn
  @calculateLuhn = (number) ->
    sum = 0
    i = 0

    while i < number.length
      sum += parseInt(number.substring(i, i + 1))
      i++

    delta = new Array(0, 1, 2, 3, 4, -4, -3, -2, -1, 0)
    i = number.length - 1
    while i >= 0
      deltaIndex = parseInt(number.substring(i, i + 1))
      deltaValue = delta[deltaIndex]
      sum += deltaValue
      i -= 2

    mod10 = sum % 10
    mod10 = 10 - mod10
    mod10 = 0  if mod10 is 10
    mod10

  @luhnCheck = (number) ->
    luhn = number.replace(/[^\d]/g, "")
    digit = parseInt( luhn.substring( luhn.length - 1, luhn.length ) )
    luhnLess = luhn.substring(0, luhn.length - 1)
    if ( Orders.calculateLuhn( luhnLess ) isnt parseInt( digit ) )
      return false
    return true

  @detectCardType: ->
    creditCardTypeFromNumber = (num) ->
      # inspiration http://cuinl.tripod.com/Tips/o-1.htm
      switch parseInt(num.substr(0, 2))
        when 34, 37                     then return "amex"
        # when 36                           then return "dinersclub"
        # when 38                           then return "carteblanche"
        when 51, 52, 53, 54, 55   then return "mastercard"
        else

          switch parseInt(num.substr(0, 4))
            # when 2014, 2149   then return "enroute"
            # when 2131, 1800   then return "jcb"
            when 6011             then return "discover"
            else

              # switch parseInt(num.substr(0, 3))
              #   # when 300, 301, 302, 303, 304, 305   then return "americandinersclub"
              #   else
                  
              switch parseInt(num.substr(0, 1))
                # when 3  then  return "jcb"
                when 4  then  return "visa"
                else
                  return "generic"

    type = creditCardTypeFromNumber($("#card_number").val())

    if Orders.luhnCheck($("#card_number").val()) and $("#card_number").val().length > 11
      $('#billing h1').addClass('valid')
    else
      $('#billing h1').removeClass('valid')

    console.log "card number: " + $("#card_number").val()
    console.log "type: " + type
    
    unless type == "generic"
      $("##{type}").stop(true).animate
          opacity: 1
      $('.cards img').not("##{type}").stop(true).animate
        opacity: .5
        
    else
      $('.cards img').stop(true).animate
        opacity: 1

  @checkCard: ->
    Orders.detectCardType()     

    $('#card_number').keyup ->
      Orders.detectCardType()
end