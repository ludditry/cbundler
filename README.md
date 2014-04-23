# cbundler #

our team has a need to be able to "source deploy" c applications.

this is basically a venv builder for c applications -- download a
tarball of a c application, drop it in a directory, rewrite rpath, and
symlink bins and init scripts back to the "venv".

it's pretty rudamentary, but it appears to work.

requires 'patchelf'.
