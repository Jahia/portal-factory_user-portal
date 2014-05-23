package org.jahia.modules.portal.action;

import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.modules.portal.PortalConstants;
import org.jahia.modules.portal.service.PortalService;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * Created by kevan on 23/05/14.
 */
public class ResetPortalAction extends Action{
    private PortalService portalService;

    @Override
    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {
        if(resource.getNode().isNodeType(PortalConstants.JNT_PORTAL_USER)){
            //delete the node
            JCRNodeWrapper modelNode = null;
            try{
                modelNode = portalService.getPortalModel(resource.getNode());
            }catch (Exception e){
                // Model doesn't exist anymore
                return ActionResult.INTERNAL_ERROR_JSON;
            }

            // Delete current portal
            resource.getNode().remove();

            // Copy model
            portalService.initUserPortalFromModel(modelNode, session);
        }
        return new ActionResult(HttpServletResponse.SC_OK, null, new JSONObject());
    }

    public void setPortalService(PortalService portalService) {
        this.portalService = portalService;
    }
}
