# GENERIC MAKEFILE
# It is not supposed to be modified to suite a particular project
# A project can customize some aspect of the build by defining some symbols and including this file in the end.


DEBUG?=0

NOSTARTFILES?=0
REBUILD_BY_DEFAULT?=1

winpath2unix_core = $(shell echo '$(1)/' | sed -E 's_\<(.):_/\l\1_g; s_\\_/_g')
fixpath = $(realpath $(call winpath2unix_core,$(1)))/

-include $(HOME)/.csp/user_hook.mk

# Path to csp_root i.e. parent of CSP.md
# If not defined, we assume we are in a target specific project, so go 3 levels up
CSP_ROOT ?= ../../../

# Normalize all input paths
csp_root = $(call fixpath,$(CSP_ROOT))

$(info INFO: csp_root               = $(csp_root))

-include $(csp_root)user_hook.mk

include $(csp_root)generic/makefiles/helpers.mk

sdk_short_name=$(SDK_SHORT_NAME)
sdk_generic_short_name=$(SDK_GENERIC_SHORT_NAME)
sdk_long_name=$(SDK_LONG_NAME_PREFIX)$(SDK_SHORT_NAME)
sdk_generic_long_name=$(SDK_LONG_NAME_PREFIX)$(SDK_GENERIC_SHORT_NAME)
csp_target_root=$(csp_root)$(sdk_generic_long_name)/

-include $(csp_target_root)user_hook.mk
$(shell )
$(info INFO: DEBUG                 = $(DEBUG))
$(info INFO: current working dir.  = $(shell pwd))
$(info INFO: sdk_long_name         = $(sdk_long_name))
$(info INFO: csp_target_root       = $(csp_target_root))

include $(csp_target_root)makefiles/$(sdk_short_name).mk
include $(csp_target_root)makefiles/$(sdk_long_name).mk
load_ihex=$(call $(sdk_long_name)_load_ihex,$1)

$(info INFO: sdk_root              = $(sdk_root))
$(info INFO: target_toolchain_path = $(target_toolchain_path))



# Experimental options: basically works but not compatible with the -Map option of the linker
# So for now we do not recommend to use that.
    # BUILD_PATH
    # Define where to write build output files. BUILD_PATH=build by default.
    # WARNING: the "clean" operation will erase the $(BUILD_PATH)/obj directory even if it contains files unrelated to this build
    #BUILD_PATH=C:\Temp\builddir

BUILD_PATH?=build/
ifneq ($(BUILD_PATH),build/)
$(warning WARNING: Custom BUILD_PATH, this is experimental, we noticed that linker has problem with that)
endif

build_path:=$(call winpath2unix,$(BUILD_PATH))
build_artifact_name:=$(build_path)$(PROJECT_NAME)
$(info INFO: build_path            = $(build_path))
$(info INFO: build_artifact_name   = $(build_artifact_name))



TARGET_OBJCOPY = $(target_toolchain_path)bin/$(TOOLCHAIN_PREFIX)-objcopy
TARGET_OBJDUMP = $(target_toolchain_path)bin/$(TOOLCHAIN_PREFIX)-objdump
TARGET_CC=$(target_toolchain_path)bin/$(TOOLCHAIN_PREFIX)-gcc
TARGET_ELF2SIZE=$(target_toolchain_path)bin/$(TOOLCHAIN_PREFIX)-size

sources := $(call recurfind,src,*.c) $(call recurfind,src,*.cpp) $(call recurfind,src,*.S)
-include $(csp_target_root)makefiles/$(sdk_short_name)_sources_hook.mk
$(info INFO: sources               = $(sources))

OBJS_PATH=$(build_path)obj/
OBJS := $(sources)
OBJS := $(OBJS:.c=.o)
OBJS := $(OBJS:.cpp=.o)
OBJS := $(OBJS:.S=.o)
OBJS := $(OBJS:..=beurk)
OBJS := $(addprefix $(OBJS_PATH),$(OBJS))

DEPS := $(patsubst %.o,%.d,$(OBJS))
#$(info DEPS=$(DEPS))

$(info INFO: TMP                   = $(TMP))

INC  += -I$(csp_target_root)includes -I$(csp_root)generic/includes
#LIBS = 
LIBSINC += -L$(csp_target_root)libs 
LDSCRIPT ?= $(csp_target_root)ldscripts/flash.ld

CFLAGS ?= -std=c99 -Wall -fmessage-length=0 -fstack-usage -Wno-unused-function -fdata-sections -ffunction-sections -flto 

LDFLAGS ?= -Wl,--gc-sections -flto -Wl,--cref

