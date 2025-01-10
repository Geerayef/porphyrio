local M = {}

---@alias unary_t fun(a: any)
---@alias binary_t fun(a: any, b: any)
---@alias ternary_t fun(a: any, b: any, c: any)
---@alias discard_t any

-- Combinators -----------------------------------------------------------------

--- Bluebird | `compose`
---@type binary_t
---@param f unary_t
---@param g unary_t
---@return unary_t # Unary function, composing two unary functions: λx.f (g x) | f(g(x))
M.b = function(f, g)
  return function(x) return f(g(x)) end
end

--- Blackbird | `compose2`
---@type binary_t
---@param f unary_t
---@param g binary_t
---@return binary_t # Binary function, composing a unary and a binary function: λxy.f (g x y) | f(g(x, y))
M.b2 = function(f, g)
  return function(x, y) return f(g(x, y)) end
end

--- Bunting | `compose3`
---@type binary_t
---@param f unary_t
---@param g ternary_t
---@return ternary_t # Ternary function, composing a unary and a ternary function: λxyz.f (g x y z) | f(g(x, y, z))
M.b3 = function(f, g)
  return function(x, y, z) return f(g(x, y, z)) end
end

--- Cardinal | `flip`
---@type unary_t
---@param f binary_t
---@return binary_t # Binary function, applying `f` to its arguments in reverse: λxy.f y x | f(y, x)
M.c = function(f)
  return function(x, y) return f(y, x) end
end

--- Cardinal2 | `flip2`
---@type unary_t
---@param f ternary_t
---@return ternary_t # Ternary function, applying `f` to its arguments, reversing the first two:
---λxyz.f y x z | f(y, x, z)
M.c2 = function(f)
  return function(x, y, z) return f(y, x, z) end
end

--- Starling | `split`
---@type binary_t
---@param f binary_t
---@param g unary_t
---@return unary_t # Unary function, applying `f` to its argument and result of applying `g` to its argument:
---λx.f x (g x) | f(x, g(x))
M.s = function(f, g)
  return function(x) return f(x, g(x)) end
end

--- Starling | `split2`
---@type binary_t
---@param f ternary_t
---@param g binary_t
---@return binary_t # Unary function, applying `f` to its arguments and result of applying `g` to its arguments:
---λx.f x (g x) | f(x, g(x))
M.s2 = function(f, g)
  return function(x, y) return f(x, y, g(x, y)) end
end

--- Violet Starling | `splitr`
---@type binary_t
---@param f binary_t
---@param g unary_t
---@return unary_t # Unary function, applying `f` to result of applying `g` to its argument and its argument:
---λx.f x (g x) | f(x, g(x))
M.sr = function(f, g)
  return function(x) return f(g(x), x) end
end

--- Warbler | `double`
---@param f binary_t
---@return unary_t # Unary function, applying `f` to its argument, doubling it: λx.f x x | f(x, x)
M.w = function(f)
  return function(x) return f(x, x) end
end

--- Warbler | `double2`
---@param f ternary_t
---@return binary_t # Binary function, applying `f` to its arguments, doubling the last: λxy.f x y y | f(x, y, y)
M.w2 = function(f)
  return function(x, y) return f(x, y, y) end
end

--- Ψ | `distribute`
---@type binary_t
---@param f binary_t
---@param g unary_t
---@return binary_t # Binary function, composing a binary and a unary function: λxy.f (g x) (g y) | f(g(x), g(y))
M.psi = function(f, g)
  return function(x, y) return f(g(x), g(y)) end
end

--- Φ (Phoenix) | `cross`
---@type ternary_t
---@param f binary_t
---@param g unary_t
---@param h unary_t
---@return unary_t # Unary function, composing a binary and two unary functions: λx.f (g x) (h x) | f(g(x), h(x))
M.phi = function(f, g, h)
  return function(x) return f(g(x), h(x)) end
end

--- Φ1 (Pheasant) | `cross2`
---@type ternary_t
---@param f binary_t
---@param g binary_t
---@param h binary_t
---@return binary_t # Binary function, composing binary-unary-binary functions: λxy.f (g x) (h x y) | f(g(x), h(x, y))
M.phi2 = function(f, g, h)
  return function(x, y) return f(g(x, y), h(x, y)) end
end

--- Kestrel | `drop`
---@type binary_t
---@param x any
---@param _ discard_t
---@return any # First argument to this function, a constant: λxy.x | f(x, y) -> x
M.k = function(x, _) return x end

--- Kite | `drop2`
---@type binary_t
---@param _ discard_t
---@param y any
---@return any # Second argument to this function, a constant: λxy.y | f(x, y) -> y
M.k2 = function(_, y) return y end

-- Convient unary/binary operations --------------------------------------------

M.util = {}

--- Addition by x
---@type unary_t
---@param x number
---@return fun(y: number): number # Unary function, summing its argument with `x`
M.util["add"] = function(x)
  return function(y) return x + y end
end

--- Multiplication by x
---@type unary_t
---@param x number
---@return fun(y: number): number # Unary function, multiplying its argument with `x`
M.util["mul"] = function(x)
  return function(y) return x * y end
end

--- Head | `fst`
---@param x table
---@return any # First element of `x`
M.util["fst"] = function(x) return x[1] end

--- Neck | `snd`
---@param x table
---@return any # Second element of `x`
M.util["snd"] = function(x) return x[2] end

-- Aliases: combinators --------------------------------------------------------

M.alias = {
  ["compose"] = M.b,
  ["compose2"] = M.b2,
  ["compose3"] = M.b3,
  ["flip"] = M.c,
  ["flip2"] = M.c2,
  ["split"] = M.s,
  ["split2"] = M.s2,
  ["splitr"] = M.sr,
  ["double"] = M.w,
  ["double2"] = M.w2,
  ["distribute"] = M.psi,
  ["cross"] = M.phi,
  ["cross2"] = M.phi2,
  ["drop"] = M.k,
  ["drop2"] = M.k2,
  ["add"] = M.util.add,
  ["mul"] = M.util.mul,
  ["fst"] = M.util.fst,
  ["snd"] = M.util.snd,
}

return M
