# Makefile for building LibreOffice/OpenOffice extensions

EXTENSIONNAME=ExpandAnimations
VERSION=$(shell xmlstarlet sel -N oo="http://openoffice.org/extensions/description/2006" -t -v "//oo:version/@value" extension/description.xml)

all:
	make extension/ExpandAnimations/ExpandAnimations.xba
	cd extension; zip -r ../dist/$(EXTENSIONNAME)-$(VERSION).oxt .
	echo yes | sudo unopkg add --verbose dist/$(EXTENSIONNAME)-$(VERSION).oxt
	xvfb-run libreoffice 'vnd.sun.star.script:ExpandAnimations.ExpandAnimations.test?language=Basic&location=application'

extension/ExpandAnimations/ExpandAnimations.xba:
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo '<!DOCTYPE script:module PUBLIC "-//OpenOffice.org//DTD OfficeDocument 1.0//EN" "module.dtd">' >> $@
	echo '<script:module xmlns:script="http://openoffice.org/2000/script" script:name="ExpandAnimations" script:language="StarBasic">' >> $@
	perl -MHTML::Entities -ne 'print encode_entities($$_)' $^ >> $@
	echo '</script:module>' >> $@