CFLAGS +=  -MMD -fstrict-volatile-bitfields -fno-strict-aliasing
LDFLAGS += -L$(csp_target_root)ldscripts -L$(csp_root)generic/ldscripts -ffreestanding -Wl,-Bstatic,-T,$(LDSCRIPT),-Map,$(build_artifact_name).map
#,--print-memory-usage

ifdef $(STACKSIZE)
LDFLAGS+=-Wl,--defsym=__stack_size=$(STACKSIZE)
endif

DEFS += -DDEBUG=$(DEBUG) -D$(sdk_short_name) -D$(sdk_long_name) -D$(sdk_generic_short_name) -D$(sdk_generic_long_name)

ifeq ($(DEBUG),1)
    CFLAGS += -g3 -O0
endif

ifeq ($(DEBUG),0)
    CFLAGS += -g -Os -fomit-frame-pointer
endif

ifeq ($(NOSTARTFILES),1)
    LDFLAGS += -nostartfiles
endif

all_outputs=$(build_artifact_name).elf $(build_artifact_name).ihex $(build_artifact_name).bin $(build_artifact_name).v $(build_artifact_name).disassembly  $(build_artifact_name).sections $(build_artifact_name).naked.elf $(build_artifact_name).naked.size

build: $(all_outputs)

ifneq ($(filter clean,$(MAKECMDGOALS)),clean)
    ifneq ($(filter rebuild,$(MAKECMDGOALS)),rebuild)
        -include $(DEPS)
    endif
endif

$(build_artifact_name).elf: $(OBJS) 
	$(TARGET_CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LDEFS) $(LIBSINC) $(LIBS)

%.ihex: %.elf
	$(TARGET_OBJCOPY) -O ihex --gap-fill=0x00 $< $@

%.bin: %.elf
	$(TARGET_OBJCOPY) -O binary $< $@

%.v: %.elf
	$(TARGET_OBJCOPY) -O verilog $< $@

%.disassembly: %.elf
	$(TARGET_OBJDUMP) --disassemble-zeroes --insn-width=6 -S -d $< > $@

%.sections: %.elf
	$(TARGET_OBJDUMP) -h -d $< > $@

%.naked.elf: %.ihex
	$(TARGET_OBJCOPY) -I ihex -O elf32-$(TOOLCHAIN_PREFIX) $< $@

%.size: %.elf
	$(TARGET_ELF2SIZE) -A $< > $@
	cat $@

$(OBJS_PATH)%.o: %.c
	mkdir -p $(dir $@)
	$(TARGET_CC) $(CFLAGS) $(DEFS) $(INC) -c -o $@ $<

$(OBJS_PATH)%.o: %.cpp
	mkdir -p $(dir $@)
	$(TARGET_CC) $(CFLAGS) $(DEFS) $(INC) -c -o $@ $<

$(OBJS_PATH)%.o: %.S
	mkdir -p $(dir $@)
	$(TARGET_CC) -c $(CFLAGS) $(DEFS) -o $@ $< -D__ASSEMBLY__=1

$(OBJS_PATH)load.if.needed: $(all_outputs)
	# load needed
	$(call load_ihex,$(build_artifact_name).ihex)
	touch $(OBJS_PATH)load.if.needed

.PHONY: clean
clean:
	rm -rf $(OBJS_PATH)
	rm -f $(build_artifact_name).elf
	rm -f $(build_artifact_name).naked.elf
	rm -f $(build_artifact_name).map
	rm -f $(build_artifact_name).ihex
	rm -f $(build_artifact_name).bin
	rm -f $(build_artifact_name).v
	rm -f $(build_artifact_name).disassembly
	rm -f $(build_artifact_name).sections
	rm -f $(build_artifact_name).naked.size

clean-all : clean

rebuild: clean-all | build

ifeq ($(REBUILD_BY_DEFAULT),1)
all: rebuild
else
all: build
endif

.PHONY: just_load
just_load:
	$(call load_ihex,$(build_artifact_name).ihex)

.PHONY: just_run 
just_run:
	python $(PROJECT_NAME).py $(RUN_ARGS)
    
load: build | just_load

run: $(OBJS_PATH)load.if.needed | just_run
    
#printvars: .PHONY
#	@$(foreach V,$(sort $(.VARIABLES)),$(if $(filter-out default automatic,$(origin $V)),$(warning $V=$($V) ($(value $V)))))
#@$(foreach V,$(sort $(.VARIABLES)),$(if $(filter-out environment% default automatic,$(origin $V)),$(warning $V=$($V) ($(value $V)))))
    
.SECONDARY: $(OBJS)