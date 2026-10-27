
AS := nasm
BUILD := build
IMAGE := $(BUILD)/chiquios-test.img

.PHONY: all clean

all: $(IMAGE)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.bin: boot/boot.asm | $(BUILD)
	$(AS) -f bin $< -o $@

$(BUILD)/stage2.bin: boot/linux_loader.asm | $(BUILD)
	$(AS) -f bin $< -o $@

$(IMAGE): $(BUILD)/boot.bin $(BUILD)/stage2.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=$(BUILD)/boot.bin of=$@ conv=notrunc
	dd if=$(BUILD)/stage2.bin of=$@ bs=512 seek=1 conv=notrunc

clean:
	rm -rf $(BUILD)
