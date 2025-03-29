# CloudPlatforms_Assignment2
This school assignment is meant to showcase our growing knowledge with both the use of different cloud platforms, and our understanding of Infrastructure as Code (IaC). In this assignment, we take an application from a GitHub repository and deploy it to a conntainer in Azure.

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


