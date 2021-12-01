local xmas = dofile"xmas.lua"

local input = xmas.lines_of_numbers"inputs/day-01"

local input_2 = xmas.rest(input)
local input_3 = xmas.rest(input_2)

local function num_increases(T)
    return xmas.count(
        function(x) return x > 0 end,
        xmas.zip(function(a, b) return b - a end, T, xmas.rest(T))
    )
end

-- part one
print(
    num_increases(input)
)

-- part two
local windows = xmas.zip_3(function(a,b,c) return a + b + c end,input, input_2, input_3)
print(
   num_increases(windows)
)

