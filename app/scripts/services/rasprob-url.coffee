
### @ngInject ###
module.exports = ($ionicPopup) ->
  pi = localStorage?.getItem('pi-url') || ""

  @get = ->
    return pi

  @set = ->
    $ionicPopup.prompt(
      title: 'RaspRob Url'
      subTitle: 'Change your RaspRob url'
      inputType: 'url'
      inputPlaceholder: "#{pi}"
    ).then (url)->
      if url
        pi = url
        localStorage.setItem('pi-url', url)

  return @
