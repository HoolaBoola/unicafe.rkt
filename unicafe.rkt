#!/usr/bin/env racket
#lang racket/base
(require racket/list 
         racket/format 
         racket/port 
         racket/string
         racket/cmdline
         net/url
         json
         racket/date)

; https://docs.racket-lang.org/json/index.html
; https://medium.com/chris-opperwall/practical-racket-using-a-json-rest-api-3d85eb11cc2d
; https://unicafe.fi/wp-json/swiss/v1/restaurants/?lang=fi

(define chosen-cafes
  (command-line
   #:usage-help
   "Get today's menu for your chosen Unicafe restaurant"
   "Give any number of unicafe restaurant names as argument (case insensitive)"
   ""
   "List of valid unicafe names, as of writing this:"
   "\tKaivopiha, WELL Terkko, WELL Kaisa-talo, Viikuna, Soc&Kom, "
   "\tRotunda, Ravintola Oliver, Porthania Opettajien ravintola, "
   "\tPorthania, Physicum, Pesco & Vege Topelias, Olivia, Metsätalo, "
   "\tMeilahti, Infokeskus, Exactum, Chemicum, "
   "\tChemicum Opettajien ravintola, Cafe Portaali, Biokeskus" 

   #:args args

   (map (lambda (arg)
          (string-downcase arg))
        args)))

(if (empty? chosen-cafes)
  ((displayln "Enter at least one unicafe name\n (Hint: use the --help argument for a list of cafe names)")
   (exit))
  (void))

(define (get-json url)
  (call/input-url (string->url url)
                  get-pure-port
                  (compose string->jsexpr port->string)))

(define cafedata (get-json "https://unicafe.fi/wp-json/swiss/v1/restaurants/?lang=fi"))


(define (pad-number number)
  (~a number #:min-width 2 #:align 'right #:left-pad-string "0"))

(define today (string-append (pad-number (date-day (current-date))) 
                             "." 
                             (pad-number (date-month (current-date)))))

; Find the cafes whose names are in `chosen-cafes`
(define cafes (filter (lambda (cafe)
                        (member (string-downcase (hash-ref cafe 'title)) chosen-cafes))
                      cafedata))

(if (empty? cafes) (displayln "None of the arguments matched a Unicafe name \n (Hint: use the --help argument for a list of cafe names)") (void))

(define (print-json json) 
  (displayln (jsexpr->string json)))

(define (get-lunch cafe)
  (define today-lunch
    (filter (lambda (day)
              (string-contains? (hash-ref day 'date) today))
            cafe))
  (hash-ref (first today-lunch) 'data))

(displayln "")

(for-each (lambda (cafe)
            (define title (hash-ref cafe 'title))
            (displayln title)
            (displayln (~a "" #:min-width (string-length title) #:pad-string "-"))

            (define lunch (get-lunch (hash-ref (hash-ref cafe 'menuData) 'menus)))
            (define (yes-lunch) 
              (for-each (lambda (choice)
                          (displayln (hash-ref (hash-ref choice 'price) 'name))
                          (displayln (hash-ref choice 'name))
                          (displayln ""))
                        lunch))
            (define (no-lunch)
              (displayln "No food :("))

            (if (empty? lunch) (no-lunch) (yes-lunch)) 
            (displayln ""))
          cafes)
