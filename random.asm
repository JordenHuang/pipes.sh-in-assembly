section .text
    extern time
    extern srand
    extern rand
    global set_seed
    global randint

set_seed:
    push rbp
    mov rbp, rsp

    xor rdi, rdi
    xor rax, rax

    mov rdi, 0
    call time

    mov rdi, rax
    call srand

    pop rbp
    ret

;;; Function randint:
;;; given n, return a random number from 0 ~ (n-1)
randint:
    push rbp
    mov rbp, rsp

    sub rsp, 4
    mov [rsp], rdi

    xor rax, rax
    call rand

    xor rcx, rcx
    xor rdx, rdx
    mov rcx, [rsp]
    div rcx
    mov rax, rdx

    add rsp, 4
    pop rbp
    ret

;;; Function modulo
;;; given num and n, return num % n
modulo:
    push rbp
    mov rbp, rsp

    sub rsp, 8
    mov [rsp], rdi
    mov [rsp+4], rsi

    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx
    mov rax, [rsp]
    mov rcx, [rsp+4]
    div rcx
    mov rax, rdx

    add rsp, 8
    pop rbp
    ret
