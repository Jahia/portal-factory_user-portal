<%@ page import="org.jahia.modules.portal.PortalConstants" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="portal" uri="http://www.jahia.org/tags/portalLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="nodetype" type="org.jahia.services.content.nodetypes.ExtendedNodeType"--%>
<%--@elvariable id="portalNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<c:set var="portalMixin" value="<%= PortalConstants.JMIX_PORTAL %>"/>
<c:set var="portalModelNT" value="<%= PortalConstants.JNT_PORTAL_MODEL %>"/>
<c:set var="portalNode" value="${jcr:getParentOfType(renderContext.mainResource.node, portalMixin)}" />
<c:set var="portalIsModel" value="${jcr:isNodeType(portalNode, portalModelNT)}"/>
<c:set var="portalIsEditable" value="${jcr:hasPermission(renderContext.mainResource.node, 'jcr:write_live')}"/>
<c:set var="portalIsCustomizable" value="${portalIsModel and portalNode.properties['j:allowCustomization'].boolean}"/>
<c:set var="portalIsEnabled" value="${portalIsModel and portalNode.properties['j:enabled'].boolean}"/>
<c:set var="portalIsLocked" value="${not empty portalNode.properties['j:locked'] && portalNode.properties['j:locked'].boolean}"/>

<template:addCacheDependency node="${portalNode}"/>
<template:addResources type="javascript" resources="jquery.min.js,jquery-ui.min.js" />
<template:addResources type="javascript" resources="angular.min.js" />
<bootstrap:addThemeJS/>
<template:addResources type="javascript" resources="bootstrap-modal.js"/>
<template:addResources type="javascript" resources="bootstrap-tooltip.js" />
<template:addResources type="javascript" resources="app/portalToolbar.js" />
<template:addResources type="css" resources="portal-toolbar.css"/>

