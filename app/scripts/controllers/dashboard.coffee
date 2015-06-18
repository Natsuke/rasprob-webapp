
module.exports = ($scope, $http, $sce, rasprobUrl) ->

  $scope.title = "Dashboard"

  $scope.isControlled = false

  previousBeta = 0
  previousGamma = 0
  isStopped = true

  routes =
    left: '/left'
    rigth: '/right'
    up: '/up'
    down: '/down'
    stop: '/stop'
    stream: ':8080/?action=stream'

  angles =
    left: -10
    rigth: 10
    up: 25
    down: 45

  refreshUrl = ->
    url = rasprobUrl.get()
    sub = url.split(":")
    $scope.stream = sub[0] + ':' + sub[1] + routes.stream
  refreshUrl()

  $scope.toggle = ->
    $scope.isControlled = !$scope.isControlled
    if $scope.isControlled
      window.addEventListener 'deviceorientation', eventHandler
    else
      window.removeEventListener 'deviceorientation', eventHandler

  $scope.$watch 'isControlled', ->
    $scope.buttonText = if $scope.isControlled == false
    then "Controler"
    else "Stop"

  request = (direction) ->
    $http.get(rasprobUrl.get() + direction)
      .success (data) ->
        if direction == routes.stop
          isStopped = true
        else
          isStopped = false
        console.log('Ok')
      .error (err) ->
        console.error err

  isInitalPosition = (beta, gamma) ->
    return beta > angles.up and
      beta < angles.down and
      gamma < angles.rigth and
      gamma > angles.left

  eventHandler = (event) ->
    alpha = Math.round(event.alpha)
    beta = Math.round(event.beta)
    gamma = Math.round(event.gamma)

    switch
      when beta > angles.down and previousBeta < angles.down
      then request routes.down
      when beta < angles.up and previousBeta > angles.up
      then request routes.up
      when gamma > angles.rigth and previousGamma < angles.rigth
      then request routes.rigth
      when gamma < angles.left and previousGamma > angles.left
      then request routes.left
      else
        if !isStopped and isInitalPosition(beta, gamma)
          request routes.stop

    previousBeta = beta
    previousGamma = gamma


  if !(window.DeviceOrientationEvent)
    document.getElementById('warning').innerHTML = "Not Supported"
