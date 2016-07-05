## 0.1.0

Initial development release.

#### Notes

- Based off [tklx/base:0.1.0](https://github.com/tklx/base/releases/tag/0.1.0).
- MongoDB installed directly from Debian.
- Uses tini for zombia reaping and signal forwarding.
- Uses gosu for dropping privileges to mongodb user.
- Includes ``VOLUME /data/db`` for dbPath persistence.
- Includes ``EXPOSE 27017`` for container linking.
- Basic bats testing suite.

