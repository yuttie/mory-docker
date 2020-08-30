# Docker Image for mory

This repository includes files necessary for building an integrated Docker
image for mory.
A built image will contain both the
[frontend](https://github.com/yuttie/mory) and
[backend](https://github.com/yuttie/moried).



## Quick Start

You can try out mory with a pre-built Docker image as follows assuming your
note repository is located at `/path/to/git/repo`:

```shell
docker run -it --rm -v /path/to/git/repo:/notes -p 8080:80 yuttie/mory
```

Please open http://localhost:8080/ after launching a container, and you would be
able to login the system with the username `user` and the password `password`.

To use a different user account, you need to build your own image from scratch
as we see in the next section.



## Build Your Own Image

### Assumption

* mory will be served at `http://localhost:8080/`
* Git repository for notes is located at `/path/to/git/repo`
* Docker image will be named `mory`


### Dotenv files

First, edit `.env.moried` and `.env.mory` for your needs.
These files are provided with example values, which are solely appropriate for testing purpose.

Most of the time, you are interested in secret values and account settings found in `.env.moried`.
Please leave other values as they are here.

With the default values, you can login with the username `user` and the password `password`.
Email address will be used solely for the purpose of loading a Gravatar image.


### Update Git submodules

Second, fetch submodules.
This repository contains two Git submodules `mory` and `moried`.

```shell
git submodule init
git submodule update
```


### Build a Docker image

Third, build an image.

```shell
docker build -t mory .
```


### Launch a container using the built image

Last, launch a mory container from the image.

```shell
docker run -it --rm -v /path/to/git/repo:/notes -p 8080:80 mory
```

Now you should be able to access mory via http://localhost:8080/ .
