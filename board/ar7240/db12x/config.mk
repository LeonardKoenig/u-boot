# ROM version
ifdef BOOT_FROM_NAND
TEXT_BASE = 0xa0100000
else
ifeq ($(COMPRESSED_UBOOT),1)
TEXT_BASE = 0x80010000
#  Date: 2011-030-21 
#  Name: Charles Teng
#  Reason: patch from LSDK-9.2.0.303
#	   WASP 1.1 support
BOOTSTRAP_TEXT_BASE = 0x9f000000
else
#  Date: 2011-030-21 
#  Name: Charles Teng
#  Reason: patch from LSDK-9.2.0.303
#	   WASP 1.1 support
TEXT_BASE = 0x9f000000
endif
endif
# TEXT_BASE = 0xbf000000

# SDRAM version
# TEXT_BASE = 0x80000000

# RAM version
# TEXT_BASE = 0x83fc0000
# TEXT_BASE = 0x80100000
