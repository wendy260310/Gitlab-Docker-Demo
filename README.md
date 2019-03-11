# Gitlab-Docker-Demo
Demo about setting up gitlab on docker, include gitlab-ce , gitlab-runner, private docker repo , ci-di examples.

##1. Install Docker
&nbsp;&nbsp;The docker community offers a full [guidance](https://docs.docker.com/install/) about installing docker on different os,you can follow these steps on the guidance.
Read carefully about the section **What to know before you install** if you are mac or windows user.
###1.1 Your first docker application
After installing docker on your machine,you can try some docker command like `docker info` or run a app on docker like `docker run hello-world`.You can get a[*Get Started*](https://docs.docker.com/get-started/)tutorial on the official websites
##2. Run the Gitlab image in Docker Engine
&nbsp;&nbsp;Since this repo is a demo about setting up gitlab, we choose the free version of gitlab.Gitlab community provide us a official doc about how to run gitlab image in docker.
> <span style="color:dark">sudo docker run --detach \
   	--hostname gitlab.example.com \
   	--publish 443:443 --publish 80:80 --publish 22:22 \
   	--name gitlab \
   	--restart always \
   	--volume /srv/gitlab/config:/etc/gitlab:Z \
   	--volume /srv/gitlab/logs:/var/log/gitlab:Z \
   	--volume /srv/gitlab/data:/var/opt/gitlab:Z \
   	gitlab/gitlab-ce:latest</span>

&nbsp;&nbsp;Remember,local locations in volume option(*/srv/gitlab/config* and so on)
depends on your machine,if you don't have these directories,you may change the command above or create these directories manually. &nbsp;
<br/>
&nbsp;&nbsp;Now you can run `docker container ls` to see if gitlab runs,visit `http://localhost` to login to gitlab.

##3.Config Gitlab Runner
###3.1 Run Gitlab Runner in Docker Engine
if you want to set up ci pipeline,you should set up gitlab runner first.[this doc](https://docs.gitlab.com/runner/install/docker.html)
tells us how to run gitlab runner in docker engine.
> docker run -d --name gitlab-runner --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner:Z \
    gitlab/gitlab-runner:latest
    
Pay attention to the directory */srv/gitlab-runner/config*,create it if necessary.
###3.2 Config Runner
&nbsp;&nbsp;Open [gitlab admin page](http://localhost/admin/runners) to get url and token,you need these two to config your gitlab runner.
<br />
&nbsp;&nbsp;login to the gitlab runner docker, you can use `docker container ls` to get the container id of gitlab runner.
>  docker exec -it f28aaf921bf9 /bin/bash

`f28aaf921bf9` is the container id of gitlab runner on my laptop.
