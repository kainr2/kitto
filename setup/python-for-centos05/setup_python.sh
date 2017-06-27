#!/bin/sh

################################################################################
## This script will install required OS packages for compiling, installing,
## and running python on Centos 5 and Centos 6.
## It assumes there is at least bc, gcc, gcc-dev, core, etc.
##
## SETUP (before running):
## * Set MYROOT variable
##
## TODO:
## * Download packages for offline installation
##
################################################################################
## The root folder for all the different libraries
export MYROOT='/tmp/myopt'
export PKG_DIR="${MYROOT}/package"

## Additional settings.  Add to bashrc as needed.
## Need to export these settings, since some compilations invokes a diff shell
export PATH="$MYROOT/bin:$PATH"
export LD_LIBRARY_PATH="$MYROOT/lib:$MYROOT/lib64:$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="$MYROOT/include:$C_INCLUDE_PATH"
export LDFLAGS="-L$MYROOT/lib -L$MYROOT/lib64"
export CFLAGS="-fPIC"



## Addition to bashrc
export MORERC_FILE="${MYROOT}/morerc"
BASHRC=$(cat <<MORE
if [ -f "${MORERC_FILE}" ]; then
    source ${MORERC_FILE}
fi;
MORE)

## morerc file content
MORERC_DATA=$(cat <<"MORE"
\n## Use local settings first
\nexport PATH="$MYROOT/bin:$PATH"
\nexport LD_LIBRARY_PATH="$MYROOT/lib:$MYROOT/lib64:$LD_LIBRARY_PATH"
\nexport C_INCLUDE_PATH="$MYROOT/include:$C_INCLUDE_PATH"
\nexport LDFLAGS="-L$MYROOT/lib -L$MYROOT/lib64"
\nexport CFLAGS="-fPIC"
\n
MORE)

################################################################################

function runcmd()
{
    local COMMAND=$1

    echo "  \$ ${COMMAND}"
    eval ${COMMAND}
    local STATUS=$?
    if [ "${STATUS}" != "0" ]; then
        echo "FAILED executing: ${COMMAND}";
        exit ${STATUS}
    fi;
}


## Check basic paths
function check_settings()
{
    if [ ! -d "${MYROOT}" ]; then
        echo "PATH not found: ${MYROOT}";
        exit 1;
    fi;

    # Create a subdir for packages
    mkdir -p "${PKG_DIR}"
    if [ ! -d "${PKG_DIR}" ]; then
        echo "Cannot create directory: ${PKG_DIR}";
        exit 1;
    fi;
}


## Download needed libraries
function download_libs()
{
    runcmd "wget -nc https://www.openssl.org/source/openssl-1.0.2g.tar.gz --no-check-certificate"
    runcmd "wget -nc http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"

    runcmd "wget -nc http://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz"
    runcmd "wget -nc http://zlib.net/zlib-1.2.8.tar.gz"
    runcmd "wget -nc http://ftp.gnu.org/gnu/readline/readline-6.3.tar.gz"

    runcmd "wget -nc https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz --no-check-certificate"
    runcmd "wget -nc https://bootstrap.pypa.io/get-pip.py --no-check-certificate"

    runcmd "wget -nc ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.bz2"
    runcmd "wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/pcre-8.38-upstream_fixes-1.patch"
    runcmd "wget -nc https://sourceforge.net/projects/swig/files/swig/swig-3.0.8/swig-3.0.8.tar.gz --no-check-certificate"

    runcmd "wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"

    runcmd "wget -nc http://www.astro-wise.org/instantclient/instantclient-basic-linux-x86-64-11.2.0.2.0.zip"
    runcmd "wget -nc http://www.astro-wise.org/instantclient/instantclient-sdk-linux-x86-64-11.2.0.2.0.zip"

    chmod 775 *
}


