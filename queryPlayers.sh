docker exec -it minecraft rcon-cli list | cut -d' ' -f 3 | cut -d'/' -f 1
