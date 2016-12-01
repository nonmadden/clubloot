'use strict'

angular.module 'clublootApp'
.controller 'AddCoinCtrl', ($scope, $http, socket, buckets, $rootScope, Auth) ->
  # console.log "AddCoinCtrl"
  # console.log $rootScope
  # console.log "============="
  # console.log Auth.getCurrentUser()

  $http.get('/api/users/me', null).success (data, status, headers, config) ->
    # console.log "999999999999999999999999999999999999"
    # console.log data

  $scope.people = [
    { name: "John1"},
    { name: "John2"},
    { name: "John3"},
    { name: "John4"},
    { name: "John5"}
    ]

  $scope.buyCoin = () ->
    $http.put("/api/coin_package/#{$scope.currentUser._id}/addcoin",
      $scope.selectedBucket
    ).success((data, status, headers, config) ->
      $scope.currentUser = data
      $rootScope.currentUser = data
      return swal("Coin added!")
    ).error((data, status, headers, config) ->
      swal("Not found!!")
    )

  $scope.buckets = buckets.data

  $scope.goDashboard = () ->
    window.location.href = "/dashboard"