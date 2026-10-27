AS := nasm
BUILD := build
IMAGE := $(BUILD)/chiquios-test.img

.PHONY: all clean check

all: $(IMAGE)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.bin: boot/boot.asm | $(BUILD)
	$(AS) -f bin $< -o $@

$(BUILD)/stage2.bin: boot/linux_loader.asm | $(BUILD)
	$(AS) -f bin $< -o $@
	test "$$(stat -c%s $@)" -le 512

$(IMAGE): $(BUILD)/boot.bin $(BUILD)/stage2.bin
	dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	dd if=$(BUILD)/boot.bin of=$@ conv=notrunc status=none
	dd if=$(BUILD)/stage2.bin of=$@ bs=512 seek=1 conv=notrunc status=none

check: $(IMAGE)
	test "$$(stat -c%s $(BUILD)/boot.bin)" -eq 512
	test "$$(od -An -tx1 -j510 -N2 $(BUILD)/boot.bin | tr -d ' \n')" = "55aa"
	dd if=$(IMAGE) of=$(BUILD)/stage2-check.bin bs=512 skip=1 count=1 status=none
	cmp -n "$$(stat -c%s $(BUILD)/stage2.bin)" $(BUILD)/stage2.bin $(BUILD)/stage2-check.bin
	@echo "ChiquiOS: bootloader e imagen verificados."

clean:
	rm -rf $(BUILD)