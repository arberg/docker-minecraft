# docker-minecraft
PC Java Minecraft docker images

(My) Scripts for creating a docker minecraft server based on https://hub.docker.com/r/itzg/minecraft-server/ docker images


https://www.youtube.com/results?search_query=pondus+plus+plus

## Hjælp en ven i nøden :)

Nedenstående er skrevet til en ven, men måske kan andre få nytte af det...


Kør f.eks. for en meget tung fuld modded minecraft server baseret på minecraft 1.12 (modpack fil mangler nok, se alle nederst)

```
ftbRevelation.sh create
```

eller for en native minecraft 1.13 server

```
pondusPlusPlus.sh create
```

Du skal slette world data hvis du ønsker at ændre seed. Hvis server.properties er oprettet i underfolder `/data*`, skal du rette seed i den i stedet for ovennævnte filer. Seed er kun relevant, hvis du vil have en bestemt verden.

ONLINE_MODE=false
betyder at serveren ikke kræver login via officiel server, så du kan bruge samme login med flere konti. Alle skal dog have forskelligt navn, hvilket rettes i filen `d:\Games\Curse\Minecraft\Install\launcher_profiles.json` (fordi jeg har curse installeret her).

Det er lidt noget bøvl at lave en client til den server du får lavet. Jeg har gjort det at jeg starter serveren, og så henter den alle modpacks. Så henter jeg twitch og installere minecraft i den. Se her hvordan eller læs nedenstående 'get pondus client':  https://www.youtube.com/watch?v=Ptv-acTGyM0 

Og for at gøre det ondt, så er der nogle modpacks på serveren som ikke virker på en client, og de skal så fjernes, se 'Remove client-only mods from server' nedenfor. 


Mht. PondusModded har jeg disabled nogle mods, som gav problemer: Hats og HatStand.

Dragon Mounts til v1.10 er for cool, men gav desværre også problemer: http://www.9minecraft.net/dragon-mounts-mod/

Hvis du vil gøre det nemt for dig selv, så starter du med native minecraft 1.13 uden mods. Der har du vel allerede klienten.

Og interesserede piger kender vel allerede pondus plus plus, men hvis ikke så værsgod
https://www.youtube.com/results?search_query=pondus+plus+plus 



# Gamle noter til mig selv jeg lavede da jeg installerede Pondus Modded server



- Get Pondus client

- - [Install Twitch App](file://tower/cache/app/dockerhub/itzg-minecraft-server/forgeModdedMinecraft.sh) (its possible to change install location in advanced)

  - In Twitch

  - - In top-level Tab 'Mods' > search for Minecraft

    - Search for 'Pondus' in 'Browse all modpacks'

    - Pondus > Install (its  possible to change install location)

    - After install view profile, and adjust memory (recommended to max)

    - - Freezing problem: Could it be garbage collection? F3 to view memory, see [memory-leak](https://www.minecraftforum.net/forums/support/java-edition-support/2576773-memory-leak-hits-max-memory-then-freezes)
      - Giving it more memory (4.5 GB) resolved problem with freezing every few seconds. Then it came back         few days later, I had 4700MB memory, windows used 7.7/7.9, closing chrome released 700MB, and freezing was reduced from 5. sec to every 20-30. sec, restarted with 5.2 GB and no more problem. F3 says it uses  between 3200 mb (69%) - 4360 mb (90%), GC'ing not noticable, it seems         likely it would hit 100% before

- Install [itzg's Docker server](https://hub.docker.com/r/itzg/minecraft-server/)

- - [\\tower\cache\app\dockerhub\itzg-minecraft-server\forgeModdedMinecraft.sh](file://tower/cache/app/dockerhub/itzg-minecraft-server/forgeModdedMinecraft.sh)

  - - Forged Version: When opening the pondus client there's a Forged version-number on the play-button. It should match the forged version in minecraft docker. The        
    - Minecraft Version: Check [forged](https://files.minecraftforge.net/) to see which minecraft version matched the forged version. The minecraft version is in the left table. When selecting a minecraft version, it shows the matching forge-versions (see under 'Download Latest').

  - Copy all pondus files "d:\Games\Curse\Minecraft\Instances\Pondus Modded" to server data dir

  - - Maybe need only: scripts, config, mods

    - Remove client-only mods from server. 

    - - journeymap-1.10.2-5.5.2
      - CustomBackgrounds-MC1.9.4-1.1
      - Debugging: When starting server look for 'Caused by: java.lang.NoClassDefFoundError:         net/minecraft/client/gui/Gui' in data/crash-reports or data/logs

    - If running on Linux Server

    - - It is not necessary to change windows newlines to unix-style         (*.conf;*.hjson;*.html;*.xml;*.ini;*.config;*.cfg;*.properties;*.json;*.zs;*.txt;*.recipe;*.recipes;*.csv;*.xsd|*.jar;*.dat;*.tbl;*.jpg;*png)

      - Change the following files to lowercase (not necessary, but avoids duplicate files with only case-         differences)

      - - config/CompactSolars.cfg
        - config/SolarFluxReborn (the folder name)

- Connect to server

- - Open pondus client, login to your server (select multiplayer, enter ip-address of the pc hosting the       docker container).

- How to connect to servers with same useraccount multiple times

- - <https://gaming.stackexchange.com/questions/148409/can-two-users-play-on-a-minecraft-server-using-the-same-account>

  - - in Docker data/server.properties

    - - online-mode=false

      - seed=2305120 (delete world after changing seed to regenerate world)

      - - (or put in docker command '-e seed=2305120' and delete server.properties)

    - Edit display-name in d:\Games\Curse\Minecraft\Install\launcher_profiles.json

    - - Setting read-only cause Twitch to complain about setting profile. Logging in probably updates         file.
      - After opening minecraft launcher from Twitch, check profile name in top right corner

- How to run FTB mod pack

  - Download FTB modpack via Twitch client
  - I'm not quite sure how to match it to server, but downloading the corresponding server modpack from https://www.feed-the-beast.com/projects/ should do. Update ftbRevelation.sh and point to downloaded modpack file.

Kitematic Docker Minecraft

- <https://blog.docker.com/2015/06/minecraft-server-docker-1/>