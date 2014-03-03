var portalWidgetsZap = angular.module('portalWidgetsZapApp', []);

portalWidgetsZap.directive('portalWidget', function($timeout) {
    return {
        link: function(scope, element, attrs) {
            var widget = scope.widget;
            if(widget){
                element.addClass(Jahia.Portal.constants.EXTERNAL_WIDGET_DROP_CLASS);
                element.attr("data-" + Jahia.Portal.constants.EXTERNAL_WIDGET_DROP_NODEYPE, widget.name);
                widget.views.forEach(function(view){
                    if(view.key == "edit"){
                        element.attr("data-" + Jahia.Portal.constants.EXTERNAL_WIDGET_DROP_VIEW, "edit");
                    }
                });
            }

            element.draggable({
                connectToSortable: Jahia.Portal.default.sortable_options.connectWith,
                helper: "clone",
                revert: "invalid"
            });
        }
    };
});

portalWidgetsZap.controller('widgetsCtrl', function ctrl($scope) {
    $scope.widgets = [];
    $scope.desiredWidget = "";
    $scope.query = "";

    $scope.init = function () {
        portal.getWidgetTypes(function (widgets) {
            $scope.$apply(function () {
                $scope.widgets = widgets;
            });
        });
    };

    $scope.search = function (widget) {
        return !!((widget.name.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1 || widget.displayableName.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1));
    };
});