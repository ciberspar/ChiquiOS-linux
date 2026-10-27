
BITS 16

stage2_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7000
    sti

    mov si, msg
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

msg db 13, 10
    db 'ChiquiOS: segunda etapa iniciada.', 13, 10
    db 'Preparado para implementar carga Linux.', 13, 10, 0
