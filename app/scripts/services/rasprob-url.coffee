
### @ngInject ###
module.exports = ($ionicPopup) ->
  pi = "http://192.168.0.14:8080"

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
