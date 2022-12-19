# expdev
Docker container for Exploit Dev

Based on Ubuntu

Contains 🔻

Tools:
- gdb + pwndbg
- pwntools
- ropper
- patchelf
- pwninit
- capstone
- unicorn

Others:
- python 2 & 3
- vim (with some configs)
- fish shell
- tmux (also configured)

## Build

With the Dockerfile in working directory, run:
```sh
docker build -t expdev .
```

## Run

```
docker run --rm -it -v $PWD:/app expdev
```
