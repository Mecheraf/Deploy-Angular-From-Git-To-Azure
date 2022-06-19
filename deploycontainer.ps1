$GitHubID = "YouId" #For me, it is Mecheraf
$GitHubToken = "YourPersonalAccessToken"

#$AZusername = "YourAzureAccount"
#$AZpassword = "YouSecuredAzurePassword"

$RGName = "Gengoffee" #The ressource group has to be created in Azure. Just copy paste the name.
$acrName = "acrname" #Azure Container Registry Name. No capital letters !
$dockerImageName = "itcanbewhatever" #The docker image on your machine and the Registry Account
$AppServiceName = "AngularAppPlan" #Useful for orgnisation
$ApplicationName = "IAmTheApp" #The name of your Application.
$Githublink = "YourLink" #For example : github.com/Mecheraf/gengoffee-website.git

$path = "."

#Login. You can use the arguments for loging in, otherwise it will open a Browser to enter your credentials.
az login
#az login -u $AZusername -p $AZpassword

#We create an Azure Container Registry. We need to enable the admin user.
az acr create -n $acrName -g $RGName --sku Basic --admin-enabled
#We grab the password of the admin user 
$acrpass = az acr credential show -n $acrName --query passwords[0].value

#We create the AppService plan. 
az appservice plan create -g $RGName -n $AppServiceName --sku FREE --is-linux 

################################## Docker Part ##################################
#Git clone the project. 
git clone "https://${GitHubID}:$GitHubToken@$Githublink" "app"

#Login to docker.
docker login "$acrName.azurecr.io" -u $acrName --password $acrpass

#Building the image.
docker build --pull --rm -f "$path/Dockerfile" -t "$dockerImageName`:latest" .

#Run the detached image 
docker run --rm -it -d -p 3838:3838/tcp $dockerImageName:latest

#Tag and push the image on your Azure Container Registry
docker tag $dockerImageName "$acrName.azurecr.io/$dockerImageName`:latest"
docker push "$acrName.azurecr.io/$dockerImageName"

#Deploy the container on your AppService. You'll get the access link of your app in the returned JSon.
az webapp create -g $RGName -p $AppServiceName -n $ApplicationName -i "$acrName.azurecr.io/$dockerImageName"