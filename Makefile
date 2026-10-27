
AS := nasm
BUILD := build

.PHONY: all clean

all: $(BUILD)/boot.bin

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.bin: boot/boot.asm | $(BUILD)
	$(AS) -f bin boot/boot.asm -o $(BUILD)/boot.bin

clean:
	rm -rf $(BUILD)