function install_openssl()
{
    ## openssl -- compile with so to given dir
    ## https://wiki.openssl.org/index.php/Compilation_and_Installation    
    # Extract and overwrite
    local FILE=$(ls | grep openssl*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF openssl* | grep "openssl.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "./config shared --openssldir=$MYROOT"
    runcmd "make depend -j4"
    runcmd "make -j4 && make install"
    runcmd "popd"
}


function install_bzip2()
{
    ## bzip2/bz2
    ## http://stackoverflow.com/questions/15910219/how-to-manually-pass-source-of-bzip2-install-for-python-install
    # Extract and overwrite
    local FILE=$(ls | grep bzip2*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF bzip2* | grep "bzip2.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "make -f Makefile-libbz2_so"
    runcmd "make && make install PREFIX=$MYROOT"
    runcmd "cp -a libbz2.so.* $MYROOT/lib"
    runcmd "popd"
}

function install_ncurses()
{
    ## http://www.linuxfromscratch.org/lfs/view/development/chapter06/ncurses.html
    ## https://geeksww.com/tutorials/operating_systems/linux/tools/how_to_download_compile_and_install_gnu_ncurses_on_debianubuntu_linux.php
    # Extract and overwrite
    local FILE=$(ls | grep ncurses*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF ncurses* | grep "ncurses.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "./configure --prefix=$MYROOT --with-shared --enable-widec"
    runcmd "make -j4 && make install"
    runcmd "popd"
}

function install_zlib()
{
    # Extract and overwrite
    local FILE=$(ls | grep zlib*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF zlib* | grep "zlib.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "./configure --prefix=$MYROOT"
    runcmd "make -j4 && make install"
    runcmd "popd"
}

function install_readline()
{
    # Extract and overwrite
    local FILE=$(ls | grep readline*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF readline* | grep "readline.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "./configure --prefix=$MYROOT"
    runcmd "make -j4 && make install"
    runcmd "popd"
}

function install_pcre()
{
    ## pcre for swig
    ## http://www.linuxfromscratch.org/blfs/view/svn/general/pcre.html
    # Extract and overwrite
    local FILE=$(ls | grep pcre*.bz2)
    tar jxvf ${FILE}

    local PATCH=$(ls | grep pcre*.patch)
    if [ ! -f "${PATCH}" ]; then
        echo "ERROR: File not found -- pcre patch file"
        exit 1;
    fi;

    # Enter and compile
    local SUBDIR=$(ls -dF pcre* | grep "pcre.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "patch -Np1 -i ../${PATCH}"
    runcmd "./configure --prefix=$MYROOT --docdir=$MYROOT/share/doc/pcre-8.38 --enable-unicode-properties --enable-pcre16 --enable-pcre32 --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-pcretest-libreadline --disable-static 
"
    runcmd "make -j4 && make install"
    runcmd "popd"
}

function install_swig()
{
    ## swig
    ## http://www.linuxfromscratch.org/blfs/view/svn/general/swig.html
    # Extract and overwrite
    local FILE=$(ls | grep swig*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF swig* | grep "swig.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd "./configure --prefix=$MYROOT --without-clisp --without-maximum-compile-warnings"
    runcmd "make -j4 && make install"
    runcmd "install -v -m755 -d $MYROOT/share/doc/swig-3.0.8 && cp -v -R Doc/* $MYROOT/share/doc/swig-3.0.8"
    runcmd "popd"
}

function install_libffi()
{
    ## libffi
    ## http://www.linuxfromscratch.org/blfs/view/svn/general/libffi.html
    # Extract and overwrite
    local FILE=$(ls | grep libffi*.gz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF libffi* | grep "libffi.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"
    runcmd $'sed -e \'/^includesdir/ s/$(libdir).*$/$(includedir)/\' -i include/Makefile.in'
    runcmd $'sed -e \'/^includedir/ s/=.*$/=@includedir@/\' -e \'s/^Cflags: -I${includedir}/Cflags:/\' -i libffi.pc.in'
    runcmd "./configure --prefix=$MYROOT --disable-static"
    runcmd "make && make check && make install"
    runcmd "popd"
}

function install_oracle_instantclient()
{
    ## Check if ORACLE instant client already exist
    # if [ -n "${ORACLE_HOME}" ]; then
    #     echo "NOTE: ORACLE_HOME already exist.  Not installing ORACLE instant client"
    #     return 0;
    # fi;

    ## Install oracle instant client
    ## https://gist.github.com/kimus/10012910
    unzip instantclient-basic-linux-*.zip
    unzip instantclient-sdk-linux-*.zip

    local ORACLE_DIR=$(ls -dF instantclient* | grep "instantclient.*/")
    runcmd "mv ${ORACLE_DIR} ${MYROOT}/"
    runcmd "pushd ${MYROOT}/${ORACLE_DIR}"
    runcmd "ln -sf libclntsh.so.*  libclntsh.so"
    runcmd "popd"
}


DUMMY=$(cat <<"PYCOMMENTS"
----- Modules/Setup.dist -----
# Uncomment and update this section
SSL=$MYROOT
_ssl _ssl.c \
	-DUSE_SSL -I$(SSL)/include -I$(SSL)/include/openssl \
	-L$(SSL)/lib -lssl -lcrypto

# Uncomment for zlib
zlib zlibmodule.c -I$(prefix)/include -L$(exec_prefix)/lib -lz
------------------------------
PYCOMMENTS)

function install_python()
{
    ## python
    ## http://stackoverflow.com/questions/5937337/building-python-with-ssl-support-in-non-standard-location
    ##
    ## NOTE: For "dl" module in python, install glibc-devel (centos) or libc6-dev-i386 (ubuntu), then re-compile.
    ##       To find the necessary bits, look in setup.py in detect_modules() for the module's name.
    ##
    # Extract and overwrite
    local FILE=$(ls | grep Python*.tgz)
    tar zxvf ${FILE}

    # Enter and compile
    local SUBDIR=$(ls -dF Python* | grep "Python.*/")
    echo "SUBDIR is ... '${SUBDIR}'"
    runcmd "pushd $SUBDIR"

    # Escaped path for sed
    # Must escape parenthesis for sed's regex group
    local SED_MYROOT="${MYROOT//\//\\/}"
    runcmd "sed -e \"s/^#\(SSL=.*\)/SSL=${SED_MYROOT}/\" -i Modules/Setup.dist"
    runcmd "sed -e 's/^#\(_ssl.*\)/\1/'  -e 's/^#\(\t-DUSE_SSL.*\)/\1/'  -e 's/^#\(\t-L$(SSL).*\)/\1/' -i Modules/Setup.dist"
    runcmd "sed -e 's/^#\(zlib*\)/\1/' -i Modules/Setup.dist"
    runcmd "./configure --prefix=$MYROOT"
    runcmd "make -j4 && make install"
    runcmd "popd"

    # Symlink openssl path for swig
    # * http://stackoverflow.com/questions/33317770/how-to-provide-include-path-to-swig
    runcmd "ln -s ${MYROOT}/include/openssl ${MYROOT}/include/python2.7/openssl"
}

function install_pip()
{
    ## python install pip
    ## http://python-packaging-user-guide.readthedocs.org/en/latest/installing/
    runcmd "python get-pip.py"
    runcmd "pip install virtualenv"
}

function update_bashrc()
{
    # Check if morerc file is already there...
    if [ -f "${MORERC_FILE}" ]; then
        echo "File already exist: ${MORERC_FILE}";
        return 0;
    fi;

    # Check for oracle-home
    local ORACLE_DIR=$(ls -dF ${MYROOT}/instantclient* | grep "instantclient.*/")
    if [ -n "${ORACLE_DIR}" ]; then
        MORERC_DATA+="\n### Oracle path"
        MORERC_DATA+="\nexport ORACLE_HOME=${ORACLE_DIR}"
        MORERC_DATA+="\nexport LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$ORACLE_HOME"
        MORERC_DATA+="\n"
    fi;

    # Append the required env vars, then remove prefix spaces...
    MORERC_DATA="export MYROOT=${MYROOT}\n\n${MORERC_DATA}"
    runcmd "echo -e '$MORERC_DATA' >> ${MORERC_FILE}"
}




check_settings
runcmd "pushd ${PKG_DIR}"
download_libs
install_openssl
install_bzip2
install_ncurses
install_zlib
install_readline
install_pcre
install_swig
install_libffi
install_oracle_instantclient
install_python
install_pip
update_bashrc
runcmd "popd"

echo "*** DONE ****"
echo "* Add these settings to bashrc and source it"
echo "-------------------------------------------"
echo "${BASHRC}"
echo "-------------------------------------------"


