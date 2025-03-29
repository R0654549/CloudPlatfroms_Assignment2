# CloudPlatforms_Assignment2
This school assignment is meant to showcase our growing knowledge with both the use of different cloud platforms, and our understanding of Infrastructure as Code (IaC). In this assignment, we take an application from a GitHub repository and deploy it to a conntainer in Azure.

# Design

# Step 1: Preparing the application
To begin, we take the application from it's repository and turn it into a container image. To do this we use a Dockerfile.
Create a new folder on your system and use the following command:
`git clone https://github.com/gurkanakdeniz/example-flask-crud.git`

Create a new folder on your system and use the following command:
```bash
git clone https://github.com/gurkanakdeniz/example-flask-crud.git
```
Copy the Dockerfile from this repository and paste in the new folder or create a new Dockerfile in the new folder. For the new Dockerfile use:

```Dockerfile
FROM python
ENV FLASK_APP=crudapp.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
WORKDIR /app
COPY . .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN flask db init
RUN flask db migrate -m "entries table"
RUN flask db upgrade
EXPOSE 5000
CMD ["flask", "run"]
```
Now, we're going to use the Dockerfile to create the container image.
In a terminal use the following commands:
```bash
docker build -t <application-name> .
```
This command will build the image from the Dockerfile. Replace `<application-name>` with the name you want to use. For this assignment, we will use the name `svlcrud`, making the command look like this
```bash
docker build -t svlcrud .
```

# Step 2: Infrastructure
## ContainerRegistry
To deploy the image with IaC, we will use Bicep. Bicep is a format created by Microsoft to use with Azure.

To begin, log in to Azure in your terminal. To do this use: 
```bash
az login
```
A pop-up window will appear promting you to select your account.
In the terminal, select your subscription.

First, we create a new resource group for our project.
```bash
az group create -l northeurope -n svlcrud
```
The `-l` tag specifies the lcoation, while the `-n` tag gives the group a name. In this scenario the location is `northeurope` and the name is `svlcrud`.

We use 2 different bicep files to set everything up. We use `registry.bicep` to create the Azure Container Registry, and `deployment.bicep` to set up the container instance.

Use the command:
```bash
az deployment group create --resource-group svlcrud --template-file registry.bicep
```
This will create the registry in Azure, based on the `registry.bicep` file.

Then, we push the container image to the registry. Before we can do this though, we need to tag it first.
```bash
docker tag svlcrud svlacr.azurecr.io/svlcrud 
```
Before pushing it, make sure you're connected to the right registry.
```bash
az acr login --name svlacr
```

Now we can push the tagged image to the registry.
```bash
docker push svlacr.azurecr.io/svlcrud   
```
This may take a while.

To verify, use the command:
```bash
ac acr repository list --name svlacr
```
This will list all images in the repository `svlacr`.
If everything went well, you'll see the image in the list.

## Container Instance
We use `deployment.bicep` to deploy the image to a Azure Container Instance.
This will create a Virtual network with a subnet.