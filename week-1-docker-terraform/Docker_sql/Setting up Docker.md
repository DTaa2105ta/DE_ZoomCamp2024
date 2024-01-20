If you are in Windows it is recommended to use Git Bash (MinGW) or WSL (Windows subsystem for Linux)

## Docker Run
Once you install docker you can run test if docker is installed properly you can run
`docker run hello-world`
This will
- Go to *[Docker](https://hub.docker.com/)| Docker Hub*, which contains all the images
- Look for the image called `hello-world`
- Once found docker will download the required packages and run the image
- This is pre-installed docker image to test if docker is running properly
run
`docker run -it ubuntu bash`
- `it` means interactive mode
- `ubuntu` is the image you run
- `bash` is the command you are running
Now essentially have a containerized linux commandline inside the commandline you have run the command line in

`rm -rf/` which is essentially like deleting everything from OS you just created. But no worries it is isolated and containerized. Don't try this outside of your computer.

Isolation protects your host computer from stupidity. To exit this container run `exit`

You can run `docker -it run python:3.9` which runs Python version 3,9 in an isolated container in interactive mode

But there is a catch. This command opens the Pythons interactive shell. That means you can not install any Python packages using `pip` as you are still inside the interactive shell. To use the command (or run the application to be exact) pip you have to be in a container also. That means you can not install packages suing this command inside the container.

To install Python Packages, you have to run `docker run -it --entrypoint=bash python:3.9`.
This opens a bash prompt which allows you to use pip as usually you do. After installing the necessary packages you can run the `python` command to get back to the Python Interactive mode and you can import the packages you have installed.

But the problem is that as soon as you leave the container, the installed Python packages gets removed from the container. Because we have restarted the image which didn't not have any Python packages declared into it. So everything we do after the command and exit gets removed. So we need to configure the image
>*Việc "configure" một ảnh Docker thường đề cập đến quá trình cấu hình các tham số và tùy chọn cho một container Docker dựa trên ảnh (image) đã được xây dựng. Mỗi container Docker được tạo ra từ một ảnh Docker, và việc cấu hình container giúp định rõ cách container sẽ chạy và tương tác với môi trường xung quanh.*


## Dockerfile & Docker Build
>Dockerfile
- You can use the `docker images` command to check the list of images available on your machine, use `docker rmi` command to remove an image if you want to build a new one
- Also, you can use the `--no-cache` option with the `docker build` command to force a new build and ignore the cache
		`docker build --no-cache -t test:pandas .`
- Dockerfile is a script that defines the instructions fore creating a Docker Image. It specifies the base image, the environment, and the dependencies that are required by your application. To create a new Dockerfile, you can use a text editor and save it with the name "Dockerfile" (without any file extension)
```Docker
FROM python:3.9

RUN pip install pandas

ENTRYPOINT [ "bash" ]
```
`
`FROM`: declares what kind of the base image you want to use
`RUN`: declares the command you want to run in the command line as soon as the base image is set
`ENTRYPOINT` declares the entry point for the docker image using a list as an argument.
Now to create the container from the Dockerfile run
`docker build -t test:pandas .`
`build` builds an image from the dockerfile
- the command takes the path to the Dockerfile as an argument (.), it will create an image that can be used to start a container
`--tag, -t`Name and optionally a tag in the 'name:tag' format
`.` build the image in this directory
After the `docker build` builds the image from Dockerfile, you can run the container from the image with-
- After building the image, you can use the `docker run` command to start a container from the image. 
	- The command takes take the image name as an argument and it will start the container with the environment and dependencies that are defined in the Dockerfile
`docker run -it test:pandas`
`test:pandas` is the name of the image with the tag
- `-i`: flag stands for "interactive", it keeps the standard input (stdin) open even if it's not attached to the terminal. This allow you to interact with the running containers's command prompt or shell. When running a container interactively, you can provide input to the commands inside the container in real-time
- `-t`: flag stands for "tty"(teletypewriter), this allocates a pseuduo-TTY for the container.
	- A pseudo-TTY is a terminal-like interface that allows you to see the output of commands in a more structured and formatted way
- NOTE:
	- if you run the `docker run` again with the same image name and tag, it will create a new container, not reopen the previous one
	- It runs the command specified in the command parameter, and then exist it. Once container exists, it is stopped and its state is lost, including any changes made inside the container
- `docker ps -a`: command to list all the containers including stopped ones, it shows id or name of containers
	- If you want to keep the state and changes made inside the previous container, you can use the `docker start <containerID>` command to start an existing container
	- After starting, you then need to use the `docker attach` command to attach to the container
	- The container stops running but it is not automatically removed from the system. By default, the container's file system, network settings, and runtime state are all preserved. This allows you to restart the containers again later and pick up where you left off.
![[Pasted image 20240107112829.png]]


### Running a Script in the Container
You can create a file that uses the pandas module and run it on the docker container, 
>pipeline.py
```python
import pandas as pd
# make sure Pandas is being installed properly
print("Pandas installation was successful!!")
```
Modify the dockerfile, this Dockerfile is creating an image based on the official python image version 3.8 and it has three instructions.
```docker
FROM python:3.9

RUN pip install pandas

WORKDIR /app
COPY pipeline.py pipeline.py

ENTRYPOINT ["bash"]
```
`COPY A B` A is source file in the host machine to be copied with the B is the name as the destination file in the image. It can be the same.
`WORKDIR /app` is the working directory where the file pipeline.py would be copied to
Now you can rebuild it, `docker build -it test:pandas .` this will override the previous image

You will see we ae installing the packages from the cache and we are automatically `cd` (chang directory) ed in the `/app` directory. You can run `pwd` (print working directory) and `ls` (list all directory) to verify your present working directory and the existence of pipeline.py


### Passing arguments and Running the Script directly

Now, going to the container running the file isn't self-sufficient i.e. run container > run fire inside container.
A data pipeline needs to be self-sufficient. We can add scheduling to the pipeline and have it run on the specific days.
We can make this scheduling configuration inside the script
>pipeline.py
```python
import sys
import pandas as pd

#sys.argv allows to pass arguments to the script from the commandline
print(sys.argv)

#sys.argv[0]: name of the file 
#sys.argv[1]: first argument passed
day = sys.argv[1]

#Here is the pandas code
print(f"Job finished successfully for day = {day}")
```
You have to also modify the dockerfile
>dockerfile
```docker
FROM python:3.9

RUN pip install pandas

WORKDIR /app
COPY pipeline.py pipeline.py

ENTRYPOINT ["python", "pipeline.py"]
```

We have modified the `ENTRYPOINT` argument to make sure we run the pipeline.py using python as soon as we run the container.
Now, rebuild the dockerfile. To run it -
`docker run -it test:pandas . 2023-01-07`
the `2023-01-07` is the argument we are passing to the pipeline.py as we configured it with `sys.argv`
Now running it runs the pipeline.py files, passes the argument from the command line and exists the container!