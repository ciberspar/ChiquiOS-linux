BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    cld
    sti

    mov [boot_drive], dl

    mov si, msg
    call print

    ; Cargar el sector 2 en 0000:8000
    xor ax, ax
    mov es, ax
    mov bx, 0x8000

    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    int 0x13
    jc disk_error

    jmp 0x0000:0x8000

disk_error:
    mov si, err
    call print

halt:
    cli
    hlt
    jmp halt

print:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

boot_drive db 0
msg db 'ChiquiOS Linux: iniciando...', 13, 10, 0
err db 'Error BIOS: no se pudo leer la segunda etapa.', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55