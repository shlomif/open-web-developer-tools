# How to build the site.

## Dependencies:

1. [Latemp](https://bitbucket.org/shlomif/latemp) and
[Website Meta Language](https://bitbucket.org/shlomif/website-meta-language) .
2. [Emscripten](https://kripken.github.io/emscripten-site/)
3. [CMake](https://cmake.org/)
4. [GNU Make](https://www.gnu.org/software/make/)
5. Some [CPAN](http://metacpan.org/) Modules.
6. The [TypeScript](http://www.typescriptlang.org/) tsc compiler.
7. Possibly other stuff.

## Build procedure.

1. `./gen-helpers.pl`
2. `make`
3. `make test`
