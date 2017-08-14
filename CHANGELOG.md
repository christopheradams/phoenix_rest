# Changelog

## v0.6.0
* Enhancements
  * [Generator] Make compatible with Phoenix 1.3.0 directory structure.

## v0.5.0
* Enhancements
  * Add mix generator task compatible with Phoenix 1.3.0-rc directory structure.

## v0.4.2
* Bug Fixes
  * Phoenix will no longer give 404 errors for not implemented methods.

## v0.4.1
* Enhancements
  * Add documentation to resource template

## v0.4.0

* Enhancements
  * The `resource` macro is tested to work with any Plug module
  * The `resource` macro will accept the same options as Phoenix
    Router's `match` macro

* Backwards incompatible changes
  * A Resource plug's options are passed directly as the `state`. In
    resource routes, change any `state: true` to just `true`.
  * `known_methods` defaults can be changed in the application config,
    and are no longer an option for the Router or Resource plugs

## v0.3.1

* Bug fixes
   * Specify Phoenix version 1.1 or 1.2

## v0.3.0

* Enhancements
  * `Plug.Debugger` will show errors raised in resources

* Bug fixes
   * Fix dialyzer warning in mix task

## v0.2.1

* Enhancements
  * Relax Phoenix version requirement to >= 1.1.0

## v0.2.0

* Enhancements
  * Add `known_methods` option to the router
  * Add Mix task to generate a resource module
  * Add `PhoenixRest.Resource` to wrap `PlugRest.Resource` and provide
    documentation
