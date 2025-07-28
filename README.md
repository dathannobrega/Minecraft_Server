# Multi-Server Minecraft Deployment

Este repositório contém a configuração atual de um ambiente Minecraft multi-server usando **Velocity** como proxy e três servidores back-end: **Lobby**, **Survival** e **Minigame**. O setup suporta clientes pirata e premium, login único (SSO) e permissões centralizadas via **LuckPerms**.

---

## Infraestrutura

```text
            [ Internet ]
                |
         [Proxy Velocity] (25565)
                |
   ┌───────────┼───────────┐
   |           |           |
[Lobby:25566] [Survival:25567] [Minigame:25568]
 (Paper)       (Paper)         (Paper)
```

Todos os componentes rodam em containers Docker, orquestrados via `docker-compose.yml`. O fluxo de conexão é:

1. Jogador conecta em **porta 25565** → Velocity Proxy.
2. Proxy autentica (pirata ou premium) e encaminha ao Lobby.
3. Do Lobby, usuário pode trocar para Survival ou Minigame.

---

## Principais Arquivos e Configurações

### 1. `docker-compose.yml`

* Usa imagem **openjdk:21-jdk-slim** para todos os serviços.
* Monta volumes:

  * `./Lobby`, `./Survival`, `./Minigame` → `/data` (cada container).
  * `./Velocity` → `/data` para o proxy.
  * `./start.sh` → `/start.sh` para iniciar servidores.
* Expõe porta **25565** (Velocity) e portas **25566–25568** internamente.
* Carrega variáveis do **`.env`** para memória heap dinâmica.

```yaml
services:
  lobby:
    env_file: .env
    image: openjdk:21-jdk-slim
    container_name: mc_lobby
    working_dir: /data
    volumes:
      - ./Lobby:/data
      - ./start.sh:/start.sh:ro
    ports:
      - "25566:25566"
    command: ["bash", "/start.sh", "paper-1.21.jar"]
  # ... survival, minigame, velocity semelhantes ...
```

### 2. `start.sh`

Script único para:

* Gerar `eula.txt` (somente back-ends).
* Ler `MIN_RAM` e `MAX_RAM` do ambiente.
* Iniciar o JAR com `java -Xms${MIN_RAM} -Xmx${MAX_RAM}`.

### 3. `.env`

Define limites de heap Java (mínimo e máximo) para cada serviço:

```dotenv
JAVA_MIN_RAM=512M
JAVA_MAX_RAM=2G

LOBBY_MIN_RAM=512M
LOBBY_MAX_RAM=1G

SURVIVAL_MIN_RAM=1G
SURVIVAL_MAX_RAM=4G

MINIGAME_MIN_RAM=1G
MINIGAME_MAX_RAM=3G

VELOCITY_MIN_RAM=256M
VELOCITY_MAX_RAM=1G
```

### 4. `Velocity/velocity.toml`

Configurações do proxy Velocity:

```toml
bind = "0.0.0.0:25565"
online-mode = false
forwarding-secret-file = "forwarding.secret"
player-info-forwarding-mode = "MODERN"
announce-forge = false
kick-existing-players = false
ping-passthrough = "DISABLED"

[servers]
lobby    = [{ address = "lobby:25566",   motd = "§aLobby",    restricted = false }]
survival = [{ address = "survival:25567", motd = "§2Survival", restricted = false }]
minigame = [{ address = "minigame:25568", motd = "§eMinigame", restricted = false }]
```

* **forwarding.secret**: arquivo contendo uma string secreta compartilhada.

---

## Plugins Instalados

### No Proxy (`Velocity/plugins`)

* **Velocity-Fast-Login.jar**: Auto-login contas premium.
* **AuthMeVelocity-Proxy.jar**: Integração AuthMe com proxy.
* **LuckPerms-Velocity.jar**: Permissões centralizadas.
* **ViaVersion.jar** & **ViaBackwards.jar**: Compatibilidade de versões.
* **ServerSelector** ou **DeluxeMenu-Velocity**: GUI de troca de servidores.

### Nos Servidores Back-end (`*/plugins`)

* **AuthMeReloaded.jar** + **AuthMeVelocity-Paper.jar**: Login único para piratas.
* **LuckPerms-Bukkit.jar**: Permissões centralizadas.
* **Vault.jar**: API de economia/chat.
* **EssentialsX**, **Dynmap**, **QuickShop**, **MiniMOTD**, **Spark**, **VoiceChat**: Funcionalidades diversas.

---

## Permissões & Autenticação

1. **Login único (SSO)**

   * Proxy em **offline-mode=false** para aceitar pirata+premium.
   * Back-ends em **online-mode=false** + `bungeecord=true`.
   * **Velocity-Fast-Login** autentica premium.
   * **AuthMeVelocity** + **AuthMeReloaded** gerenciam login pirata.

2. **Permissões centralizadas**

   * **LuckPerms** configurado em modo **MySQL** (mesmo banco em proxy e back-ends).
   * Gerenciamento via `lp editor` no console do proxy.

---

## Status Atual

* Todos os containers estão **up** e funcionando.
* Login único confirmado para pirata e premium sem comandos extras.
* Heap Java ajustável dinamicamente conforme as variáveis do `.env`.
* Permissões unificadas e propagadas em tempo real.

---

Para mais detalhes em cada arquivo de configuração ou plugin, consulte as respectivas documentações oficiais.
