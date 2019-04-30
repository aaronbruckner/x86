# x86 Assembly Language

This repo contains random asm source as I learn assembly language by following the book: "Assembly Language Step by Step".

## Development Environment
I am using a docker container to compile and execute my 32 bit linux based asm source. 

**Building Image**
```
docker build -t asm_image .
```

**Create & attach to container**
```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -e DISPLAY=host.docker.internal:0 -v ~/source/github/x86:/root/x86 -it -d --name asm asm_image bash

docker attach asm
```

**Restart previous container**
```
docker start asm && docker attach asm
```

**Run GUI DDD from Docker**
You can actually run GUI based applications from your docker container by doing the following (host machine is OSX):

```
brew install socat
brew cask install xquartz
```

On host, to run a GUI app:
```
open -a XQuartz && socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

Now all you have to do is run ```ddd <executable>``` and the GUI application will show on your host. Be sure to use the
`dwarf` debugging format when compiling via nasm.