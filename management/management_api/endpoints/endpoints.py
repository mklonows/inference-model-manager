import falcon
from falcon.media.validators import jsonschema

from management_api.utils.logger import get_logger
from management_api.authenticate import get_namespace

from management_api.endpoints.endpoint_utils import create_endpoint, delete_endpoint, \
    scale_endpoint, update_endpoint, view_endpoint, list_endpoints
from management_api.schemas.endpoints import endpoint_post_schema, endpoint_delete_schema, \
    endpoint_patch_schema


logger = get_logger(__name__)


class Endpoints(object):
    def on_get(self, req, resp, tenant_name):
        namespace = get_namespace(tenant_name)
        endpoints = list_endpoints(namespace)
        resp.status = falcon.HTTP_200
        resp.body = endpoints

    @jsonschema.validate(endpoint_post_schema)
    def on_post(self, req, resp, tenant_name):
        namespace = get_namespace(tenant_name)
        body = req.media
        endpoint_url = create_endpoint(parameters=body, namespace=namespace)
        resp.status = falcon.HTTP_200
        resp.body = 'Endpoint created\n {}'.format(endpoint_url)

    @jsonschema.validate(endpoint_delete_schema)
    def on_delete(self, req, resp, tenant_name):
        namespace = get_namespace(tenant_name)
        body = req.media
        endpoint_url = delete_endpoint(parameters=body, namespace=namespace)
        resp.status = falcon.HTTP_200
        resp.body = 'Endpoint {} deleted\n'.format(endpoint_url)


class EndpointPatch(object):

    def patch(self, parameters, namespace):
        pass

    @jsonschema.validate(endpoint_patch_schema)
    def on_patch(self, req, resp, tenant_name, endpoint_name):
        namespace = get_namespace(tenant_name)
        body = req.media
        body['endpointName'] = endpoint_name
        endpoint_url = self.patch(parameters=body, namespace=namespace)
        body.pop('endpointName')
        message = 'Endpoint {} patched successfully. New values: {}\n'.format(endpoint_url, body)
        resp.status = falcon.HTTP_200
        resp.body = message
        logger.info(message)


class EndpointScale(EndpointPatch):
    def patch(self, parameters, namespace):
        return scale_endpoint(parameters, namespace)


class EndpointUpdate(EndpointPatch):
    def patch(self, parameters, namespace):
        return update_endpoint(parameters, namespace)


class EndpointView(object):
    def on_get(self, req, resp, tenant_name, endpoint_name):
        namespace = get_namespace(tenant_name)
        endpoint = view_endpoint(endpoint_name=endpoint_name, namespace=namespace)
        resp.status = falcon.HTTP_200
        resp.body = endpoint
