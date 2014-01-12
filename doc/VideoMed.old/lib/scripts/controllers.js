function VideoGroupCtrl($scope){
	$scope.categories = [
		{"id" : "1", "name": "Acne"},
		{"id" : "2", "name": "Dry Skin"}
		];
		
	$scope.select =  function(group){
		$scope.selected = group;
	};
	
	$scope.list = [
		{group: "1",
		 videos: [{"id" : "1001", "title": "What is acne?", "link": "link1001", "runtime": "3:00"},
			{"id" : "1002", "title": "Treatment options for acne.", "link": "link1002", "runtime": "3:10"},
			{"id" : "1003", "title": "Methods about acne.", "link": "link1003", "runtime": "2:10"},
			{"id" : "1004", "title": "How to prevent acne scares.", "link": "link1004", "runtime": "1:50"}]
		},
		{group: "2",
		 videos:[{"id" : "2.001", "title": "What causes dry skin?", "link": "link1001", "runtime": "3:00"},
		{"id" : "2.002", "title": "Treatment options for dry skin.", "link": "link1002", "runtime": "3:10"},
		{"id" : "2.003", "title": "Meths about dry skin.", "link": "link1003", "runtime": "2:10"}]
		}];
		
	$scope.selected =null;
		
}
	$scope.clkGroupID = function(){
			VideoListCtrl($scope, $scope.clkGroupID);
	}

	
function VideoListCtrl($scope, id){
	$scope.list1 = [
		{"id" : "1001", "title": "What is acne?", "link": "link1001", "runtime": "3:00"},
		{"id" : "1002", "title": "Treatment options for acne.", "link": "link1002", "runtime": "3:10"},
		{"id" : "1003", "title": "Methods about acne.", "link": "link1003", "runtime": "2:10"},
		{"id" : "1004", "title": "How to prevent acne scares.", "link": "link1004", "runtime": "1:50"}
	];
	$scope.list2 = [
		{"id" : "2.001", "title": "What causes dry skin?", "link": "link1001", "runtime": "3:00"},
		{"id" : "2.002", "title": "Treatment options for dry skin.", "link": "link1002", "runtime": "3:10"},
		{"id" : "2.003", "title": "Meths about dry skin.", "link": "link1003", "runtime": "2:10"}
	];
	
	
	
}

function Ctrl1($scope){
	$scope.list = [
		{"id" : "1001", "title": "What is acne?", "link": "link1001", "runtime": "3:00"},
		{"id" : "1002", "title": "Treatment options for acne.", "link": "link1002", "runtime": "3:10"},
		{"id" : "1003", "title": "Methods about acne.", "link": "link1003", "runtime": "2:10"},
		{"id" : "1004", "title": "How to prevent acne scares.", "link": "link1004", "runtime": "1:50"}
	];
}

function Ctrl2($scope){
	$scope.list = [
		{"id" : "2.001", "title": "What causes dry skin?", "link": "link1001", "runtime": "3:00"},
		{"id" : "2.002", "title": "Treatment options for dry skin.", "link": "link1002", "runtime": "3:10"},
		{"id" : "2.003", "title": "Meths about dry skin.", "link": "link1003", "runtime": "2:10"}
	];
}