<div id="portal_toolbar" class="portal_toolbar">
    <div ng-controller="navCtrl" ng-init="init()">
        <c:if test="${portalIsModel && portalIsEditable}">
            <div class="alert alert-info">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <strong>Warning!</strong> <fmt:message key="jnt_portalToolbar.model.editable"/>
            </div>
        </c:if>
        <c:if test="${portalIsModel && !portalIsEditable && portalIsCustomizable}">
            <div class="alert alert-info">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                <strong>Warning!</strong> <fmt:message key="jnt_portalToolbar.model.notEditable"/>
            </div>
        </c:if>

        <ul class="nav nav-tabs">
            <li ng-class="isCurrentTab(tab) ? 'active' : ''" ng-repeat="tab in tabs">
                <a href="{{tab.url}}" decodehtml>{{tab.name}}</a>
            </li>

            <c:if test="${portalIsModel and !portal:userPortalExist(portalNode) and portalIsEnabled and portalIsCustomizable}">
                <li class="right">
                    <button type="button" class="customize-btn btn btn-inverse toolbar-tooltip" ng-click="copyModel()" data-placement="bottom"
                            title="<fmt:message key="jnt_portalToolbar.customize.tooltip"/>"><fmt:message key="jnt_portalToolbar.customize"/></button>
                </li>
            </c:if>
            <c:if test="${portalIsEditable && !portalIsLocked}">
                <li><a href="#newTabModal" data-toggle="modal"  class="toolbar-tooltip" data-placement="bottom" title="<fmt:message key="jnt_portalToolbar.addTab.tooltip"/>">
                    <i class="icon-plus"></i></a>
                </li>
                <li class="right" ng-show="canBeDeleted"><a href="#" ng-click="deleteTab()"
                                                            class="toolbar-tooltip" data-placement="bottom" title="<fmt:message key="jnt_portalToolbar.deleteTab.tooltip"/>">
                    <i class="icon-remove"></i></a>
                </li>
                <li class="right"><a href="#editTabModal" data-toggle="modal"
                                     class="toolbar-tooltip" data-placement="bottom" title="<fmt:message key="jnt_portalToolbar.editTab.tooltip"/>"><i class="icon-wrench"></i></a>
                </li>
                <li class="right visible-phone visible-tablet"><a href="#widgetsModal" data-toggle="modal"
                                     class="toolbar-tooltip" data-placement="bottom" title="<fmt:message key="jnt_portalToolbar.addWidget.tooltip"/>"><i class="icon-plus"></i></a>
                </li>
            </c:if>
            <c:if test="${portalIsEditable}">
                <li class="right">
                    <a href="#" ng-click="${portalIsLocked ? 'unlock()' : 'lock()'}"
                       class="toolbar-tooltip" data-placement="bottom"
                       title="<fmt:message key="jnt_portalToolbar.${portalIsLocked ? 'unlock' : 'lock'}.tooltip"/>">
                        <i class="icon-lock"></i>
                    </a>
                </li>
            </c:if>
        </ul>
    </div>

    <c:if test="${portalIsEditable && !portalIsLocked}">
        <script type="text/ng-template" id="tabFormTemplate">
            <form class="form-horizontal">
                <div class="control-group">
                    <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.name"/>:&nbsp; </label><input type="text" ng-model="form.name" required>
                </div>
                <div class="control-group">
                    <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.template"/>:&nbsp; </label>
                    <select ng-model='form.template.key' required ng-options='option.key as option.name for option in form.allowedTemplates'></select>
                </div>
                <div class="control-group">
                    <label class="control-label"><fmt:message key="jnt_portalToolbar.tabForm.widgetsSkin"/>:&nbsp; </label>
                    <select ng-model='form.widgetSkin.key' required ng-options='option.key as option.name for option in form.allowedWidgetsSkins'></select>
                </div>
            </form>
        </script>

        <div id="widgetsModal" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="widgetModalLabel" ng-controller="widgetsCtrl"
             ng-init="init('widgetsModal')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="cancel()">×</button>
                <h3 id="widgetModalLabel"><fmt:message key="jnt_portalToolbar.addWidget.tooltip"/></h3>
            </div>
            <div class="modal-body">
                <form class="form-inline" role="form" name="widgetForm">
                    <div class="form-group row-fluid">
                        <div class="span4">
                            <label for="widget_desiredName"><fmt:message key="jnt_portalToolbar.addWidgetForm.name"/>:</label>
                        </div>
                        <input id="widget_desiredName" class="span8 right" ng-model="desiredName" type="text" required>
                    </div>

                    <div class="form-group row-fluid">

                        <div class="span4">
                            <label><fmt:message key="jnt_portalToolbar.addWidgetForm.type"/>:</label>
                        </div>
                        <input class="span5 right" ng-model="query" type="text" placeholder="Search...">
                        <input type="hidden" ng-model="desiredWidget" required/>
                    </div>

                    <table class="table table-bordered widgets-table">
                        <tbody>
                            <tr ng-repeat="widget in widgets | filter: search" ng-class="desiredWidget == widget.name ? 'active' : ''">
                                <td colspan="2" ng-click="selectWidget(widget.name)">{{widget.displayableName}}</td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="cancel()"><fmt:message key="cancel"/></button>
                <button class="btn btn-primary" ng-disabled="widgetForm.$invalid" ng-click="addWidget()"><fmt:message key="add"/></button>
            </div>
        </div>

        <div id="editTabModal" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="editTabModalLabel" ng-controller="tabCtrl" ng-init="init('edit', 'editTabModal')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="cancel()">×</button>
                <h3 id="editTabModalLabel"><fmt:message key="jnt_portalToolbar.editTab"><fmt:param value="{{form.name}}"/></fmt:message></h3>
            </div>
            <div class="modal-body">
                <div>
                    <div ng-include src="'tabFormTemplate'">

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="cancel()"><fmt:message key="cancel"/></button>
                <button class="btn btn-primary" ng-click="submit(false)"><fmt:message key="save"/></button>
            </div>
        </div>

        <div id="newTabModal" class="modal hide fade" tabindex="-1" role="dialog"
             aria-labelledby="newTabModalLabel" ng-controller="tabCtrl" ng-init="init('new', 'newTabModal')">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="cancel()">×</button>
                <h3 id="newTabModalLabel"><fmt:message key="jnt_portalToolbar.addTab.tooltip"/></h3>
            </div>
            <div class="modal-body">
                <div>
                    <div ng-include src="'tabFormTemplate'">

                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn" data-dismiss="modal" ng-click="cancel()"><fmt:message key="cancel"/></button>
                <button class="btn btn-primary" ng-click="submit(true)"><fmt:message key="add"/></button>
            </div>
        </div>
    </c:if>
</div>

<script type="text/javascript">
    angular.bootstrap(document.getElementById("portal_toolbar"),['portalToolbar']);
</script>