# Windows Palworld Dedicated Server Docker
*Windows version of the Palworld Dedicated Server docker image*


## How to use

### Docker Compose

```yaml
services:
  palworld:
    restart: always
    container_name: palworld-windows
    image: windows/windows-palworld-server-docker:latest
    env_file:
      - .env
    networks:
      - default
    volumes:
      - ./palworld:/palworld
      - /etc/machine-id:/etc/machine-id:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "8211:8211/udp"
      - "25575:25575/tcp"
      # - "8212:8212/tcp" # uncomment if REST_API_ENABLED is set to True
```



## Build Locally

```
cp default.env .env
vi .env
docker compose up
```

## Credits

* https://github.com/NewittAll/modded-palworld-docker-server
* https://github.com/Dekita/palhub-server
* https://github.com/thijsvanloef/palworld-server-docker