Change Log
==========

The format is based on [Keep a Changelog] and this project adheres to
[Semantic Versioning].

Latest Changes
==============

[v0.0.2] - 2017-05-11
---------------------

### Changed

-   reverted to normal versioning

-   tests now employ shpec-helper's `stop_on_error`

-   tests use sorta's `import.bash` to only import defined functions
    from shpec-helper

-   prefer (()) to [let]

### Added

-   explanation in readme that keys must meet bash variable name
    requirements

### Fixed

-   shpecs failing in strict mode due to uninitialized variables and bad
    "read"s

[v0.0.1] - 2017-03-01
---------------------

### Changed

-   refactored expression generation

-   clarified readme

-   updated to shpec-helper from kaizen

Older Changes
=============

[v0.0.0] - 2017-02-20
---------------------

### Added

-   initial version

-   supports arrays, hashes, various single-line forms of scalars

-   supports nesting

-   supports lookup

-   working test suite

  [Keep a Changelog]: http://keepachangelog.com/
  [Semantic Versioning]: http://semver.org/
  [v0.0.2]: https://github.com/binaryphile/y2s/compare/v0.0.1...v0.0.2
  [let]: http://wiki.bash-hackers.org/commands/builtin/let
  [v0.0.1]: https://github.com/binaryphile/y2s/compare/v0.0.0...v0.0.1
  [v0.0.0]: https://github.com/binaryphile/y2s/tree/v0.0.0
