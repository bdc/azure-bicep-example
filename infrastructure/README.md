# Infrastructure

This directory and subdirectories contain infrastructure specifications for deploying cloud software items.

## Deployment notes

To deploy from a local VS Code instance:
- Use the [Bicep VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- `main.bicep` is the entrypoint for deployment. 

## Implementation notes

- *Application Service Hosting Environment* (ASE or ASEv3)
  - ASE takes [several hours to deploy](https://learn.microsoft.com/en-us/azure/app-service/environment/how-to-create-from-template), whether deployed from a template, the Azure UI, or CLI.
  - Deploying ASE from a template does not support private endpoint creation, most likely [due to a bug](https://github.com/Azure/bicep/issues/6101), and so this step must be taken from the Azure UI or CLI during a new deployment.
    - The workaround is to use the Azure UI to allow new private endpoints from the ASE, after its deployment completes, then add the private endpoint
  - Integrations between ASE and other Azure components are complicated by the fact that ASE is not widely used, meaning community support is not as widely available.
  - Despite these complications, ASE may still be worth using because of its single-tenant nature ([compared to standard App Service without a dedicated environment](https://learn.microsoft.com/en-us/azure/app-service/environment/ase-multi-tenant-comparison)), giving our application physical separation from other uses.

## Further reading

- [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview)
- [Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep), a declarative language for interacting with ARM
- [Bicep GitHub page](https://github.com/Azure/bicep)
- [Internal overview of Azure services](https://echoneurotech.sharepoint.com/:w:/r/sites/Softwaredevelopment/Shared%20Documents/General/Software%20system/Design%20decisions/Cloud%20Software%20Component%20-%20Azure%20Offerings.docx?d=w1ee9b68b6cab49708b37252684955b04&csf=1&web=1&e=g3qXls)
- [Echo Connect Prototype resource group](https://portal.azure.com/#@echo.bio/resource/subscriptions/24ecc076-39d2-495b-bef2-d210b5a16503/resourceGroups/echo-connect-prototype/overview) in Microsoft Azure web portal
- [Bicep tools](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#vs-code-and-bicep-extension)
