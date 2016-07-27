## 0.1.1

Install MongoDB from upstream, remove gosu from image, add CircleCI integration.

#### New features

#### Bugfixes

#### Other changes

- readme: added missing links
- Correct indent in entrypoint
- Remove gosu from Dockerfile
- Install mongodb from upstream
- Specify target version through ENV MONGO_VERSION
- Pin mongodb-org packages to mongodb repo
- Add circle.yml
- generate-changelog: make grep case-insensitive
- Update changelog notes, correct typo

## 0.1.0

Initial development release.

#### Notes

- Based off [tklx/base:0.1.0](https://github.com/tklx/base/releases/tag/0.1.0).
- MongoDB installed from official upstream repository.
- Uses tini for zombie reaping and signal forwarding.
- Includes ``VOLUME /data/db`` for dbPath persistence.
- Includes ``EXPOSE 27017`` for container linking.
- Includes ``USER mongodb`` for privilege restriction.
- Basic bats testing suite.

