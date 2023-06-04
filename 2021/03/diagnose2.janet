#!/usr/bin/env janet

(defn decode [s]
  (map (fn [byte] (if (= byte 49) 1 0))
       (string/bytes s)))

(defn decimal [num]
  (reduce (fn [n bit] (+ bit (* n 2))) 0 num))

(defn least-common-bit [nums pos]
  (let [bits (map (fn [num] (get num pos)) nums)
        ones (filter (fn [bit] (= bit 1)) bits)]
    (if (>= (length ones) (math/ceil (/ (length bits) 2)))
            0
            1)))

(defn filter-nums [nums bit]
  (var pos 0)
  (var nums nums)
  (while (> (length nums) 1)
    (let [bit (bxor bit (least-common-bit nums pos))]
      (set nums (filter (fn [num] (= (get num pos) bit)) nums)))
    (++ pos))
  (get nums 0))

(defn oxygen-generator-rating [nums] (decimal (filter-nums nums 1)))

(defn co2-scrubber-rating [nums] (decimal (filter-nums nums 0)))

(let [nums (map decode
                (string/split "\n"
                              (string/trimr (file/read stdin :all)
                                            "\n")))
      oxy (oxygen-generator-rating nums)
      co2 (co2-scrubber-rating nums)]
  (print oxy " " co2 " " (* oxy co2)))
