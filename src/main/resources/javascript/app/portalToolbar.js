var portalToolbar = angular.module('portalToolbar', []);

portalToolbar.directive('decodehtml', function($timeout) {
    return {
        link: function(scope, element, attrs) {
            setTimeout(function(){
                element.text($("<div></div>").html(element.text()).text());
            }, 0)
        }
    };
});

portalToolbar.controller('widgetsCtrl', function ctrl($scope) {
    $scope.modalId = "";
    $scope.widgets = portal.portalWidgetTypes;
    $scope.desiredName = "";
    $scope.desiredWidget = null;
    $scope.query = "";

    $scope.init = function (modalId) {
        $scope.modalId = modalId;
    };

    $scope.selectWidget = function (widget) {
        $scope.desiredWidget = widget;
    };

    $scope.addWidget = function () {
        if ($scope.desiredWidget != null) {
            var desiredName = $scope.desiredName.length > 0 ? $scope.desiredName : $scope.desiredWidget.displayableName;
            portal.addNewWidget($scope.desiredWidget.name, desiredName);
            $scope.cancel();
        }
    };

    $scope.cancel = function () {
        $('#' + $scope.modalId).modal('hide');
        $scope.desiredName = "";
        $scope.desiredWidget = null;
    };

    $scope.search = function (widget) {
        return !!((widget.name.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1 || widget.displayableName.toLowerCase().indexOf($scope.query.toLowerCase() || '') !== -1));
    };
});

portalToolbar.controller('tabCtrl', function test($scope) {
    $scope.modalId = "";
    $scope.edit = false;
    $scope.form = [];

    $scope.init = function (type, modalId) {
        $scope.modalId = modalId;
        $scope.edit = (type && type == "edit");
        $('#' + modalId).on('show', function () {
            $scope.$apply(function(){
                $scope.form = {
                    name: $scope.edit ? $("<div></div>").html(portal.portalCurrentTab.displayableName).text() : '',
                    template: portal.portalCurrentTab.templateKey,
                    widgetSkin: portal.portalCurrentTab.skinKey,
                    accessibility: portal.portalCurrentTab.accessibility,
                    allowedTemplates: portal.portalTabTemplates,
                    allowedWidgetsSkins: portal.portalTabSkins
                }
            });
        });
    };

    $scope.cancel = function () {
        $('#' + $scope.modalId).modal('hide');
        $scope.form = [];
    };

    $scope.submit = function (isNew) {
        portal.saveTabForm($scope.transformForm(isNew), function () {
            $scope.$apply(function () {
                $scope.form = [];
            });
        }, isNew);
    };

    $scope.transformForm = function (isNew) {
        var result = [
            {"name":"jcr:title", "value":$scope.form.name},
            {"name":"j:templateName", "value":$scope.form.template},
            {"name":"j:widgetSkin", "value":$scope.form.widgetSkin}
        ];

        if(!portal.isModel && (isNew || $scope.form.accessibility != portal.portalCurrentTab.accessibility)){
            result.push({"name":"j:accessibility", "value":$scope.form.accessibility});
        }

        return result;
    }
});

portalToolbar.controller('newWidgetsCtrl', function test($scope) {
    $scope.modalId = "";
    $scope.newWidgetTypes = [];

    $scope.init = function (modalId) {
        $scope.modalId = modalId;
        $(document).ready(function(){
            $scope.$apply(function(){
                for(var i = 0; i < portal.portalWidgetTypes.length; i++){
                    if(portal.portalWidgetTypes[i].new){
                        $scope.newWidgetTypes.push(portal.portalWidgetTypes[i]);
                        $("#" + modalId).modal();
                    }
                }
            });
        })
    };

    $scope.ok = function(){
        // AJAX update portal widget type list
        var url = JCRRestUtils.buildURL("","","",portal.portalIdentifier);
        var data = [];
        for(var i = 0; i < portal.portalWidgetTypes.length; i++){
            if(portal.portalWidgetTypes[i]){
                data.push({name:"j:allowedWidgetTypes",value:portal.portalWidgetTypes[i].name})
            }
        }
        JCRRestUtils.standardCall(url, "PUT",
            JSON.stringify({properties: JCRRestUtils.arrayToDataProperties(data, true)}));
    }
});

portalToolbar.controller('navCtrl', function test($scope) {
    $scope.canBeDeleted = false;
    $scope.tabs = portal.portalTabs;

    $scope.init = function () {
        $scope.canBeDeleted = portal.portalTabs.length > 1;
        $(".toolbar-tooltip").tooltip();
    };

    $scope.isCurrentTab = function (tab) {
        return tab.path == portal.portalTabPath;
    };

    $scope.getTabHref = function (tab) {
        return portal.baseURL + tab.path + ".html";
    };

    $scope.deleteTab = function(){
        if($scope.canBeDeleted){
            portal.deleteCurrentTab();
        }
    };

    $scope.copyModel = function(){
        portal.initPortalFromModel();
    };

    $scope.lock = function(){
        portal.lockPortal();
    };

    $scope.unlock = function(){
        portal.unlockPortal();
    }
});