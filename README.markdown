# Heroku pgbackups:pull

The `heroku pgbackups:pull` command grabs the latest Heroku PostgreSQL backup
(or another backup specified by id) and loads it into the Rails development
database with `pg_restore`.  It's like `heroku db:pull` but fiftyfold faster.

## Installation

    heroku plugins:install https://github.com/tpope/heroku-pgbackups-pull.git

## License

Copyright © Tim Pope.  MIT License.  See LICENSE for details.
