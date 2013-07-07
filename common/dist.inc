#
# This file lists the files that are to be included in source distributions
# Assumes PACKAGE_DIR is valid
#
COMMONFILES = $(PACKAGE_DIR)/common/getopt.c $(PACKAGE_DIR)/common/loader.c $(PACKAGE_DIR)/common/rxpack.c \
              $(PACKAGE_DIR)/common/defines.h $(PACKAGE_DIR)/common/rxdef.h $(PACKAGE_DIR)/common/rxpack.h \
              $(PACKAGE_DIR)/common/*.rexx $(PACKAGE_DIR)/common/*.nsh $(PACKAGE_DIR)/common/*.m4 \
              $(PACKAGE_DIR)/common/*.bmp $(PACKAGE_DIR)/common/*.png $(PACKAGE_DIR)/common/*.ico \
              $(PACKAGE_DIR)/common/dist.inc $(PACKAGE_DIR)/common/filterexports.rexx $(PACKAGE_DIR)/common/fixrc.rexx
ZIPCOMMONFILES = ./common/getopt.c ./common/loader.c ./common/rxpack.c \
                 ./common/defines.h ./common/rxdef.h ./common/rxpack.h \
                 ./common/*.rexx ./common/*.nsh ./common/*.m4 \
                 ./common/*.bmp ./common/*.png ./common/*.ico \
                 ./common/dist.inc ./common/filterexports.rexx ./common/fixrc.rexx
