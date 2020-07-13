;; @module termbox.lsp
;; @description Termbox TUI bindings
;; @version 1.0 initial commit
;; @author Ferry de Bruin 2020
;; Newlisp bindings for termbox library https://github.com/nsf/termbox :
;; "Termbox is a library that provides minimalistic API which allows 
;; the programmer to write text-based user interfaces."
;; The newlisp API consists of 13 functions:
;; tb:init, tb:shutdown, tb:width, tb:height, tb:put-string, tb:box, tb:clear,  
;; tb:present, tb:set_cursor, tb:input-mode, tb:output-mode, tb:poll, tb:peek. 

;; <h2>Module for Termbox TUI bindings </h2>
;; To use this module you need the termbox dynamic library from https://github.com/nsf/termbox.
;; On a mac you can do brew install termbox, on my system it then is at:
;; /usr/local/Cellar/termbox/1.1.2/lib/libtermbox.dylib.
;; On Linux use apt-get or other package manager. On Windows ..?
;; For linux the libtermbox.so file must be in either /usr/lib/termbox/, /usr/local/lib/termbox/,
;; or /usr/pkg/lib/termbox/. 
;; 

(context 'tb)
(set 'files (list
    "/usr/lib/termbox/libtermbox.so" 
    "/usr/local/lib/termbox/libtermbox.so" 
    "/usr/pkg/lib/termbox/libtermbox.so" 
    "/usr/local/Cellar/termbox/1.1.2/lib/libtermbox.dylib" ; brew install Mac OSX Darwin
    "/usr/local/share/termbox/libtermbox.dylib" ; 
))

 (set 'lib (files (or
 		       (find true (map file? files)) 
 		       (throw-error "cannot find termbox library"))))


