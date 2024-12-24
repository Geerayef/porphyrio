local cl = require("lua.porphyrio")

-- ---@param xs number[]
-- ---@param f fun(a: any, b: any): any
-- local accumulate = function (xs, f)
--   return function (a, b)
--     return f(a, b)
--   end
-- end

-- TODO: Complete the example.
-- Most consecutive occurences
-- local mco = function (xs)
--   return math.max(accumulate(xs, cl.phi1(cl.addl, cl.mull, cl.k1)))
-- end

-- print(mco({ 1, 0, 1, 1, 1, 0, 0, 1, 1, 0 }))

local res = cl.b(cl.add(1), cl.mul(2))(2)

print("Result: ", res)
