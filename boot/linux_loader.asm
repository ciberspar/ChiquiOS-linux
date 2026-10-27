
BITS 16
ORG 0x8000

stage2_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7000
    sti
    cld

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

msg db 'ChiquiOS: segunda etapa funcionando.', 13, 10
    db 'Siguiente objetivo: cargar kernel Linux x86.', 13, 10, 0
