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
<template:addResources type="javascript" resources="jquery.tabSlideOut.v1.3.js" />
<template:addResources type="javascript" resources="angular.min.js" />
<template:addResources type="javascript" resources="app/portalWidgetsZap.js" />
<template:addResources type="css" resources="portal-zap.css"/>

<script>
    $(function(){
        $('#portalWidgetsZap').tabSlideOut({
            pathToTabImage: '<c:url value="${url.currentModule}/img/open.png"/>',
            tabHandle: '.handle',                              //class of the element that will be your tab
            imageHeight: '32px',                               //height of tab image
            imageWidth: '32px',                               //width of tab image
            tabLocation: 'left',                               //side of screen where tab lives, top, right, bottom, or left
            speed: 300,                                        //speed of animation
            action: 'click',                                   //options: 'click' or 'hover', action to trigger animation
            topPos: '100px',                                   //position from the top
            fixedPosition: true                               //options: true makes it stick(fixed position) on scroll
        });
    });
</script>

<c:choose>
    <c:when test="${renderContext.mode == 'studiovisual'}">
        <div id="portalWidgetsZap visible-desktop">
            <a class="handle" href="http://link-for-non-js-users.html">Content</a>
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
    </c:when>
    <c:otherwise>
        <c:set var="portalMixin" value="<%= PortalConstants.JMIX_PORTAL %>"/>
        <c:set var="portalModelNT" value="<%= PortalConstants.JNT_PORTAL_MODEL %>"/>
        <c:set var="portalNode" value="${jcr:getParentOfType(renderContext.mainResource.node, portalMixin)}" />
        <c:set var="portalIsEditable" value="${jcr:hasPermission(renderContext.mainResource.node, 'jcr:write_live')}"/>

        <div id="portalWidgetsZap" ng-controller="widgetsCtrl" ng-init="init()">
            <a class="handle" href="http://link-for-non-js-users.html">Content</a>
            <div class="row-fluid">
                <input class="span12" ng-model="query" type="text" placeholder="Search...">
                <ul class="zap-menu">
                    <li ng-repeat="widget in widgets | filter: search" portal-widget>
                        <span><i class="fa fa-share color-blue"></i> {{widget.displayableName}}</span>
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
