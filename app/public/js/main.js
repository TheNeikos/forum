/*
 * Main Module
 * Author: Marcel Mueller <com2040@gmail.com>
 * Repository: github.com/TheNeikos/forum
 *
 * */

angular.module("community", ["community.templates", "community.index", "community.categories", "community.users"])
.config(["$stateProvider","$locationProvider", "$urlRouterProvider",
        function($stateProvider, $locationProvider, $urlRouterProvider) {
    $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise("/");
}])

