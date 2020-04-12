
TOOLCHAIN_PREFIX = riscv64-unknown-elf

loader:=TODO: path to loader software
$(info INFO: loader                = $(loader))

# Path to its toolchain
# convert windows path to unix
sdk_root:=$(realpath $(call winpath2unix,$(SDK_ROOT)))/

TARGET_TOOLCHAIN_PATH ?= TODO: usual relative path of the toolchain from SDK_ROOT
target_toolchain_path:=$(realpath $(call winpath2unix,$(TARGET_TOOLCHAIN_PATH)))/

