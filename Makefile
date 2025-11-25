MODULE_NAME := evilbit
KDIR := /lib/modules/$(shell uname -r)/build
ZIG_OBJ := zig-out/obj/$(MODULE_NAME).o
obj-m := $(MODULE_NAME).o
$(MODULE_NAME)-objs := $(MODULE_NAME)_zig.o modinfo.o netfilter_wrapper.o

## all: build the evilbit module
all: zig-build
	cp $(ZIG_OBJ) $(MODULE_NAME)_zig.o
	touch .$(MODULE_NAME)_zig.o.cmd
	$(MAKE) -C $(KDIR) M=$(PWD) modules

## zig-build: build Zig object file
zig-build:
	zig build

## clean: ze shit
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -rf zig-out .zig-cache
	rm -f $(MODULE_NAME).ko $(MODULE_NAME).o $(MODULE_NAME)_zig.o modinfo.o netfilter_wrapper.o

## install: really?
install: all
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
	depmod -a

## load: the evil
load:
	insmod $(MODULE_NAME).ko

## unload: the evil
unload:
	rmmod $(MODULE_NAME)

## logs: the evil
logs:
	dmesg | grep -i evilbit | tail -20

## help: print this help message
help:
	@printf 'Usage:\n'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: all zig-build clean install load unload logs help