;; Key constants. See also struct event's key field.
;; These are a safe subset of terminfo keys, which exist on all popular
;; terminals. Termbox uses only them to stay truly portable.
(constant 'KEY_F1               (- 0xFFFF 0))
(constant 'KEY_F2               (- 0xFFFF 1))
(constant 'KEY_F3               (- 0xFFFF 2))
(constant 'KEY_F4               (- 0xFFFF 3))
(constant 'KEY_F5               (- 0xFFFF 4))
(constant 'KEY_F6               (- 0xFFFF 5))
(constant 'KEY_F7               (- 0xFFFF 6))
(constant 'KEY_F8               (- 0xFFFF 7))
(constant 'KEY_F9               (- 0xFFFF 8))
(constant 'KEY_F10              (- 0xFFFF 9))
(constant 'KEY_F11              (- 0xFFFF 10))
(constant 'KEY_F12              (- 0xFFFF 11))
(constant 'KEY_INSERT           (- 0xFFFF 12))
(constant 'KEY_DELETE           (- 0xFFFF 13))
(constant 'KEY_HOME             (- 0xFFFF 14))
(constant 'KEY_END              (- 0xFFFF 15))
(constant 'KEY_PGUP             (- 0xFFFF 16))
(constant 'KEY_PGDN             (- 0xFFFF 17))
(constant 'KEY_ARROW_UP         (- 0xFFFF 18))
(constant 'KEY_ARROW_DOWN       (- 0xFFFF 19))
(constant 'KEY_ARROW_LEFT       (- 0xFFFF 20))
(constant 'KEY_ARROW_RIGHT      (- 0xFFFF 21))
(constant 'KEY_MOUSE_LEFT       (- 0xFFFF 22))
(constant 'KEY_MOUSE_RIGHT      (- 0xFFFF 23))
(constant 'KEY_MOUSE_MIDDLE     (- 0xFFFF 24))
(constant 'KEY_MOUSE_RELEASE    (- 0xFFFF 25))
(constant 'KEY_MOUSE_WHEEL_UP   (- 0xFFFF 26))
(constant 'KEY_MOUSE_WHEEL_DOWN (- 0xFFFF 27))

;; These are all ASCII code points below SPACE character and a BACKSPACE key. 
(constant 'KEY_CTRL_TILDE       0x00)
(constant 'KEY_CTRL_2           0x00) ; clash with 'CTRL_TILDE' ;/
(constant 'KEY_CTRL_A           0x01)
(constant 'KEY_CTRL_B           0x02)
(constant 'KEY_CTRL_C           0x03)
(constant 'KEY_CTRL_D           0x04)
(constant 'KEY_CTRL_E           0x05)
(constant 'KEY_CTRL_F           0x06)
(constant 'KEY_CTRL_G           0x07)
(constant 'KEY_BACKSPACE        0x08)
(constant 'KEY_CTRL_H           0x08) ; clash with 'CTRL_BACKSPACE' ;/
(constant 'KEY_TAB              0x09)
(constant 'KEY_CTRL_I           0x09) ; clash with 'TAB' ;/
(constant 'KEY_CTRL_J           0x0A)
(constant 'KEY_CTRL_K           0x0B)
(constant 'KEY_CTRL_L           0x0C)
(constant 'KEY_ENTER            0x0D)
(constant 'KEY_CTRL_M           0x0D) ; clash with 'ENTER' ;/
(constant 'KEY_CTRL_N           0x0E)
(constant 'KEY_CTRL_O           0x0F)
(constant 'KEY_CTRL_P           0x10)
(constant 'KEY_CTRL_Q           0x11)
(constant 'KEY_CTRL_R           0x12)
(constant 'KEY_CTRL_S           0x13)
(constant 'KEY_CTRL_T           0x14)
(constant 'KEY_CTRL_U           0x15)
(constant 'KEY_CTRL_V           0x16)
(constant 'KEY_CTRL_W           0x17)
(constant 'KEY_CTRL_X           0x18)
(constant 'KEY_CTRL_Y           0x19)
(constant 'KEY_CTRL_Z           0x1A)
(constant 'KEY_ESC              0x1B)
(constant 'KEY_CTRL_LSQ_BRACKET 0x1B) ; clash with 'ESC' ;/
(constant 'KEY_CTRL_3           0x1B) ; clash with 'ESC' ;/
(constant 'KEY_CTRL_4           0x1C)
(constant 'KEY_CTRL_BACKSLASH   0x1C) ; clash with 'CTRL_4' ;/
(constant 'KEY_CTRL_5           0x1D)
(constant 'KEY_CTRL_RSQ_BRACKET 0x1D) ; clash with 'CTRL_5' ;/
(constant 'KEY_CTRL_6           0x1E)
(constant 'KEY_CTRL_7           0x1F)
(constant 'KEY_CTRL_SLASH       0x1F) ; clash with 'CTRL_7' ;/
(constant 'KEY_CTRL_UNDERSCORE  0x1F) ; clash with 'CTRL_7' ;/
(constant 'KEY_SPACE            0x20)
(constant 'KEY_BACKSPACE2       0x7F)
(constant 'KEY_CTRL_8           0x7F) ; clash with 'BACKSPACE2' ;/

;; These are non-existing ones.
;; (constant 'KEY_CTRL_1 clash with '1'
;; (constant 'KEY_CTRL_9 clash with '9'
;; (constant 'KEY_CTRL_0 clash with '0'

;; Alt modifier constant, see event.mod field and select_input_mode function.
;; Mouse-motion modifier
(constant 'MOD_ALT    0x01)
(constant 'MOD_MOTION 0x02)

; Colors (see struct cell's fg and bg fields).
(constant 'DEFAULT 0x00)
(constant 'BLACK   0x01)
(constant 'RED     0x02)
(constant 'GREEN   0x03)
(constant 'YELLOW  0x04)
(constant 'BLUE    0x05)
(constant 'MAGENTA 0x06)
(constant 'CYAN    0x07)
(constant 'WHITE   0x08)

; Attributes, it is possible to use multiple attributes by combining them
; using bitwise OR ('|'). Although, colors cannot be combined. But you can
; combine attributes and a single color. See also struct cell's fg and bg
; fields.
(constant 'BOLD      0x0100)
(constant 'UNDERLINE 0x0200)
(constant 'REVERSE   0x0400)

; A cell, single conceptual entity on the terminal screen. The terminal screen
; is basically a 2d array of cells. It has the following fields:
;  - 'ch' is a unicode character
;  - 'fg' foreground color and attributes
;  - 'bg' background color and attributes
(struct 'cell "unsigned int" "unsigned short int" "unsigned short int")
(constant 'cell->ch 0 'cell->fg 1 'cell->bg 2)

(constant 'EVENT_KEY    1)
(constant 'EVENT_RESIZE 2)
(constant 'EVENT_MOUSE  3)

; An event, single interaction from the user. The 'mod' and 'ch' fields are
; valid if 'type' is TB_EVENT_KEY. The 'w' and 'h' fields are valid if 'type'
; is EVENT_RESIZE. The 'x' and 'y' fields are valid if 'type' is
; EVENT_MOUSE. The 'key' field is valid if 'type' is either EVENT_KEY
; or EVENT_MOUSE. The fields 'key' and 'ch' are mutually exclusive; only
; one of them can be non-zero at a time.
; struct tb_event {
;	uint8_t type;
;	uint8_t mod; /* modifiers to either 'key' or 'ch' below */
;	uint16_t key; /* one of the TB_KEY_* constants */
;	uint32_t ch; /* unicode character */
;	int32_t w;
;	int32_t h;
;	int32_t x;
;	int32_t y;
(struct 'event "byte" "byte" "unsigned short int" "unsigned int" "int" "int" "int" "int")
(constant 'event->type 0 'event->mod 1 'event->key 2 'event->ch 3 'event->w 4 'event->h 5 'event->x 6 'event->y 7)

(import lib "tb_init") ;initialization
(import lib "tb_shutdown") ; shutdown
(import lib "tb_width") ; width of the terminal screen
(import lib "tb_height") ; height of the terminal screen
(import lib "tb_clear") ; clear buffer
(import lib "tb_set_clear_attributes")  ;(uint16_t fg, uint16_t bg)
(import lib "tb_present") ; sync internal buffer with terminal  
(import lib "tb_put_cell") ;(int x, int y, const struct cell *cell)
(import lib "tb_change_cell") ;(int x, int y, uint32_t ch, uint16_t fg, uint16_t bg)
(import lib "tb_set_cursor" ) ;(int cx, int cy);
(import lib "tb_cell_buffer" "void*") ;returns pointer to cell struct
(import lib "tb_select_input_mode" "int" "int") ; change input mode
(import lib "tb_select_output_mode") ;(int mode)
(import lib "tb_peek_event") ; peek a keyboard event
(import lib "tb_poll_event") ; wait for a keyboard event

;; @syntax (tb:init)
;; @return 0 on succes, -1,-2 0r -3 on failure.
;; Initializes the termbox library. This function should be called before any
;; other functions.
;; After successful initialization, the library must be
;; finalized using the shutdown() function.
;; Error codes returned by init(). 
;;    -1 "error: UNSUPPORTED TERMINAL")
;;	  -2 "error: FAILED TO OPEN_TTY")
;;		-3 "error: PIPE TRAP ERROR
;; All of them are self-explanatory, except
;; the pipe trap error. Termbox uses unix pipes in order to deliver a message
;; from a signal handler (SIGWINCH) to the main event reading loop. Honestly in
;; most cases you should just check the returned code as < 0.
(define (init)
  (case (tb_init)
		(-1 "error: UNSUPPORTED TERMINAL")
	  (-2 "error: FAILED TO OPEN_TTY")
		(-3 "error: PIPE TRAP ERROR")
		(true "OK")))

;; @syntax (tb:shutdown)
(define (shutdown)
  (tb_shutdown))

;; @syntax (tb:width)
;; @syntax (tb:height)
;; @return Returns the size of the internal back buffer (which is the same as
;; terminal's window size in characters). The internal buffer can be resized
;; after clear() or present() function calls. Both dimensions have an
;; unspecified negative value when called before init() or after
;; shutdown().
(define (width)
  (tb_width))

(define (height)
  (tb_height))  

;; @syntax (tb:clear)
;; @syntax (tb:clear fg bg)
;; Clears the internal back buffer using DEFAULT color or the
;; color/attributes set by (clear fg bg) function.
(define (clear fg bg)
  (if fg
    (tb_set_clear_attributes fg bg)
    (tb_clear)))

;; @syntax (tb:present)
; sync internal buffer with terminal    
(define (present)
  (tb_present))

(constant 'HIDE_CURSOR -1)

;; @syntax (tb:set-cursor <x> <y>)
;; @param <x> <y> coordinates
;; Sets the position of the cursor. Upper-left character is (0, 0). If you pass
;; tb:HIDE_CURSOR (-1) as both coordinates, then the cursor will be hidden. Cursor
;; is hidden by default.
(define (set-cursor x y)
  (tb_set_cursor x y))

;; @syntax (tb:put-string <x> <y> <str>)
;; @syntax (tb:put-string <x> <y> <str> <fg>)
;; @syntax (tb:put-string <x> <y> <str> <fg> <bg>)
;; @syntax (tb:put-string <x> <y> <str> <fg> <bg> <dir>)
;; @param <x> <y> start position
;; @param <str> string
;; @param <fg> foreground color (black is default)
;; @param <bg> background color (white is default)
;; @param <dir> direction, 1: horizontal (default), 2:vertical, 3:diagonal
;; Put a string in the buffer.
(define (put-string x y str (fg tb:BLACK) (bg tb:WHITE) (dir 1))
	(case dir
			(1 (setq x1 1 y1 0))  ;horizontal printing
			(2 (setq x1 0 y1 1))  ;vertical printing
			(3 (setq x1 1 y1 1))) ;diagonal printing ;-)
  (dostring (s str)
    (tb_change_cell (+ x (* $idx x1)) (+ y (* $idx y1)) s fg bg)))

;; @syntax  (tb:box)
;; @syntax  (tb:box <x> <y>)
;; @syntax  (tb:box) <x> <xy> <w> <h>)
;; @syntax  (tb:box) <x> <xy> <w> <h> <fg> <bg>)
;: @param <x> <y> position of left top of box, defaults to 0,0
;; @param <w> <h> width and height of box, defaults to width and height of the terminal window 
;; @param <fg> <bg> foregrounf and background colors, defaults to Green and Black
;; Draws a rectangle
(define(box (x 0) (y 0) (w (- (tb:width) 1)) (h (- (tb:height) 1)) (fg tb:GREEN) (bg tb:BLACK))
  (put-string x y (string "┌" (dup "─" (- w 1)))  fg bg)
  (put-string (+ x w) y (string "┐" (dup "│" (- h 1)))  fg bg 2)
  (put-string (+ x 1) (+ y h ) (string (dup "─" (- w 1)) "┘")  fg bg)
  (put-string x (+ y 1) (string (dup "│" (- h 1)) "└")  fg bg 2))

;; @syntax (cell-buffer)
;; @return pointer
;; Returns a pointer to internal cell back buffer. You can get its dimensions
;; using tb_width() and tb_height() functions. The pointer stays valid as long
;; as no tb_clear() and tb_present() calls are made. The buffer is
;; one-dimensional buffer containing lines of cells starting from the top.
(define (cell-buffer)
	(tb_cell_buffer))

(constant 'INPUT_CURRENT 0) ; 000 
(constant 'INPUT_ESC     1) ; 001 
(constant 'INPUT_ALT     2) ; 010 
(constant 'INPUT_MOUSE   4) ; 100 

;; @syntax (input-mode mode)
;; @param <mode>  tb:INPUT_CURRENT , tb:INPUT_ESC, tb:INPUT_ALT, tb:INPUT_MOUSE
;; Sets the termbox input mode. Termbox has two input modes:
;; 1. Esc input mode.
;;    When ESC sequence is in the buffer and it doesn't match any known
;;    ESC sequence => ESC means KEY_ESC.
;; 2. Alt input mode.
;;    When ESC sequence is in the buffer and it doesn't match any known
;;    sequence => ESC enables MOD_ALT modifier for the next keyboard event.
;;
;; You can also apply INPUT_MOUSE via bitwise OR operation to either of the
;; modes (e.g. INPUT_ESC | INPUT_MOUSE). If none of the main two modes
;; were set, but the mouse mode was, INPUT_ESC mode is used. If for some
;; reason you've decided to use (INPUT_ESC | INPUT_ALT) combination, it
;; will behave as if only INPUT_ESC was selected.
;;
;; If 'mode' is INPUT_CURRENT, it returns the current input mode.
;
;; Default termbox input mode is INPUT_ESC.
(define (input-mode mode)
  (tb_select_input_mode mode))

(constant 'OUTPUT_CURRENT   0)
(constant 'OUTPUT_NORMAL    1)
(constant 'OUTPUT_256       2)
(constant 'OUTPUT_216       3)
(constant 'OUTPUT_GRAYSCALE 4)

;; @syntax (output-mode mode)
;; @param <mode> 
;; Sets the termbox output mode. Termbox has three output options:
;; 1. OUTPUT_NORMAL     => [1..8]
;;    This mode provides 8 different colors:
;;      black, red, green, yellow, blue, magenta, cyan, white
;;    Shortcut: BLACK, RED, ...
;;    Attributes: BOLD, UNDERLINE, REVERSE
;;
;;    Example usage:
;;        (put-string x y "@" (| tb:BLACK tb:BOLD) RED);
;;
;; 2. OUTPUT_256        => [0..256]
;;    In this mode you can leverage the 256 terminal mode:
;;    0x00 - 0x07: the 8 colors as in OUTPUT_NORMAL
;;    0x08 - 0x0f: * | BOLD
;;    0x10 - 0xe7: 216 different colors
;;    0xe8 - 0xff: 24 different shades of grey
;;
;;    Example usage:
;;        (put-string x y "@" 184 240)
;;        (put-string x y "@" 0xb8 0xf0)
;;
;; 3. OUTPUT_216        => [0..216]
;;    This mode supports the 3rd range of the 256 mode only.
;;    But you don't need to provide an offset.
;;
;; 4. OUTPUT_GRAYSCALE  => [0..23]
;;    This mode supports the 4th range of the 256 mode only.
;;    But you dont need to provide an offset.
;;
;; If 'mode' is OUTPUT_CURRENT, it returns the current output mode.
;;
;; Default termbox output mode is OUTPUT_NORMAL.
(define (output-mode mode)
  (tb_select_output_mode mode))

;; @syntax (peek-event timeout)
;; @param <timeout>
;; @return <list type < list mod key ch w h x y >> 
;; Wait for an event up to 'timeout' milliseconds and fill the 'event'
;; structure with it, when the event is available. Returns the type of the
;; event or -1 if there was an error or 0 in case
;; there were no event during 'timeout' period.
;; An event, single interaction from the user. The 'mod' and 'ch' fields are
;; valid if 'type' is tb:EVENT_KEY. The 'w' and 'h' fields are valid if 'type'
;; is tb:EVENT_RESIZE. The 'x' and 'y' fields are valid if 'type' is
;; tb:EVENT_MOUSE. The 'key' field is valid if 'type' is either tb:EVENT_KEY
;; or tb:EVENT_MOUSE. The fields 'key' and 'ch' are mutually exclusive; only
;; one of them can be non-zero at a time. 
(define(peek-event timeout)
	(set 'ev (pack event))
  (set 'type (tb_peek_event ev timeout))
	(list type (unpack event ev)))


;; @syntax (poll)
;; @return <list type < list mod key ch w h x y >> 
;; Wait for an event forever and fill the 'event' structure with it, when the
;; event is available. Returns the type of the event  or -1 if there was an error.
;; An event, single interaction from the user. The 'mod' and 'ch' fields are
;; valid if 'type' is tb:EVENT_KEY. The 'w' and 'h' fields are valid if 'type'
;; is tb:EVENT_RESIZE. The 'x' and 'y' fields are valid if 'type' is
;; tb:EVENT_MOUSE. The 'key' field is valid if 'type' is either tb:EVENT_KEY
;; or tb:EVENT_MOUSE. The fields 'key' and 'ch' are mutually exclusive; only
;; one of them can be non-zero at a time.
(define (poll)
	(set 'ev (pack event))
  (set 'type (tb_poll_event ev))
	(list type (unpack event ev)))

(context 'MAIN)

(define (test-termbox)
	(tb:init)
  (tb:box 10 0 10 5 tb:GREEN tb:BLACK)
	(tb:box)
	(tb:put-string 2 0 "OPEN" tb:GREEN tb:BLACK)
  (tb:put-string 9 0 "SAVE" tb:GREEN tb:BLACK)
  (set 'ctrl nil)
	(tb:present)
  (set 'x 10)
  (while true
    (set 'e (tb:poll))
    (if (= ((e 1) tb:event->key) tb:KEY_CTRL_Q)
      (begin
        (tb:shutdown)
        (exit))
      (begin
        (set 's (char ((e 1) tb:event->ch)))
        (tb:put-string (inc x) 10 s tb:BLACK tb:WHITE)
        (tb:present)))))


