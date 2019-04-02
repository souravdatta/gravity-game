#lang racket

(require 2htdp/image)
(require 2htdp/universe)

(define gscale 0.01)
(define tscale 0.03)
(define boundary-x 640)
(define boundary-y 480)
(define dthrust 6)
(define ithrust 20)

(struct world [gravity object])
(struct ball [radius thrust x y dy])

(define (create-world gravity radius thrust ox oy dy)
  (world gravity
         (ball radius thrust ox oy dy)))

(define (make-world)
  (create-world 9.8 10 20 80 20 1))

(define (draw-world w)
  (let ([o (world-object w)])
    (if (>= (ball-y o) (- 20))
        (overlay/xy (rectangle boundary-x boundary-y "outline" "black")
                    (ball-x o) (ball-y o)
                    (circle (ball-radius o) "solid" "brown"))
        (rectangle boundary-x boundary-y "outline" "black"))))

(define (world-tick w)
  (println (ball-thrust (world-object w)))
  (let ([o (world-object w)])
    (create-world (world-gravity w)
                  (ball-radius o)
                  (if (<= (ball-thrust o) 0)
                      0
                      (- (ball-thrust o) dthrust))
                  (ball-x o)
                  (+ (ball-y o) (ball-dy o))
                  (+ (ball-dy o) (* gscale (world-gravity w)) (* tscale (- (ball-thrust o)))))))

(define (end-simulation? w)
  (let ([o (world-object w)]
        [diameter (* 2 (ball-radius (world-object w)))])
    (> (+ (ball-y o) (ball-radius o)) (+ boundary-y diameter))))

(define (apply-thrust w)
  (let ([o (world-object w)])
    (create-world (world-gravity w)
                  (ball-radius o)
                  (+ (ball-thrust o) ithrust)
                  (ball-x o)
                  (ball-y o)
                  (ball-dy o))))

(define (on-key-world w key)
  (if (key=? key "up")
      (apply-thrust w)
      w))

(big-bang (make-world)
  (to-draw draw-world)
  (on-tick world-tick)
  (on-key on-key-world)
  (stop-when end-simulation?))

