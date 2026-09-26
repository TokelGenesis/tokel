package=libcurl
$(package)_version=8.22.0
$(package)_dependencies=openssl
$(package)_download_path=https://curl.se/download
$(package)_file_name=curl-$($(package)_version).tar.gz
$(package)_sha256_hash=d54dd598bf05927a726deb38df31c6a255ba83ff1de57c5d1464dac3ed8f44a1
$(package)_config_opts=--with-openssl --disable-shared --enable-static --prefix=$(host_prefix)
$(package)_config_opts+=--without-libpsl --without-libidn2 --without-zstd --without-nghttp2 --without-nghttp3
$(package)_config_opts+=--without-librtmp --without-brotli --without-libssh2 --disable-ldap --disable-ldaps
$(package)_config_opts_linux=--host=$(HOST)
$(package)_config_opts_mingw32=--enable-mingw --host=x86_64-w64-mingw32
$(package)_config_opts_darwin=--without-libidn2 --without-zstd --without-nghttp2 --without-librtmp --without-brotli
$(package)_cflags_darwin=-mmacos-version-min=$(OSX_MIN_VERSION)
$(package)_conf_tool=./configure

ifeq ($(build_os),darwin)
define $(package)_set_vars
  $(package)_build_env=MACOSX_DEPLOYMENT_TARGET="$(OSX_MIN_VERSION)"
endef
endif

ifeq ($(build_os),linux)
define $(package)_set_vars
  $(package)_config_env=LD_LIBRARY_PATH="$(host_prefix)/lib" PKG_CONFIG_LIBDIR="$(host_prefix)/lib/pkgconfig" CPPFLAGS="-I$(host_prefix)/include" LDFLAGS="-L$(host_prefix)/lib"
endef
endif


define $(package)_config_cmds
  echo '=== config for $(package):' && \
  echo '$($(package)_config_env) $($(package)_conf_tool) $($(package)_config_opts)' && \
  echo '=== ' && \
  $($(package)_config_env) $($(package)_conf_tool) $($(package)_config_opts) 
endef

ifeq ($(build_os),darwin)
define $(package)_build_cmds
  $(MAKE) CPPFLAGS="-I$(host_prefix)/include -fPIC" CFLAGS="-mmacos-version-min=$(OSX_MIN_VERSION)"
endef
else
define $(package)_build_cmds
  $(MAKE)
endef
endif

define $(package)_stage_cmds
  echo 'Staging dir: $($(package)_staging_dir)$(host_prefix)/' && \
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef
