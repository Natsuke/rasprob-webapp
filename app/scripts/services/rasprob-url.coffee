
### @ngInject ###
module.exports = ($ionicPopup) ->
  pi = "http://127.0.0.1:8081"

  @get = ->
    pi

  @set = ->
    $ionicPopup.prompt(
      title: 'RaspRob Url'
      subTitle: 'Change your RaspRob url'
      inputType: 'url'
      inputPlaceholder: "#{pi}"
    ).then (res)->
      if res
        pi = res

  return @
