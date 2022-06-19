# Deploy-Angular-From-Git-To-Azure

# Clone a private Repo and deploy an Angular app on Azure
The PS1 file will provide everything's needed to deploy the Angular app on the Azure's Cloud.
The dockerfile will clone your project thanks to a Personal Access Token, create a container with the minimum required for the Angular App and push the container to Azure.

# Warnings
- For a security measure, I would suggest to create a Personal Access Token with the minimum required.
- If you want to use this code for your company's project, do not write your personal access token directly in your code. 
You can use docker args when you build your image instead, grab a Env Variable or an Azure Key Vault's password for exemple. :grin:

# What to do
- In Azure : Create a resource group.
- In the Powershell : Put your GitHub ID and your GitHub Personal Access Token. You just need the access to clone the project so if you intended to work as a team, create a proper access token. 
- In the Powershell : Put your Angular App's github link in the $Githublink variable.
- In the Powershell : If you want to, change all the variables with the nomenclature "$*Name". Except for $RGName which needs to be changed.
- In the Dockerfile : Retrieve the Nginx and Node version needed for your project. 