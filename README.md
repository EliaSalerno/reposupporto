# Dockerized Visual Paradigm

Run Visual Paradigm from a Docker container.

I try to run a clean system, and Visual Paradigm did not fit that idea. Additionally the installer just seems sketchy, a +2 million line, +600MB shell script where most of the content can't be reviewed raises too many red flags. Running a Windows VM to run a single program is just way too much hassle.

So I set out to run Visual Paradigm from a Docker container. It's not been heavily used by myself just yet so your mileage may vary. If you are not using the VPository with a regular push to the repository I strongly suggest backing up your data. But you were already doing that, right?

## Build

To build the Docker image:

```bash
docker build -t vp .
docker run --name vp-install -it vp ./install.sh
docker commit -m "installed Visual Paradigm" $(docker ps -a | grep 'vp-install' | awk '{ print $1 }') vp
```

This repo is not intended to distribute Docker images with Visual Paradigm but rather allowing anyone to build a Docker image, install Visual Paradigm and run it from a container. So let's unpack this.

First, we build the image that will allow us to install Visual Paradigm starting with a vanilla Debian base image and adding packages required to run the installer and program.

Next, we'll run the installer. The download and install process is wrapped in a helper script. As the Visual Paradigm installer requires a bunch of user input this cannot be automated in the `Dockerfile`, well it probably could but [it doesn't seem worth the time](https://xkcd.com/1205/). Additionally there's likely licenses in place that would be violated if we were to repack and distribute the software.

Step through the installer, confirm default options etc. Once the installation is completed, the changes made on the container are committed to the image. The docker image is now updated with an installed copy of Visual Paradigm and ready to run.

## Run

### Linux

Local data from the host system (`$HOME/.config/VisualParadigm`) is shared with the container.
For locally stored files (non-repository assets), consider mounting an additional directory as included in the example below (host: `./vp-desktop` to container: `~Desktop`) if you prefer alternative storage to `$HOME/.config/VisualParadigm/ws/VPProjects`.

#### X server

Note that you may need to run `xhost local:docker` to grant docker access to X server.

#### Example

```bash
xhost local:docker && \
docker run -it \
  -v $HOME/.config/VisualParadigm:/root/.config/VisualParadigm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $(pwd)/vp-desktop:/root/Desktop \
  -e DISPLAY=$DISPLAY \
  vp \
  /usr/local/bin/Visual_Paradigm
```

### macOS

Untested.

### Windows

Untested.

## Tested versions

This setup has been tested with the following releases and setups.

| Version | Build | License | OS | Comment |
| --- | --- | --- | --- | -- |
| 16.0 | `20191102` | Subscription | GNU/Linux | Older version |
| 16.1 | `20191102` | Subscription | GNU/Linux | Current version |

## Known issues

* Slow download of the installer. There seem to be various locations from where the VP install script will be download, some slower than others. If progress is too slow, abort the installation, remove the container and re-run. Chances are good you'll receive the VP install scripts from another, faster server.
* Selecting the evaluation option from the initial splash screen (for the default install) might kill the running process.
* Web-based diagrams (Infographic, Process Map, Cloud Service Architecture) fail to load ([WD0002](https://knowhow.visual-paradigm.com/error-code/wd0002/)) despite the instructed package being installed.
* In case some issues prevent the container from running properly on GNU/Linux, you might want to try going overboard with volumes and environment variables and find the cause of the issue by process of elimination. The following `docker run` command should mitigate the most common process killers. Should be fine to run, but run at your own risk.

```bash
docker run -it \
  -v $HOME/.config/VisualParadigm:/root/.config/VisualParadigm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /tmp:/tmp \
  -v /var/run/dbus:/var/run/dbus \
  -v $HOME/.Xauthority:/root/.Xauthority \
  -v $(pwd)/vp-desktop:/root/Desktop \
  -v /var/run/user/$(id -u):/var/run/user/$(id -u) \
  --device=/dev/dri:/dev/dri \
  -e DISPLAY=$DISPLAY \
  -e XAUTHORITY=/home/.Xauthority \
  -e NO_AT_BRIDGE=1 \
  vp \
  /opt/Visual_Paradigm_16.1/bin/Visual_Paradigm
```

## Aknowledgements & docs

* [jessfraz](https://github.com/jessfraz) work was a solid reference for getting the `docker run` just right.
* [Using hardware acceleration with Docker](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration)
* [Visual Paradigm legal info](https://www.visual-paradigm.com/aboutus/legal.jsp).
