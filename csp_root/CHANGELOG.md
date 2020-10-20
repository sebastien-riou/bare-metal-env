# Changelog

## [1.5.0] - 2020-10-19

### Changed
- `generic.mk`: `erase_build` target. It erases the `build` folder completely. It shall not be used with other targets.
- python scripts: "shebang" line removed, this cause some problems on some windows systems even though the script is called by python directly.

### Added
- `os_is_linux` script: returns 1 if OS is Linux.
- `os_dep.sh` script: set PYTHON, PIP and EXE_EXT environment variables depending on the OS.
- `newterm` script: opens a new bash terminal.
- `portable_config.py` script: allows to use a single config file for shell scripts and makefiles

## [1.4.0] - 2020-07-28

### Added
- `ihexpad.py` script to pad ihex files

### Changed
- `generik.mk`: ihex post_process step

## [1.1.2] - 2020-06-18

### Added
- Python scripts to process ihex files

### Changed
- `generik.mk`: removed `--gap-fill` to generate smaller ihex files

## [1.1.1] - 2020-05-28

### Added
- This file

### Changed
- `README.md`: Order of operations changed in the guide to create an eclipse project
- `generik.mk`: include directories added to assembly files build

## [1.1.0] - 2020-05-22

### Added
- vanilla SHA256 code

### Changed
- `generik.mk`: tweak to generate better disassembly log
- `generik-flash.ld`

## [1.0.0] - 2020-04-20
Initial release
