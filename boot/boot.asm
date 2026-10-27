
BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti
    cld

    mov si, mensaje
    call imprimir

detener:
    cli
    hlt
    jmp detener

imprimir:
    lodsb
    test al, al
    jz imprimir_fin

    mov ah, 0x0E
    mov bx, 0x0007
    int 0x10
    jmp imprimir

imprimir_fin:
    ret

mensaje db 13, 10
        db 'ChiquiOS Linux - Bootloader propio', 13, 10
        db 'BIOS x86 iniciado.', 13, 10
        db 'Cargador Linux: pendiente.', 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
