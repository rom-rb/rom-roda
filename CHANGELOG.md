## v0.0.2 2015-04-05

- Hook `ROM.finalize` into `Roda.freeze` so that ROM environment is sealed at the same time as the Roda app.

## v0.0.1 2015-04-05

- Initial release
- Basic support for autoloading ROM components in given path
- Embed `rom`, `relation` and `command` accessors in Roda instance
