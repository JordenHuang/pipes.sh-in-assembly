%include "random.asm"
%include "c.inc"

section .data
    ;;; Parameter
    wait_time: dd 25000
    clean_when_more_than: dd 2000
    ;;; Program variables
    row_pos: dd 1
    col_pos: dd 1
    can_rechoose_color: dd 0
    prob_of_change_color: dq 15
    prob_of_change_direction: dq 10

;;; Default width and height
    WIDTH: dd 134
    HEIGHT: dd 34
    HALF_WIDTH: dd 134/2
    HALF_HEIGHT: dd 34/2

section .bss
    char_c: resb 1
    cur_color: resd 1
    counter: resd 1
    cur_direction: resd 1
    prev_direction: resd 1
    argc: resd 1
    argv: resq 1

section .text
    global main
    global set_output_color
    global read_width_and_height
    global str_to_int

    extern printf
    extern usleep
    extern fflush_func

main:
;;; Proligue
    push rbp
    mov rbp, rsp

;;; Allocate 64 bytes for local variables
    sub rsp, 64

;;; Read arguments
    call read_width_and_height

    ;;; initialize color
    mov dword [cur_color], 1

    call set_seed

    clear_scn

    move_to 1, 1

setup_row_while:
    mov edx, dword [HALF_HEIGHT]
    cmp [row_pos], edx
    jg setup_col_while
    move_down 1
    inc dword [row_pos]
    jmp setup_row_while
setup_col_while:
    mov edx, dword [HALF_WIDTH]
    cmp [col_pos], edx
    jg end_setup
    print_space
    inc dword [col_pos]
    jmp setup_col_while

end_setup:
    mov dword [counter], 0


setup_while:
    ;;; initialize cur_direction
    mov rdi, 4
    call randint
    mov dword [cur_direction], eax
    mov dword [prev_direction], -1
    jmp ck_up
while_loop:
;;; sleep some time
    call fflush_func
    mov rdi, [wait_time]
    call usleep

    mov rdi, 100
    call randint
;;; set probability
;;; some chance to move with the same direction
    cmp rax, qword [prob_of_change_direction]
    jge ck_up
;;; else choose other directions,
;;; but might be same directions again
again:
    mov rdi, 4
    call randint
    ;;; if same again, then again
    cmp eax, dword [cur_direction]
    je again

    mov dword [cur_direction], eax

ck_up:
    cmp dword [cur_direction], UP
    jne ck_down

    ;;; if last is DOWN, then rechoose direction
    cmp dword [prev_direction], DOWN
    je again
dec_row:
    dec dword [row_pos]
    ; go_red
    call set_output_color
    ; print_space
    print_char
    reset_color
    move_left 1
    cmp dword [row_pos], 0
    jg not_up_bound
    mov edx, dword [HEIGHT]
    mov [row_pos], edx
    move_to [row_pos], [col_pos]
    ;;; Can rechoose color
    mov dword [can_rechoose_color], 1
    jmp end_ck_up
not_up_bound:
    move_up 1
end_ck_up:
    jmp continue_while_loop

ck_down:
    cmp dword [cur_direction], DOWN
    jne ck_left

    ;;; if last is UP, then rechoose direction
    cmp dword [prev_direction], UP
    je again
inc_row:
    inc dword [row_pos]
    ; go_red
    call set_output_color
    ; print_space
    print_char
    reset_color
    move_left 1
    mov edx, dword [HEIGHT]
    cmp [row_pos], edx
    jle not_down_bound
    mov dword [row_pos], 1
    move_to [row_pos], [col_pos]
    ;;; Can rechoose color
    mov dword [can_rechoose_color], 1
    jmp end_ck_down
not_down_bound:
    move_down 1
end_ck_down:
    jmp continue_while_loop

ck_left:
    cmp dword [cur_direction], LEFT
    jne ck_right

    ;;; if last is RIGHT, then rechoose direction
    cmp dword [prev_direction], RIGHT
    je again

dec_col:
    dec dword [col_pos]
    ; go_red
    call set_output_color
    ; print_space
    print_char
    reset_color
    move_left 1
    cmp dword [col_pos], 0
    jg not_left_bound
    mov edx, dword [WIDTH]
    mov [col_pos], edx
    move_to [row_pos], [col_pos]
    ;;; Can rechoose color
    mov dword [can_rechoose_color], 1
    jmp end_ck_left
not_left_bound:
    move_left 1
end_ck_left:
    jmp continue_while_loop

