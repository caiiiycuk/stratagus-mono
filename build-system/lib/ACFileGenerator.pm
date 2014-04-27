package ACFileGenerator;

sub generate {
  my ($stratagus, $projectName, $projectFolder) = @_;

  my $configure = "AC_INIT([$projectName], [1.0], [caiiiycuk\@gmail.com])";
  
  $configure .= <<'CONFIGURE_AC';
AC_PREREQ([2.64])
AM_INIT_AUTOMAKE
LT_INIT
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

PKG_CHECK_MODULES([REQUIRED_LIBS], [sdl])

CXXFLAGS="-g3 -O0 -DUSE_LINUX -DUSE_ZLIB -DPIXMAPS=\\\"share/pixmaps\\\" -fsigned-char"
CFLAGS="-g3 -O0 -DUSE_LINUX -DUSE_ZLIB -DPIXMAPS=\\\"share/pixmaps\\\" -fsigned-char"

AC_OUTPUT

CONFIGURE_AC

  open F, ">encoding(:utf-8)", "configure.ac";
  print F $configure;
  close F;
}

1;