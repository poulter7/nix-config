(defvar
   tap-time 200
   hold-time 200
)

(defalias
    esc       (tap-hold $tap-time $hold-time esc lctl)
    nav       (layer-while-held nav)
    blank_nav (tap-hold $tap-time $hold-time XX @nav)
)

(defsrc 
  caps h j k l lalt
)

(deflayer base
@esc h j k l @nav
)

(deflayer nav
_ left down up right _
)

