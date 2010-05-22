PREFIX ?= /usr/local

main_dir = ${DESTDIR}${PREFIX}
bin_dir = ${main_dir}/bin
man_dir = ${main_dir}/share/man

all: build/comirror.1 build/comirror-setup.1

build/%.1: bin/%
	@echo POD $<
	@mkdir -p build
	@pod2man $< > $@

install: all
	@echo Installing executables to ${bin_dir}
	@echo Installing manuals to ${man_dir}
	@mkdir -p ${bin_dir} ${man_dir}/man1
	@cp bin/comirror       ${bin_dir}/comirror
	@cp bin/comirror-setup ${bin_dir}/comirror-setup
	@cp build/comirror.1       ${man_dir}/man1/comirror.1
	@cp build/comirror-setup.1 ${man_dir}/man1/comirror-setup.1
	@chmod 755 ${bin_dir}/comirror ${bin_dir}/comirror-setup
	@chmod 644 ${man_dir}/man1/comirror.1 ${man_dir}/man1/comirror-setup.1

test:
	@prove test

uninstall:
	rm -f ${bin_dir}/comirror ${bin_dir}/comirror-setup
	rm -f ${man_dir}/man1/comirror.1 ${man_dir}/man1/comirror-setup.1

clean:
	rm -rf build

.PHONY: all clean install test uninstall
