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

