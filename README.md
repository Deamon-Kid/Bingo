# Vue based Bingo

Create your own Set of Bingo cards, share the link and play with friends.

## Installation / deployment

### Docker

create a docker-compose-file for current branch

```Yaml
services:
  frontend:
    build: https://github.com/Deamon-Kid/Bingo.git#feature/vue3:frontend
    ports:
      - ${FRONTEND_PORT:-80}:80
    restart: always
```

### Local

Clone this repository, navigate to frontend and run

```
npm ci
npm run build
```
