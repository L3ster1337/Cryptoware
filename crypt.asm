section .data
    in_file db 'test.txt', 0
    out_file db 'output.txt', 0
    in_fd db 0
    out_fd db 0
section .text  
    global _start

_start:

    mov eax, 5; syscall open
    mov ebx, in_file ; input in ebx
    xor ecx, ecx ; cleaning ecx
    int 0x80
    mov [in_fd], eax ; Saving eax in file descriptor 

    mov eax, 5 ; syscall open
    mov ebx, out_file ; endereco do outfile no ebx
    mov ecx, 0102o 
    mov edx, 00600o ; valor de permissao
    int 0x80; kernel call
    mov [out_fd], eax ; salvando valor de eax em out_fd (file descriptor)

    ;Creating loop

next_byte:

    ;Lendo 1 byte apenas
    mov eax, 3; syscall read
    mov ebx, [in_fd]; inserindo o valor do file descriptor do input para o ebx
    sub esp, 1 ; reserva espaco de 1 byte na pilha
    lea ecx, [esp] ;Carrega o valor do buffer em ecx
    mov edx, 1; Define que tera leitura apenas de 1 byte
    int 0x80
    cmp eax, 0 ; se o valor de eax for 0, entao ele finalizou a leitura. Entao:  
    je finish
    ; Criptografando o byte
    xor byte [esp], 0x55; Faz xor do byte lido com 0x55

    ;Escrevendo o byte criptografado
    mov eax, 4; syscall write
    mov ebx, [out_fd]; file descriptor
    mov ecx, esp; atribuindo o valor do buffer sobre o ecx
    mov edx, 1; definindo que quer escrever apenas 1 byte
    add esp, 1; liberando o espaco do buffer
    int 0x80

    add esp, 1; liberando espaco do buffer

    jmp next_byte ;Volta para next_byte

finish: 

    mov eax, 6; syscall close
    mov ebx, [in_fd]
    int 0x80
    mov ebx, [out_fd]
    int 0x80

    mov eax, 1
    xor ebx, ebx ; limpa o ebx para ficar com valor igual a zero
    int 0x80
