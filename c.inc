
section .data
    up_fmt: db 0o33, "[%dA", 0
    down_fmt: db 0o33, "[%dB", 0
    left_fmt: db 0o33, "[%dD", 0
    right_fmt: db 0o33, "[%dC", 0
    move_to_fmt: db 0o33, "[%d;%dH", 0
    clear_screen_fmt: db 0o33, "[2J", 0
    greeting_fmt: db "Hello", 0

    bg_red_fmt: db 0o33, "[48;2;255;0;0m", 0
    bg_green_fmt: db 0o33, "[48;2;0;255;0m", 0
    bg_blue_fmt: db 0o33, "[48;2;0;0;255m", 0

    fg_red_fmt: db 0o33, "[38;2;245;85;65m", 0
    fg_green_fmt: db 0o33, "[38;2;15;225;35m", 0
    fg_blue_fmt: db 0o33, "[38;2;70;135;245m", 0
    fg_orange_fmt: db 0o33, "[38;2;245;195;65m", 0
    fg_yellow_fmt: db 0o33, "[38;2;212;245;65m", 0
    fg_cyan_fmt: db 0o33, "[38;2;65;245;175m", 0

    reset_fmt: db 0o33, "[0m", 0

    space_fmt: db " ", 0
    char_fmt: db "@", 0

%macro move_up 1
    mov rdi, up_fmt
    mov rsi, %1
    call printf
%endmacro
%macro move_down 1
    mov rdi, down_fmt
    mov rsi, %1
    call printf
%endmacro
%macro move_left 1
    mov rdi, left_fmt
    mov rsi, %1
    call printf
%endmacro
%macro move_right 1
    mov rdi, right_fmt
    mov rsi, %1
    call printf
%endmacro

%macro move_to 2
    mov rdi, move_to_fmt
    mov rsi, %1
    mov rdx, %2
    call printf
%endmacro

%macro go_red 0
    mov rdi, fg_red_fmt
    call printf
%endmacro

%macro go_green 0
    mov rdi, fg_green_fmt
    call printf
%endmacro

%macro go_blue 0
    mov rdi, fg_blue_fmt
    call printf
%endmacro

%macro go_orange 0
    mov rdi, fg_orange_fmt
    call printf
%endmacro

%macro go_yellow 0
    mov rdi, fg_yellow_fmt
    call printf
%endmacro

%macro go_cyan 0
    mov rdi, fg_cyan_fmt
    call printf
%endmacro

%macro reset_color 0
    mov rdi, reset_fmt
    call printf
%endmacro

%macro print_space 0
    mov rdi, space_fmt
    call printf
%endmacro

%macro print_char 0
    mov rdi, char_fmt
    call printf
%endmacro

%macro clear_scn 0
    mov rdi, clear_screen_fmt
    call printf
%endmacro


; #define part
%define ESC 27
%define DEL 127
%define BACKSPACE 8
%define CARRIAGE_RETURN 13
%define LINE_FEED 10
%define SPACE 32

%define UP 0
%define DOWN 1
%define LEFT 2
%define RIGHT 3

