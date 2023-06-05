#!/usr/bin/env janet

(defn lin-fuel [dist] dist)
(defn exp-fuel [dist] (/ (* dist (+ dist 1)) 2))

(defn cost [burn-fuel crabs pos]
  (reduce + 0 (map (fn [crab] (burn-fuel (math/abs (- pos crab)))) crabs)))

(defn lowest-cost [burn-fuel crabs]
  (var lowest -1)
  (loop [pos :range [(min ;crabs) (+ (max ;crabs) 1)]
         :let [cost (cost burn-fuel crabs pos)]]
    (set lowest (if (= lowest -1) cost (min lowest cost))))
  lowest)

(def crabs
  (map (fn [s] (int/to-number (int/u64 s)))
       (string/split "," (string/trimr (file/read stdin :line) "\n"))))

(print (lowest-cost lin-fuel crabs))
(print (lowest-cost exp-fuel crabs))
