docker run -ti --rm \
       --name ubuntu18 \
       -e DISPLAY=$DISPLAY \
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       ubuntu18:latest
