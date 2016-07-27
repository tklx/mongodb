# tklx/mongodb - NoSQL database

[MongoDB][mongodb] (from "humongous") is a scalable, high-performance
document-oriented NoSQL database system. Instead of storing data in
tables as is done in a "classical" relational database, MongoDB stores
structured data as JSON-like documents with dynamic schemas, making
integration with certain types of applications easier and faster.

## Features

- Based on the super slim [tklx/base][base] (Debian GNU/Linux).
- MongoDB installed from official upstream repo.
- Uses [tini][tini] for zombie reaping and signal forwarding.
- Includes ``VOLUME /data/db`` for dbPath persistence.
- Includes ``EXPOSE 27017``, so standard container linking will make it
  automatically available to the linked containers.
- Includes ``USER mongodb`` to restrict the privileges of mongod.

## Usage

### Start a mongodb instance and connect to it from an application

```console
$ docker run --name some-mongo -d tklx/mongodb
$ docker run --name some-app --link some-mongo:mongo -d app-that-uses-mongo
```

### Authentication and Authorization

MongoDB does not require authentication by default, but it can be
configured to do so. For more details about the functionality described
here, please see the sections in the official documentation which
describe [authentication][mongo_authentication] and
[authorization][mongo_authorization] in more detail.

```console
$ docker run --name some-mongo -d tklx/mongodb --auth

$ docker exec -it some-mongo mongo admin
connecting to: admin
> db.createUser({ user: 'some-user', pwd: 'some-pass', roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ] })
Successfully added user: {
        "user" : "some-user",
        "roles" : [
                {
                        "role" : "userAdminAnyDatabase",
                        "db" : "admin"
                }
        ]
}

$ docker run -it --rm --link some-mongo:mongo tklx/mongodb \
     mongo -u some-user -p some-pass --authenticationDatabase admin \
     some-mongo/some-db
connecting to: some-mongo/some-db
> db.getName()
some-db
```

### Tips

```console
# mongo client options
$ docker run --rm tklx/mongodb mongo --help

# mongod options
$ docker run --rm tklx/mongodb --help

# while testing
$ docker run --name test-mongo -d tklx/mongodb --smallfiles --noprealloc
```

## Status

Currently on major version zero (0.y.z). Per [Semantic Versioning][semver],
major version zero is for initial development, and should not be considered
stable. Anything may change at any time.

## Issue Tracker

TKLX uses a central [issue tracker][tracker] on GitHub for reporting and
tracking of bugs, issues and feature requests.

[mongodb]: http://www.mongodb.org
[base]: https://github.com/tklx/base
[tini]: https://github.com/krallin/tini
[mongo_authentication]: https://docs.mongodb.com/manual/tutorial/enable-authentication/
[mongo_authorization]: https://docs.mongodb.org/manual/core/authorization/
[semver]: http://semver.org/
[tracker]: https://github.com/tklx/tracker/issues

