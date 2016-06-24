'use strict'

angular.module 'clublootApp'
.config ($stateProvider) ->
  $stateProvider
  .state 'contest',
    url: '/contest'
    templateUrl: 'app/contest/contest.html'
    controller: 'ContestCtrl'
  .state 'contestshow',
    url: '/contest/:contest'
    templateUrl: 'app/contest/show.html'
    controller: 'ContestShowCtrl'