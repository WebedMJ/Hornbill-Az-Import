# Containerised Hornbill Azure User Import tool

Work in progress!

See: <https://github.com/hornbill/goAzure2HUserImport>

## Building with ACR

Login az cli or use cloud shell...

```sh
git clone 'https://github.com/WebedMJ/Hornbill-Az-Import'
cd '/home/<username>/Hornbill-Az-Import'
ACR_NAME=myacr
az acr build --registry $ACR_NAME --platform windows --image hornbillazimport:v1 .
```