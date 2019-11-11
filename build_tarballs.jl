# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "GSW"
version = v"0.0.1"

# Collection of sources required to build GSW
sources = [
    "http://www.teos-10.org/software/GSW-C-3.05-4.zip" =>
    "ea72c3311f35de42c5e838d05709c3dfd36570c7780629586353ee670ad5f145",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd GSW-C-3.05.0-4/                                          
sed -i 's#/usr#../../destdir/#' GNUmakefile                 
make                                                        
make install 

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgswteos", :libgswteos10),
    ExecutableProduct(prefix, "gsw_check", :libgswcheck)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

