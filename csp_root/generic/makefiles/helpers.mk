
clean_unix_path=$(shell echo '$(1)' | sed -E 's,//,/,g')
winpath2unix_core = $(shell echo '$(1)/' | sed -E 's_\<(.):_/\l\1_g; s_\\_/_g')
winpath2unix = $(call clean_unix_path,$(call winpath2unix_core,$(1)))
fixpath = $(realpath $(call winpath2unix_core,$(1)))/

recurfind = $(shell find $(1) -name '$(2)')

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))
      
# Version which output the related makefile target
# Call it like that:
#foo :
#	@:$(call check_defined2, BAR, ABOUT BAR)
check_defined2 = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined2,$1,$(strip $(value 2)))))
__check_defined2 = \
    $(if $(value $1),, \
        $(error Undefined $1$(if $2, ($2))$(if $(value @), \
                required by target `$@')))