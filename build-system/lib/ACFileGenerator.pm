package ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder, $buildType) = @_;

  my $configure = "AC_INIT([$projectName], [1.0], [caiiiycuk\@gmail.com])";
  
  $configure .= <<'CONFIGURE_AC';
AC_PREREQ([2.64])
AM_INIT_AUTOMAKE
LT_INIT
${CFLAGS=""}
${CXXFLAGS=""}
AC_PROG_CXX([g++ clang++])
AC_CONFIG_MACRO_DIR([m4])
AC_LANG([C++])
AX_CXX_COMPILE_STDCXX_11([])
AC_CHECK_HEADERS([stdlib.h sys/time.h unistd.h], ,AC_MSG_ERROR("Some headers not found."))
AC_CHECK_FUNCS([gettimeofday localtime_r pow], ,AC_MSG_ERROR("Some functions not found."))
AC_HEADER_STDBOOL
AC_C_INLINE
AC_PROG_CC
AC_PROG_LN_S

AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_TYPE_SIZE_T
AC_TYPE_UINT8_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T

AC_CONFIG_FILES([Makefile])

AC_CHECK_FUNCS([strcpy_s],,)
AC_CHECK_FUNCS([strncpy_s],,)
AC_CHECK_FUNCS([strcasestr],,)
AC_CHECK_FUNCS([strnlen],,)
AC_CHECK_FUNCS([getopt],,)

SDL_VERSION=1.2.0
AM_PATH_SDL($SDL_VERSION, : , AC_MSG_ERROR([*** SDL version $SDL_VERSION not found!]))
CFLAGS="$CFLAGS $SDL_CFLAGS"
CXXFLAGS="$CXXFLAGS $SDL_CFLAGS"
LIBS="$LIBS $SDL_LIBS -lvorbis -logg"

AC_ARG_ENABLE(debug,
AS_HELP_STRING([--enable-debug],
               [enable debugging, default: no]),
[case "${enableval}" in
             yes) debug=true ;;
             no)  debug=false ;;
             *)   AC_MSG_ERROR([bad value ${enableval} for --enable-debug]) ;;
esac],
[debug=false])
AM_CONDITIONAL(DEBUG, test x"$debug" = x"true")

CXXFLAGS="$CXXFLAGS -DUSE_LINUX -DUSE_ZLIB -DPIXMAPS=\\\"share/pixmaps\\\" -fsigned-char"
CFLAGS="$CFLAGS -DUSE_LINUX -DUSE_ZLIB -DPIXMAPS=\\\"share/pixmaps\\\" -fsigned-char"

AC_OUTPUT

CONFIGURE_AC

  open F, ">encoding(:utf-8)", "configure.ac";
  print F $configure;
  close F;
}

1;