ck_right:
    cmp dword [cur_direction], RIGHT
    jne continue_while_loop

    ;;; if last is LEFT, then rechoose direction
    cmp dword [prev_direction], LEFT
    je again

inc_col:
    inc dword [col_pos]
    ; go_red
    call set_output_color
    ; print_space
    print_char
    reset_color
    move_left 1
    mov edx, dword [WIDTH]
    cmp [col_pos], edx
    jle not_right_bound
    mov dword [col_pos], 1
    move_to [row_pos], [col_pos]
    ;;; Can rechoose color
    mov dword [can_rechoose_color], 1
    jmp end_ck_right
not_right_bound:
    move_right 1
end_ck_right:
    jmp continue_while_loop

continue_while_loop:
    ;;; Update prev_direction
    mov eax, dword [cur_direction]
    mov dword [prev_direction], eax

    cmp dword [can_rechoose_color], 1
    jne add_counter
;;; Clear screen if it's more than {clean_when_more_than} chars
clear_screen:
    mov eax, dword [clean_when_more_than]
    cmp dword [counter], eax
    jl rechoose_color
    mov dword [counter], 0
    clear_scn
rechoose_color:
    mov dword [can_rechoose_color], 0
    mov rdi, 100
    call randint
;;; some chance to rechoose color
    cmp rax, qword [prob_of_change_color]
    jl add_counter
;;; rechoose color
    mov rdi, 6
    call randint
    mov dword [cur_color], eax
add_counter:
    inc dword [counter]
    jmp while_loop


leave_while:
    ; move_to 30, 0

    add rsp, 64
;;; Epiligue
    xor rax, rax
    pop rbp
    ret


;;; Function: set_output_color
set_output_color:
   push rbp
   mov rbp, rsp

   xor rax, rax
   ; mov al, dil
   mov eax, dword [cur_color]
n0: ;;; Red
   cmp eax, 0
   jne n1
   go_red
   jmp output_color_return
n1: ;;; Green
   cmp eax, 1
   jne n2
   go_green
   jmp output_color_return
n2: ;;; Blue
   cmp eax, 2
   jne n3
   go_blue
   jmp output_color_return
n3: ;;; Orange
   cmp eax, 3
   jne n4
   go_orange
   jmp output_color_return
n4: ;;; Yellow
   cmp eax, 4
   jne n5
   go_yellow
   jmp output_color_return
n5: ;;; Cyan
   cmp eax, 5
   jne output_color_return
   go_cyan
   jmp output_color_return

output_color_return:
   xor rax, rax
   pop rbp
   ret
;;; End function: set_output_color_return


;;; Function for reading arguments
read_width_and_height:
;;; Proligue
    push rbp
    mov rbp, rsp

;;; Read arguments
    mov dword [argc], edi
    mov qword [argv], rsi

    cmp dword [argc], 3
    jne read_width_and_height_return

    mov rsi, qword [argv]
    mov rdi, [rsi+8]        ;;; rdi contains the start of the string

    call str_to_int

    mov dword [WIDTH], eax

    mov rsi, qword [argv]
    mov rdi, [rsi+16]
    call str_to_int
    mov dword [HEIGHT], eax

    xor rax, rax
    xor rdx, rdx
    xor rcx, rcx
    mov ecx, 2
    mov eax, dword [WIDTH]
    div ecx
    mov dword [HALF_WIDTH], eax
    mov eax, dword [HEIGHT]
    div ecx
    mov dword [HALF_HEIGHT], eax

read_width_and_height_return:
    xor rax, rax
    pop rbp
    ret

;;; Function to turn string to integer
;;; this function takes the start of the string as the first argument
section .bss
    a_pointer: resq 1
    result_int: resd 1
    a_char: resb 1
section .text
str_to_int:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov [rsp], rdi
    xor rax, rax

    mov rdx, [rsp]
    mov [a_pointer], rdx
    mov dword [result_int], 0
while_not_end_of_str:
    xor rdx, rdx
    mov rdx, [a_pointer]
    mov dl, [rdx]
    add qword [a_pointer], 1           ;;; move pointer to next char in the string

    mov [a_char], dl    ;;; store the character to temp variable

    cmp dl, 0           ;;; OH, it's not rdx, it's dl
    je return_str_to_int

    mov edx, dword [result_int]
    imul edx, 10
    mov dword [result_int], edx

    mov dl, [a_char]
    sub dl, '0'
    add [result_int], dl

    jmp while_not_end_of_str

return_str_to_int:
    add rsp, 16
    xor rax, rax
    mov eax, dword [result_int]
    pop rbp
    ret

