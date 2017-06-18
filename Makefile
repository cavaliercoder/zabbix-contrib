TOPDIR ?= $(shell pwd)

BUCKET = "s3://s3.cavaliercoder.com/zabbix-contrib/"

SYNC = aws s3 sync \
	--exclude="*" \
	--include="*/repodata/*" \
	--include="release/*.tar.gz" \
	--include="rhel/*.rpm" \
	--include="*.deb"

RPM_SUBDIRS = \
	rhel/6/x86_64 \
	rhel/7/x86_64

all: createrepo

createrepo:
	for dir in $(RPM_SUBDIRS) ; do \
		echo createrepo $$dir ; \
		cd $(TOPDIR)/$$dir && createrepo --update . ; \
	done

pull:
	$(SYNC) $(BUCKET) ./

push:
	$(SYNC) ./ $(BUCKET)

.PHONY: all createrepo pull push
