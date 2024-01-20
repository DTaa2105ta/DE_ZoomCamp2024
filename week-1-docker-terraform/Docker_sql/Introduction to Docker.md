
[[https://www.youtube.com/watch?v=EYNwNlOrpr0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=4|Link to the Docker video]] 

1. Keywords: 
- Docker
- Docker Image
- Data pipeline
- Advantages of Docker
- Reproducibility
- Integration tests

Docker delivers software in packages in called *containers*
	These containers are ==isolated== to from one another 
If we run a data pipeline inside a container it is virtually isolated from the rest of the things running on the computer.
- **Data pipeline**: Get in Data -> Process Data -> Generates more Data!
![[Pasted image 20240107100330.png]]
Docker allows to run multiple databases and multiple operations in isolated environment inside the same host computer without creating conflict.

- *pgAdmin* allows you to communicate with the *Postgresdb*
Advantages of docker is reproducibility, which allows you to create a docker image which is a snapshot (literally and in the technical sense) of your environment that contains instructions to set up an isolated docker environment.
![[Pasted image 20240107101211.png]]

We can run the container we have created through the docker image where we have specified and configured the environment beyond the computer and essentially everywhere like - Google Cloud (Kubernetes), AWS Batch, etc.
Docker image ensures reproducibility regardless of the machine as the images are identical. We can specify OS, programming languages, packages, databases type, tools, etc. This solves the problem of *"Works on my computer but NOT IN YOURS"* 
Why care about Docker:
	- Local Experiments: Helps to run things locally like your databases also help with testing like integration testing.
	- Integration Tests (CI/CD)
	- Reproducibility: Docker makes things run everywhere regardless of what you are using
	- Running pipelines on the Cloud (AWS Batch, Kubernetes Jobs)
	- Spark
	- Serverless (AWS Lambda, Google Functions)
*Integration testing is the phrase in SWE software testing in which individual software modules are combined and testes as a group*

2. Sum up
*Docker is a platform and tool for building, shipping, and running distributed applications. It allows devs to package an application with all of its dependencies into a single container, which can be run on any system with eh Docker runtime installed*
- Additionally, Docker can be used to create and deploy data-processing pipelines, allowing teams to easily scale up or down  their processing capacity as needed