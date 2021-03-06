# Inference Model Manager for Kubernetes

[![CircleCI](https://circleci.com/gh/IntelAI/inference-model-manager.svg?style=svg)](https://circleci.com/gh/IntelAI/inference-model-manager)

*Inference Model Manager for Kubernetes* is an open source SW platform intended to provide convenient solution for 
hosting, management and scaling inference processing endpoints exposed over gRPC protocol.

It is built on top of Kubernetes and integrates with TensorFlow Serving* and OpenVINO Model Server* for exposing the 
inference services via gRPC endpoints.

It is intended for organizations who dynamically deploy and scale inference endpoints.
- Users are organized into tenants
- Multiple tenants are supported with “soft” isolation

Inference Model Manager for Kubernetes includes a custom REST API which simplifies the configuration and management of hosted inference services.
Inference Model Manager integrates with Minio or other S3 compatible components used for storage of the AI models.

Inference Model Manager for Kubernetes conjoins inference services scalability and easy management with 
security features like:
- limiting access to inference endpoints to authorized clients only
- preventing unauthorized access to management API
- limiting access to tenant data based on group membership information from external identity provider.

Fully customizable serving templates provide predefined and optimized Kubernetes configurations of inference services.
It ensures well tuned performance with maximum simplicity on the users side. Templates can enable additional model servers
or adjust them to application needs and the infrastructure configuration.

[Installation quicksheet (beta)](docs/exampleinstallation.md)

[Architecture overview](docs/architecture.md)

[Prerequisites and requirements](docs/prerequisites.md)

[Building platform components](docs/building.md)

[Deployment guide](docs/deployment.md)

[Platform admin guide](docs/platform_admin_guide.md)

[Platform user guide](docs/platform_user_guide.md)

[Example grpc client](examples/grpc_client)

[Security recommendation for Kubernetes](docs/security_recommendations.md)

[Troubleshooting](docs/troubleshooting.md)

[Serving templates](docs/serving_templates.md)

[Troubleshooting](docs/troubleshooting.md)


## Collaboration
By contributing to the project software, you agree that your contributions will be licensed under the Apache 2.0 license
that is included in the LICENSE file in the root directory of this source tree. 
The user materials are licensed under CC-BY-ND 4.0.

## Contact
Submit Github issue to ask a question, submit a request or report a bug.