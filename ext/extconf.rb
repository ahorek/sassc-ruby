# frozen_string_literal: true

gem_root = File.expand_path('..', __dir__)
libsass_dir = File.join(gem_root, 'ext', 'libsass')

if !File.directory?(libsass_dir) || Dir.entries(libsass_dir).empty?
  Dir.chdir(gem_root) { system('git submodule update --init') }
end

File.write 'Makefile', <<-MAKEFILE
ifndef DESTDIR
	LIBSASS_OUT = #{gem_root}/lib/sassc/libsass.so
else
	LIBSASS_OUT = $(DESTDIR)$(PREFIX)/libsass.so
endif

SUB_DIR := #{libsass_dir}
SUB_TARGET := lib/libsass.so

libsass.so:#{' clean' if ENV['CLEAN']}
	$(MAKE) -C '$(SUB_DIR)' lib/libsass.so
	cp '$(SUB_DIR)/lib/libsass.so' libsass.so

install: libsass.so
	cp libsass.so '$(LIBSASS_OUT)'

clean:
	$(MAKE) -C '$(SUB_DIR)' clean
	rm -f '$(LIBSASS_OUT)' libsass.so

.PHONY: clean install
MAKEFILE
