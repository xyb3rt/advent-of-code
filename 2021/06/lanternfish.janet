#!/usr/bin/env janet

(defn count [fishies] (reduce + 0 fishies))

(defn next-day [prev]
  (let [zero (get prev 0)
        next (array/concat (array/slice prev 1) @[zero])]
    (+= (next 6) zero)
    next))

(def start
  (map (fn [s] (int/to-number (int/u64 s)))
       (string/split "," (string/trimr (file/read stdin :line) "\n"))))
(var fishies (array/new-filled 9 0))
(loop [age :in start]
  (++ (fishies age)))

(loop [day :range [0 256]]
  (if (= day 80) (print (count fishies)))
  (set fishies (next-day fishies)))

(print (count fishies))
