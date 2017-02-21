y2s
===

y2s stands for "YAML2Struct". It is a handful of bash functions for
parsing a limited subset of YAML into a makeshift bash nested data
structure.

The structure, or "struct" for short, is a hash which contains keys for
all of the leaf elements in the YAML source document, along with a
slightly custom syntax for storing all of the intermediate levels of the
structure as well.

For example, consider the following `demo.yml` file:

    myhash:
      one: 1
      two: 2
    myarray:
      - zero
      - one

Using the function `yml2struct` to store the result in a hash called
`hash` looks like this:

    $ source y2s.bash
    $ declare -A hash
    $ yml2struct hash demo.yml

The resulting `hash` looks like so:

    hash[myhash]='([one]="1" [two]="2" )'
    hash[myhash.one]="1"
    hash[myhash.two]="2"
    hash[myarray]='([0]="zero" [1]="one" )'
    hash[myarray.0]="zero"
    hash[myarray.1]="one"

Notice that the scalar values are available via the keys which specify
their full paths (although this is not the recommended method, see
below):

    $ echo "${hash[myarray.0]}"
    zero

The non-scalar values are still stored as strings, however they are
serialized as the right-hand side of an assignment statement. For
example, this is not the recommended way of accessing such values, but
you could do this:

    $ eval "array=${hash[myarray]}"
    $ echo "${array[0]}"
    zero

Since these methods of accessing the values are somewhat clunky, there
is a convenience function, called `lookup`, which allows you to use
dotted notation to access values and substructures.

If it is given the name of a variable as its second argument, it stores
the value there, otherwise it echoes the value:

    $ lookup hash.myhash.one
    1

    $ unset -v array
    $ declare -a array
    $ lookup hash.myarray array
    $ echo "${array[0]}"
    zero

    $ declare -A myhash
    $ lookup hash.myhash myhash
    $ echo "${myhash[one]}"
    1

Using `lookup` to instantiate a hash with nested structures also
preserves the embedded structures, so the result is itself a struct.
This means you can instantiate and then use subportions of the data
structure with the `lookup` function as well.

Instantiating an array, if supported, would lose the embedded structure
data since it is not capable of using complex string-based keys. At the
moment, `lookup` doesn't support this with arbitrary subtrees, but you
can instantiate a flat array into an array variable with it.

However, you may instead use a hash as the variable into which an array
structure would be stored and it will act the same as an array (for the
most part) but will also still be a struct.

Installation
------------

Requires Bash 4.3 or higher.

y2s depends on the [nano] library. Follow its installation instructions,
then clone y2s and put its `lib` directory on your PATH.

Then you may source it in your scripts with `source y2s.bash`.

Limitations
-----------

y2s understands hashes and arrays, in addition to scalar values.

y2s supports nesting arrays in hashes and vice-versa.

y2s understands plain, single- and double-quoted scalars. It strives for
compatibility with Ruby's syck implementation as a guide.

y2s only accepts indents of two space characters per level.

y2s only allows printable characters in values (including whitespace).

y2s only supports a very limited subset of YAML. It currently
understands only single-lined values, although it does understand
double-quoted syntax which allows the use of escaped characters such as
`\n`.

y2s does not understand the JSON forms of keys, hashes or arrays.

Because y2s denormalizes the yml data, copying the same value into
multiple locations, it is only suitable for reading data. Writing data
into a struct would require updating all of the locations in which that
data appears. I have no plans for implementing such support.

y2s does not support converting structs to yml, nor writing yml files,
and there are no plans for such support.

y2s has no feedback on errors which occur during parsing at the moment.
The best thing to try is to pass the same input through a real parser,
and to keep the aforementioned limitations in mind.

Shouts-Out
----------

y2s is inspired by [YAY] and the Stack Overflow articles cited by YAY.

  [nano]: https://github.com/binaryphile/nano
  [YAY]: https://github.com/johnlane/random-toolbox/blob/master/usr/lib/yay
