# Containerised Hornbill Azure User Import tool

Work in progress!

See: <https://github.com/hornbill/goAzure2HUserImport>

## Store Configuration in Azure App Configuration

See: <https://docs.microsoft.com/en-us/azure/azure-app-configuration>

Fill out the required fields in the json configuration file and copy the contents into a new key called 'BasicUserSync'

Minimum required fields in addtion to example conftemplate.json:

* APIKey
* InstanceId
* AzureConf.Tenant
* AzureConf.ClientID
* AzureConf.ClientSecret
* AzureConf.UsersByGroupID.ObjectID
* AzureConf.UsersByGroupID.Name

## Building with ACR

Login az cli or use cloud shell...

```sh
git clone 'https://github.com/WebedMJ/Hornbill-Az-Import'
cd '/home/<username>/Hornbill-Az-Import'
ACR_NAME=myacr
az acr build --registry $ACR_NAME --platform windows --image hornbillazimport:v1 .
```

Note trainling '.' for source location!

Pass following environment variables to container at runtime:

* cfguri -> URL for Azure App Configuration (<https://myappconfig.azconfig.io>)
* cfgid -> Azure App Configuration Access Key Id
* cfgsecret -> Azure App Configuration Access Key Secret
* cfgkey -> Azure App Configuration Key name to retrieve json config

Readonly access key is sufficient

## Additional resources

[Tutorial: Build and deploy container images in the cloud with Azure Container Registry Tasks](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task) - also shows using service principals and keyvault.