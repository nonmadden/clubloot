'use strict'

angular.module 'clublootApp'
.controller 'NewContestCtrl', ($scope, $http, socket, $timeout) ->
  console.log "NewContestCtrl"

  $scope.loadList = ->
    $http.get("/api/program",
        null
      ).success((data, status, headers, config) ->
        $scope.programList = data
        console.log data

      ).error((data, status, headers, config) ->
        swal("program Not found!!")
      )

    $http.get("/api/templates",
        null
      ).success((data, status, headers, config) ->
        $scope.templates = data
        console.log data

      ).error((data, status, headers, config) ->
        swal("template Not found!!")
      )

    $http.get("/api/questions",
        null
      ).success((data, status, headers, config) ->
        $scope.questions = data
        console.log data

      ).error((data, status, headers, config) ->
        swal("questions Not found!!")
      )

  $scope.loadList()

  $scope.landingContest = ->
    $http.post("/api/contest",
        $scope.contests
      ).success((data, status, headers, config) ->
        console.log $scope.programList
        console.log $scope.templates
        console.log $scope.questions

        $scope.xxx = []
        for template in $scope.templates
          if template.program == data.program #&& template.active == true
            $scope.xxx.push(template._id)
            console.log template._id

        console.log $scope.xxx[0]
        $http.get("/api/templates/#{$scope.xxx[0]}/questions",
            null
          ).success((ok) ->
            $scope.ques = ok
            console.log ok
          ).error((data, status, headers, config) ->
            swal("Not Active")
          )

        $scope.createNewStep = '2'
      ).error((data, status, headers, config) ->
        swal("Not found!!")
      )
    # $scope.createNewStep = '2'

  $scope.numbers = [
    { title: 1 },
    { title: 2 },
    { title: 3 },
    { title: 4 },
    { title: 5 }
  ]

  $scope.newContestQuestion = [
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false},
    {ans: '', showAns: false}
  ]

  $scope.finishNewContest = () ->
    window.location.href = '/dashboard'

  $scope.doneProcessing =  ->
    console.log $scope.newContestQuestion
    # $http.post("")


  $scope.unlessEmpty = () ->
    # console.log $scope.contests
    for q in $scope.newContestQuestion
      if q.ans == ''
        return false
    return true

  $scope.openAns = (index) ->
    if $scope.newContestQuestion[index].showAns == true
      $scope.newContestQuestion[index].showAns = false
      return
    for q in $scope.newContestQuestion
      q.showAns = false


    $scope.newContestQuestion[index].showAns = true
