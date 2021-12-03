local xmas = dofile"xmas.lua"

local function forward(state, N)
    state._1.horizontal = state._1.horizontal + N
    state._2.horizontal = state._2.horizontal + N
    state._2.depth = state._2.depth + state._2.aim * N
end

local function up(state, N)
    state._1.depth = state._1.depth - N
    state._2.aim = state._2.aim - N
end

local function down(state, N)
    state._2.aim = state._2.aim + N
    state._1.depth = state._1.depth + N
end

local STATE = xmas.visualize_all{_1 = {horizontal = 0, depth = 0}, _2 = {aim = 0, depth = 0, horizontal = 0}}

local input = xmas.enum_1('inputs/day-02',{
    forward = xmas.bind(forward, STATE),
    up = xmas.bind(up, STATE),
    down = xmas.bind(down, STATE),
}, tonumber)

xmas.each(function(x) return x[1](x[2]) end, input)

print(STATE, STATE._1.horizontal * STATE._1.depth, STATE._2.horizontal * STATE._2.depth)