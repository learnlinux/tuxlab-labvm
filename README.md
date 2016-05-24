# SSHD

Minimal Alpine Linux Docker container with `sshd` exposed and `rsync` installed.

## Usage Example

```
docker build -t tuxlab_sshd .

docker run [-name NAME] -d -p 22 tuxlab_sshd
````
