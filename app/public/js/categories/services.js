
angular.module("community.categories", [])
.service("categories", ["$http", function($http){
    function getAll() {
        return $http.get("/api/nodes/type/categories")
    }

    return {
        all: getAll,
    }
}])

