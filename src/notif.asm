        SECTION .data
        libnotify_name db 'libnotify.so', 0 ; name of the lib
        ;; libnotify function names
        libnotify_fn_name_init db 'notify_init', 0
        libnotify_fn_name_new db 'notify_notification_new', 0
        libnotify_fn_name_timeout db 'notify_notification_set_timeout', 0
        libnotify_fn_name_show db 'notify_notification_show', 0
        libnotify_handle dq 0   ; 8 bytes for da handle
        notification_ptr dq 0
        ;; messages
        title_msg db 'Message Title', 0
        hello_msg db 'Worthless program', 0
        ;; shitty app name needed
        shitty_app db 'whocares', 0
        SECTION .text
        extern dlopen, dlerror, dlsym
        global _start
_start:
        ;; load libnotify and find its function addresses first
        mov rdi, libnotify_name
        mov rsi, 1            ; RTLD_LAZY
        call dlopen
        mov [libnotify_handle], rax ; save the handle bc you'll need it later
        ;; call dlerror to see if there was an error (actually looking it up on the debugger)
        call dlerror
        ;; find notify_init
        mov rdi, [libnotify_handle] ; store handle returned by dlopen
        lea rsi, [rel libnotify_fn_name_init]
        call dlsym
        ;; call notify_init
        mov rdi, shitty_app
        call rax
        ;; find notify_notification_new
        mov rdi, [libnotify_handle]
        lea rsi, [rel libnotify_fn_name_new]
        call dlsym
        ;; call notify_notification_new
        lea rdi, [rel title_msg]
        lea rsi, [rel hello_msg]
        xor rdx, rdx            ; NULL
        call rax
        ;; notify_notification_new returns a pointer that you'll need for the timeout, so save it
        mov [notification_ptr], rax
        ;; find notify_notification_set_timeout
        mov rdi, [libnotify_handle]
        lea rsi, [rel libnotify_fn_name_timeout]
        call dlsym
        mov rdi, [notification_ptr]
        mov rsi, 3000              ; 3 secs of timeout
        call rax
        ;; finally, find & call notify_notification_show
        mov rdi, [libnotify_handle]
        lea rsi, [rel libnotify_fn_name_show]
        call dlsym
        mov rdi, [notification_ptr]
        xor rsi, rsi            ; NULL
        call rax
        ;; closing world
        mov rax, 60             ; sys_exit
        xor rdi, rdi
        syscall
