--- All the batteries you need for advent of code!
--[[
    |,\/,| |[_' |[_]) |[_]) \\//
    ||\/|| |[_, ||'\, ||'\,  ||

            ___ __ __ ____  __  __  ____  _  _    __    __
           // ' |[_]| |[_]) || ((_' '||' |,\/,|  //\\  ((_'
           \\_, |[']| ||'\, || ,_))  ||  ||\/|| //``\\ ,_))


                                         ,;7,
                                       _ ||:|,
                     _,---,_           )\'  '|
                   .'_.-.,_ '.         ',')  j
                  /,'   ___}  \        _/   /
      .,         ,1  .''  =\ _.''.   ,`';_ |
    .'  \        (.'T ~, (' ) ',.'  /     ';',
    \   .\(\O/)_. \ (    _Z-'`>--, .'',      ;
     \  |   I  _|._>;--'`,-j-'    ;    ',  .'
    __\_|   _.'.-7 ) `'-' "       (      ;'
  .'.'_.'|.' .'   \ ',_           .'\   /
  | |  |.'  /      \   \          l  \ /
  | _.-'   /        '. ('._   _ ,.'   \i
,--' ---' / k  _.-,.-|__L, '-' ' ()    ;
 '._     (   ';   (    _-}             |
  / '     \   ;    ',.__;         ()   /
 /         |   ;    ; ___._._____.: :-j
|           \,__',-' ____: :_____.: :-\
|               F :   .  ' '        ,  L
',             J  |   ;             j  |
  \            |  |    L            |  J
   ;         .-F  |    ;           J    L
    \___,---' J'--:    j,---,___   |_   |
              |   |'--' L       '--| '-'|
               '.,L     |----.__   j.__.'
                | '----'   |,   '-'  }
                j         / ('-----';
               { "---'--;'  }       |
               |        |   '.----,.'
               ',.__.__.'    |=, _/
                |     /      |    '.
                |'= -x       L___   '--,
          snd   L   __\          '-----'
                 '.____)
]]
local check = assert
local err = error
local iter = pairs
local enum = ipairs
local print = print
local to_n = tonumber
local to_s = tostring
local setm = setmetatable
local getm = getmetatable
local open = io.open
local itype = io.type
local insert = table.insert
local move = table.move
local concat = table.concat
local unpak = table.unpack
local pak = table.pack
local min = math.min
local globals = _G

local _ENV = {}

globals.xmas = _ENV

local docs = {}
-- luacheck: ignore 111

function help(fn)
    local doc
    for k , v in iter(_ENV) do
        if fn == v or fn == k  then
            doc = docs[k]
            break
        end
    end
    print(doc)
end

function slurp(path)
    local file
    if itype(path) == "file" then
        file = path
    else
        file = check(open(path, 'r'))
    end
    local content = file:read"a"
    file:close()
    return content
end

docs.slurp = [[
    slurp(path)
Reads from the file at *path*, returning its contents as a string.
]]

function save(path, ...)
    local file
    if itype(path) == "file" then
        file = path
    else
        file = check(open(path, 'w'))
    end
    file:write(...)
    file:close()
end

docs.save = [[
    save(path, ...)
Writes to the file at *path*, concatenating all further arguments as the contents.
]]

function lines_of_numbers(path)
    local file
    if itype(path) == "file" then
        file = path
    else
        file = check(open(path, 'r'))
    end
    local out = {}
    for line in file:lines() do
        insert(out, to_n(line))
    end
    return out
end

docs.lines_of_numbers = [[
    lines_of_numbers(path)
Reads from the file at *path*, returning its contents as a sequence of lines of numbers.
    Returns a table of the numbers.
]]

function bind(f, a)
    return function(...) return f(a, ...) end
end

docs.bind = [[
    bind(f, a)
Bind the first argument of *f* to *a*, returning a new function
    which accepts the rest of the arguments to *f*.
]]

function map(f, t)
    local out = { }
    for k , v in iter(t) do out[k] = f(v) end
    return setm(out, getm(t))
end

docs.map = [[
    map(f, t)
Applies the function *f* over the values of table *t*,
    constructing a new table whose values are the function's subsequent results.
]]

function filter(f, t)
    local out = { }
    for k , v in iter(t) do if f(v) then out[k] = v end end
    return setm(out, getm(t))
end

docs.filter = [[
    filter(f, t)
Applies the function *f* over the values of table *t*,
    constructing a new table which only contains values for which the function returned truthy.
]]

function find(f, t, ...)
    for k , v in iter(t) do if f(v) then return k, v end end
    return ...
end

docs.find = [[
    find(f, t, ...)
Applies the function *f* over the values of table *t*,
    returns the first value for which the function returned truthy.
    If no such values are found, returns all other arguments.
]]

function foldl(f, t, a, ...)
    for _, v in enum(t) do
        a = f(a, v, ...)
    end
    return a
end

docs.foldl = [[
    foldl(f, t, a, ...)
Applies the function *f* to *a* and each element of *t*, changing the value of *a* to the return value each time.
    Returns the final value of *a*. Passes any extra arguments to *f*.
]]

function foldr(f, t, a, ...)
    for i = #t, 1, -1 do
        local v = t[i]
        a = f(a, v, ...)
    end
    return a
end

docs.foldr = [[
    foldl(f, t, a, ...)
Applies the function *f* to *a* and each element of *t* from the right, changing the value of *a* to the return value each time.
    Returns the final value of *a*. Passes any extra arguments to *f*.
]]


function scan(f, t, ...)
    local a = t[1]
    local out = {a}
    for i = 2, #t do
        local v = t[i]
        a = f(a, v, ...)
        insert(out, a)
    end
    return setm(out, getm(t))
end

docs.scan = [[
    scan(f, t, ...)
Creates a table containing the cumulative product of applying *f* over elements of *t*.
    This is effectively a list of all the "a" values produced by a foldl. Passes any extra arguments to *f*.
]]

local function _rest(t)
    return setm({unpak(t, 2)}, getm(t))
end

local rest_vs = setm({}, {__mode = "k"})

function rest(t)
    if rest_vs[t] then return rest_vs[t]
    else
        local r = _rest(t)
        rest_vs[t] = r
        return r
    end
end

docs.rest = [[
    rest(t)
Returns a new table which contains all elements of *t* except the first.
]]

function zip(f, t, t2)
    local len = min(#t, #t2)
    local out = { }
    for i = 1, len do
        out[i] = f(t[i], t2[i])
    end
    return setm(out, getm(t) or getm(t2))
end

docs.zip = [[
    zip(f, t, t2)
Creates a table by calling *f* on each element of *t* and *t2* pairwise.
    The function should accept two arguments.
    The table with the smaller length will determine the length of the result.
]]

function zip_3(f, t, t2, t3)
    local len = min(#t, #t2, #t3)
    local out = { }
    for i = 1, len do
        out[i] = f(t[i], t2[i], t3[i])
    end
    return setm(out, getm(t) or getm(t2) or getm(t3))
end


docs.zip = [[
    zip_3(f, t, t2, t3)
Creates a table by calling *f* on each element of *t*, *t2*, and *t3* triplet-wise.
    The function should accept three arguments.
    The table with the smallest length will determine the length of the result.
]]

function count(f, t)
    local i = 0
    for _, v in iter(t) do
        if f(v) then i = i + 1 end
    end
    return i
end

docs.count = [[
    count(f, t)
Returns the number of times the function *f* returns truthy for elements of *t*.
]]

local vmt = {__tostring = function(self)
    local buf = {'{'}
    if #self > 0 then
        for i , v in enum(self) do
            buf[i+ 1] = to_s(v)
        end
    else
        for k , v in iter(self) do
            buf[#buf+ 1] = ("%s = %s"):format(k, v) .. ","
        end
        buf[#buf] = buf[#buf]:sub(1, -2)
    end
    buf[#buf + 1] = '}'
    return concat(buf, " ")
end}

function visualize(t)
    return setm(t, vmt)
end

docs.visualize = [[
    visualize(t)
Attaches a metatable to *t* with a suitable tostring metamethod for printing.
]]

local function in_range(f, s, l) return s <= f and f <= l end

function rotate(t, new_first, r1, r2)
    local size = #t
    local first = (r2 and to_n(r1)) or 1
    local last = (r2 and to_n(r2)) or (r1 and to_n(r1)) or size


    if first < 0 then first = size - first + 1 end

    if last < 0 then last = size - last + 1 end

    if new_first < 0 then new_first = size - new_first + 1 end

    if not (in_range(first, 1, size) and in_range(last, 1, size)) then
        return err"Integer is not a valid rotate index!"
    end

    if not in_range(new_first, first, last) then
        return err"Integer does not lie within supplied bounds!"
    end

    if first == new_first then return t
    elseif new_first == last then
        local out = {} if first ~= 1 then move(t, 1, first - 1, 1, out) end
        move(t, first, new_first - 1, first + 1, out)
        out[first] = t[last]
        if last ~= size then move(t, last + 1, size,1 + new_first, out) end
        return out
    else
        local out = {} if first ~= 1 then move(t, 1, first - 1, 1, out) end

        move(t, new_first, last, first, out)

        move(t, first, new_first - 1, last - new_first + 1 + first, out)

        if last ~= size then move(t, last + 1, size, last + new_first - first - 1, out) end

        return out
    end
end

docs.rotate = [[
    rotate(t, new_first, r1, r2)
Rotates a subsection of the table *t* such that the element at *new_first* is the first element.
    *r1* and *r2* can be used to optionally specify a range:
        If just *r1* is provided the range is [1, r1],
        otherwise the range is [r1, r2].
        You may use negative values to specify a range relative to the end.
]]

return _ENV