# nesmon Makefile
################################################################################
# assembler to use
AS = asm6f

################################################################################
# input file
INFILE_MAIN = nesmon.asm

################################################################################
# output directory for binaries and fceux nl files
OUTDIR = ../bin

# output filenames
OUTFILE_NROM = nesmon_nrom.nes
OUTFILE_M100 = nesmon_m100.nes
OUTFILE_FME7 = nesmon_fme7.nes

################################################################################
# ============================================================================ #
# /!\ CUSTOMIZATION SECTION /!\
# ============================================================================ #

# custom character set flag (see doc/charsets.txt and src/charsets_1bpp/charset.asm)
CHARSET_FLAG = CHARSET0

# keyboard module (FAMIBASIC, SUBOR)
KEYBOARD_MODULE = FAMIBASIC

################################################################################
.phony: all clean nrom m100 fme7

all: nrom m100 fme7

# NROM (mapper 000) profile
nrom:
	$(AS) -n -dNROM -d$(CHARSET_FLAG) -dKB_$(KEYBOARD_MODULE) $(INFILE_MAIN) $(OUTDIR)/$(OUTFILE_NROM)

# Nintendulator Debug Mapper (mapper 100) profile
m100:
	$(AS) -n -dM100 -d$(CHARSET_FLAG) -dKB_$(KEYBOARD_MODULE) $(INFILE_MAIN) $(OUTDIR)/$(OUTFILE_M100)

# Sunsoft FME-7 (mapper 069) profile
fme7:
	$(AS) -n -dFME7 -d$(CHARSET_FLAG) -dKB_$(KEYBOARD_MODULE) $(INFILE_MAIN) $(OUTDIR)/$(OUTFILE_FME7)

clean:
	$(RM) $(OUTDIR)/$(OUTFILE_NROM) $(OUTDIR)/$(OUTFILE_M100) $(OUTDIR)/$(OUTFILE_FME7) $(OUTDIR)/*.nl
