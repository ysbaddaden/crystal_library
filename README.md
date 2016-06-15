# Static/Shared libraries in Crystal

Write C static (or shared) libraries in Crystal. This is just a
[Proof of Concept](https://en.wikipedia.org/wiki/Proof_of_concept) that
exemplifies how to expose a Crystal library to the outside world, eg: C or any
language with bindings to C.

## Build the library

Change `CRYSTAL_ROOT` to match your Crystal distribution (it's `/opt/crystal` by
default on Linux):

    $ make CRYSTAL_ROOT=/opt/crystal

You may now test that it works:

    $ make test

## How does it work?

We need Crystal 0.18.0+ and:

1. Some crystal code. See `src/counter.cr` for a basic example.

2. An API, thankfully written in Crystal to expose the Crystal internals as
proper C functions with symbols that won't be mangled. See `src/libcounter.cr`.
You'll notice that it requires a bunch of boilerplate and casting objects with
Box to exchange references as void pointers with the outside world.

3. A hack to avoid the generation of a `main` function by Crystal, and have an
alternative function that must be manually called from the outside world to
initialize the GC, Crystal constants, etc. See _Hack_ below.

4. A C header to declare the function signatures to C. See `src/counter.h`.

5. Use the library. See examples in `test` and `Makefile` for how to compile and
link them.

## Hack

In order to compile, we need to avoid loading the original `main.cr` from the
Crystal, and replace it with. This PoC does that by hacking the `CRYSTAL_PATH`
environment variable so it references the local `src` folder first. This will
work with distributions of Crystal, but won't from a Git clone of Crystal, which
always overwrites `CRYSTAL_PATH`.
