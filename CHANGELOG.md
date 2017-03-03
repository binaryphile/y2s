Change Log
==========

The format is based on [Keep a Changelog] and this project adheres to
[Semantic Versioning], with the minor exception that v10 is considered
v0 in semver parlance.

[Unreleased]
------------

### Added

-   explanation in readme that keys must meet bash variable name
    requirements

### Changed

-   tests now employ shpec-helper's `stop_on_error`

-   tests use sorta's `import.bash` to only import defined functions
    from shpec-helper

-   prefer (()) to [let]

[v10.10.11] - 2017-03-01
------------------------

### Changed

-   refactored expression generation

-   clarified readme

-   updated to shpec-helper from kaizen

[v10.10.10] - 2017-02-20
------------------------

### Added

-   initial version

-   supports arrays, hashes, various single-line forms of scalars

-   supports nesting

-   supports lookup

-   working test suite

  [Keep a Changelog]: http://keepachangelog.com/
  [Semantic Versioning]: http://semver.org/
  [Unreleased]: https://github.com/binaryphile/y2s/compare/v10.10.11...v10.10
  [let]: http://wiki.bash-hackers.org/commands/builtin/let
  [v10.10.11]: https://github.com/binaryphile/y2s/compare/v10.10.10...v10.10.11
  [v10.10.10]: https://github.com/binaryphile/y2s/tree/v10.10.10
