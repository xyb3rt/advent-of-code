#!/usr/bin/env janet

(defn decode [line]
  (map (fn [byte] (- byte 48))
       (string/bytes line)))

(defn neighbors [[x y]]
  @[[(- x 1) y] [x (- y 1)] [(+ x 1) y] [x (+ y 1)]])

(defn value [grid [x y]] (get (get grid y []) x 9))

(defn low-points [grid]
  (var lp @[])
  (loop [y :range-to [0 (length grid)]
         x :range-to [0 (length (get grid 0))]
         :let [p [x y]
               v (value grid p)]]
    (if (< v (min ;(map (fn [np] (value grid np))
                        (neighbors p))))
        (array/push lp p)))
  lp)

(def grid (map decode
               (string/split "\n"
                             (string/trimr (file/read stdin :all) "\n"))))

# sum of risk levels
(print (reduce + 0 (map (fn [p] (+ 1 (value grid p)))
                        (low-points grid))))

(defn basin [grid low-point]
  (var basin @{})
  (var front @{low-point 1})
  (while (> (length front) 0)
    (merge-into basin front)
    (var next-front @{})
    (loop [p :keys front
           np :in (filter (fn [np] (and (nil? (get basin np))
                                        (not= (value grid np) 9)))
                          (neighbors p))]
      (set (next-front np) 1))
    (set front next-front))
  (keys basin))

(print (product (take 3
  (sort (map (fn [p] (length (basin grid p)))
             (low-points grid))
        >))))
