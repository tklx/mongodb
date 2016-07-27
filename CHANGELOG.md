## 0.2.0

Install MongoDB directly from upstream (security).

#### Notes

- MongoDB is now installed directly from upstream (version 3.2).

    - Debian introduced an exception to their security support policy
      for [libv8 and node](https://www.debian.org/releases/stable/amd64/release-notes/ch-information.en.html#libv8):

    ```
    The Node.js platform is built on top of libv8-3.14, which experiences
    a high volume of security issues, but there are currently no volunteers
    within the project or the security team sufficiently interested and
    willing to spend the large amount of time required to stem those
    incoming issues.

    Unfortunately, this means that libv8-3.14, nodejs, and the associated
    node-* package ecosystem should not currently be used with untrusted
    content, such as unsanitized data from the Internet.

    In addition, these packages will not receive any security updates during
    the lifetime of the Jessie release.
    ```

- Builds are now automated via CircleCI.

    - Images tagged with ``latest`` are built from the master branch.
    - Images tagged with ``x.y.z`` refer to signed tagged releases.

- Gosu was removed, leveraging Docker USER directive instead.

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

