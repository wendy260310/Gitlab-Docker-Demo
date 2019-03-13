# Gitlab-Docker-Demo
&nbsp;&nbsp;Demo about setting up gitlab on docker, include gitlab-ce , gitlab-runner, private docker repo , ci-di examples.

## 1. Install Docker
&nbsp;&nbsp;The docker community offers a full [guidance](https://docs.docker.com/install/) about installing docker on different os,you can follow these steps on the guidance.
Read carefully about the section **What to know before you install** if you are mac or windows user.
### 1.1 Your First Docker Application
&nbsp;&nbsp;After installing docker on your machine,you can try some docker command like `docker info` or run a app on docker like `docker run hello-world`.You can get a [*Get Started*](https://docs.docker.com/get-started/) tutorial on the official websites
## 2. Run the Gitlab Image in Docker Engine
&nbsp;&nbsp;Since this repo is a demo about setting up gitlab, we choose the free version of gitlab.Gitlab community provide us a official doc about how to run gitlab image in docker.
> sudo docker run --detach \
   	--hostname docker.for.mac.host.internal \
   	--publish 443:443 --publish 80:80 --publish 22:22 \
   	--name gitlab \
   	--restart always \
   	--volume /srv/gitlab/config:/etc/gitlab:Z \
   	--volume /srv/gitlab/logs:/var/log/gitlab:Z \
   	--volume /srv/gitlab/data:/var/opt/gitlab:Z \
   	gitlab/gitlab-ce:latest

&nbsp;&nbsp;Remember,local locations in volume option(*/srv/gitlab/config* and so on)
depends on your machine,if you don't have these directories,you may change the command above or create these directories manually. &nbsp;
<br/>
&nbsp;&nbsp;Now you can run `docker container ls` to see if gitlab runs and visit [gitlab homepage](http://localhost) to login to gitlab.

## 3.Config Gitlab Runner
### 3.1 Run Gitlab Runner in Docker Engine
&nbsp;&nbsp;If you want to set up ci pipeline,you should set up gitlab runner first.[this doc](https://docs.gitlab.com/runner/install/docker.html)
tells us how to run gitlab runner in docker engine.
> docker run -d --name gitlab-runner --restart always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /srv/gitlab-runner/config:/etc/gitlab-runner:Z \
    gitlab/gitlab-runner:latest
    
&nbsp;&nbsp;Pay attention to the directory */srv/gitlab-runner/config*,create it if necessary.
### 3.2 Config Runner
&nbsp;&nbsp;Open [gitlab admin page](http://localhost/admin/runners) to get url and token,you need these two to config your gitlab runner.
<br />
&nbsp;&nbsp;Login to the gitlab runner docker, you can use `docker container ls` to get the container id of gitlab runner.
>  docker exec -it f28aaf921bf9 /bin/bash

`f28aaf921bf9` is the container id of gitlab runner on my laptop.

&nbsp;&nbsp;After you have logged in the container,you can config your gitlab runner now.
>gitlab-runner register -n   --url http://docker.for.mac.host.internal    --registration-token ${your token}   --executor docker   --description "My Docker Runner"   --docker-image "docker:latest"   --docker-volumes /var/run/docker.sock:/var/run/docker.sock

&nbsp;&nbsp;You want to access host machine's localhost in a docker container(gitlab runner),but `http://localhost` seems  not working on mac,so  use `docker.for.mac.host.internal` instead.You may find more info in [this question](https://stackoverflow.com/questions/31324981/how-to-access-host-port-from-docker-container/43541732).
<br />
&nbsp;&nbsp;Now you can go to [gitlab admin page](http://localhost/admin/runners) again to see if the runner has been registered or not.
### 3.3 Build Customer Gitlab Runner Image
&nbsp;&nbsp;If we use the official gitlab runner image,we need to login to the container and configure our gitlab runner.We can build our customer image to config gitlab runner when container start.Go to [Gitlab Runner Customer Image](https://github.com/wendy260310/Gitlab-Docker-Demo/tree/master/Gitlab-Runner-Customer-Image) and build our gitlab runner image.When you run our customer image,you will find that a new runner was added to our gitlab in the [admin page](http://localhost/admin/runners).
<br/>
&nbsp;&nbsp;Don't forget to change the token in `entry.sh`. You can get more info [here](https://hub.docker.com/r/gitlab/gitlab-runner/dockerfile),don't forget options when you run your customer image,it means you just replace `gitlab/gitlab-runner:latest` with your image id.If you forgot to add these options,you may get error like *Cannot connect to the Docker daemon*,more info could found [here](https://stackoverflow.com/questions/53968749/cannot-connect-to-the-docker-daemon-at-unix-var-run-docker-sock-in-gitlab-ci).
## 4.Set Up Private Docker Repository
&nbsp;&nbsp;We need to set up our private docker repository if we want to build our app in one container and deploy our app in another container.[this tutorial](https://docs.docker.com/registry/deploying/) shows us the command to set up a local docker repository
> docker run -d -p 5000:5000 --restart=always --name registry registry:2

## 5.Your First Gitlab Application
Now,after steps above,we started to create a gitlab application,build and deploy it.
### 5.1 Create Application
&nbsp;&nbsp;Go to [new project](http://localhost/projects/new) and choose the `Create from template` tab,we choose spring app as our demo.
<br />
&nbsp;&nbsp;After creating a new application,you can clone,update it like your repo in the github.[gitlab-app](https://github.com/wendy260310/Gitlab-Docker-Demo/tree/master/gitlab-app) is the app I use to test gitlab ci stage,you can copy this to your local gitlab repo.

### 5.2 Use Customer Maven Repo
&nbsp;&nbsp;If you want to use your own maven repo when build your applications,you can add a `settings.xml` file in your application's root directory,and add parameter `--settings settings.xml` to your build command in `gitlab-ci.yml`,also you can change your `gitlab-ci.yml` like [this](https://stackoverflow.com/questions/33430487/how-to-use-gitlab-ci-to-build-a-java-maven-project/44951105#44951105),google more use cases about `before_script` stage.
### 5.3 Where My Application  Deployed
&nbsp;&nbsp;If you use docker to deploy your application,you may be confused about where did gitlab deploy my application,did it run docker in my gitlab runner container? Congratulations! you meet the problem *Docker In Docker*,you can google for this or see this [post](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/).Pay attention to the options when we run `gitlab-runner`.
<br />
&nbsp;&nbsp;Go to the terminal of your laptop and run `docker container ls`,you will found out your application!
### 5.4 Deploy Stage Run Forever
&nbsp;&nbsp;Gitlab runner did not know whether your application start or not,see this [issue](https://gitlab.com/gitlab-com/support-forum/issues/1622),so I add `&` when start my spring boot application.In fact,if you do like what I did,your application did not start though your deploy stage finished.