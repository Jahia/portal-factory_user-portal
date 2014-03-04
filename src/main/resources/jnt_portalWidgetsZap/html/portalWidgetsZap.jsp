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

<template:addResources type="javascript" resources="jquery.min.js,jquery-ui.min.js" />
<template:addResources type="javascript" resources="angular.min.js" />
<template:addResources type="javascript" resources="app/portalWidgetsZap.js" />
<c:choose>
    <c:when test="${renderContext.mode == 'studiovisual'}">
        <div id="portalWidgetsZap">
            <button type="button">Add widget</button>
            <div>
                <input class="span5 right" type="text" placeholder="Search...">

                <ul>
                    <li>
                        <span>Widget 1</span>
                    </li>
                    <li>
                        <span>Widget 2</span>
                    </li>
                    <li>
                        <span>Widget 3</span>
                    </li>
                </ul>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <c:set var="portalMixin" value="<%= PortalConstants.JMIX_PORTAL %>"/>
        <c:set var="portalModelNT" value="<%= PortalConstants.JNT_PORTAL_MODEL %>"/>
        <c:set var="portalNode" value="${jcr:getParentOfType(renderContext.mainResource.node, portalMixin)}" />
        <c:set var="portalIsEditable" value="${jcr:hasPermission(renderContext.mainResource.node, 'jcr:write_live')}"/>

        <div id="portalWidgetsZap" ng-controller="widgetsCtrl" ng-init="init()">
            <button type="button" ng-init="showList = false" ng-click="showList = !showList">Add widget</button>
            <div ng-show="showList">
                <input class="span5 right" ng-model="query" type="text" placeholder="Search...">

                <ul>
                    <li ng-repeat="widget in widgets | filter: search" portal-widget>
                        <span>{{widget.displayableName}}</span>
                    </li>
                </ul>
            </div>
        </div>

        <script type="text/javascript">
            // Boostrap app
            angular.bootstrap(document.getElementById("portalWidgetsZap"),['portalWidgetsZapApp']);
        </script>
    </c:otherwise>
</c:choose>
