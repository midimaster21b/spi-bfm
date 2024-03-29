# SPI BFMs

Simple SPI master and SPI slave bus functional models(BFMs).


## Tool Requirements

### [asdf](https://asdf-vm.com/guide/getting-started.html)

This repository uses [asdf](https://asdf-vm.com/guide/getting-started.html) for tool version management. If you do not wish to use [asdf](https://asdf-vm.com/guide/getting-started.html) or do not have it available, open the file `.tool-versions` in this directory to see a list of tools and their associated versions required to run this core locally.

### [FuseSoC](https://github.com/olofk/fusesoc)

Once you have python installed, use pip to install FuseSoC and other requirements.

### [Vivado](https://www.xilinx.com/support/download.html)

Vivado is used for the default simulator for this repository. Other simulators can be used with FuseSoC's `--tool` flag.


## How to use

1. Make sure you have the correct tool versions available.

`asdf install`


2. Use python's pip to install [FuseSoC](https://github.com/olofk/fusesoc) and other requirements.

`pip install -r requirements.txt`


3. Run the core locally

`fusesoc --cores-root . run --target sim midimaster21b:bfm:spi:0.1.0`

Expected output:
```
INFO: Preparing midimaster21b:bfm:spi:0.1.0
INFO: Setting up project
INFO: Building
INFO: Running
xsim -R  midimaster21b_bfm_spi_0.1.0

****** xsim v2019.1 (64-bit)
  **** SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
  **** IP Build 2548770 on Fri May 24 18:01:18 MDT 2019
    ** Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.

source xsim.dir/midimaster21b_bfm_spi_0.1.0/xsim_script.tcl
# xsim {midimaster21b_bfm_spi_0.1.0} -autoloadwcfg -runall
Vivado Simulator 2019.1
Time resolution is 1 ps
run -all
	  1250.00 ns: SPI Master - Write Data - 'a5a5'
	  1250.00 ns: SPI Slave - Write Data - 'a5'
	 22500.00 ns: SPI Slave - Write Data - 'a5'
	 23750.00 ns: SPI Slave - Read Byte - 'a5'
	 41251.00 ns: SPI Master - Read Data - 'a5a5'
	 42500.00 ns: SPI Slave - Write Data - 'a5'
	 46250.00 ns: SPI Slave - Read Byte - 'a5'
	 71250.00 ns: SPI Master - Write Data - 'abcd'
	 92500.00 ns: SPI Slave - Write Data - 'a5'
	 93750.00 ns: SPI Slave - Read Byte - 'ab'
	111251.00 ns: SPI Master - Read Data - 'a5a5'
	112500.00 ns: SPI Slave - Write Data - 'a5'
============================
======= TEST PASSED! =======
============================
$finish called at time : 116250 ns : File "/home/midimaster21b/src/spi-bfm/build/midimaster21b_bfm_spi_0.1.0/sim-xsim/src/midimaster21b_bfm_spi_0.1.0/src/tb/spi_tb.sv" Line 24
exit
INFO: [Common 17-206] Exiting xsim at Mon Jan 15 09:06:47 2024...
```
