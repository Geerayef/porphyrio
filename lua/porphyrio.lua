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

--- Blackbird | `compose`
---@type binary_t
---@param f unary_t
---@param g binary_t
---@return binary_t # Binary function, composing a unary and a binary function: λx.λy.f (g x y) | f(g(x, y))
M.b1 = function(f, g)
  return function(x, y) return f(g(x, y)) end
end

--- Ψ | `distribute`
---@type binary_t
---@param f binary_t
---@param g unary_t
---@return binary_t # Binary function, composing a binary and a unary function: λx.λy.f (g x) (g y) | f(g(x), g(y))
M.psi = function(f, g)
  return function(x, y) return f(g(x), g(y)) end
end

--- Φ1 | `fork`
---@type ternary_t
---@param f binary_t
---@param g binary_t
---@param h binary_t
---@return binary_t # Binary function, composing three binary functions: λx.λy.g (f x y) (h x y) | g(f(x, y), h(x, y))
M.phi1 = function(f, g, h)
  return function(x, y) return g(f(x, y), h(x, y)) end
end

--- Kestrel | `first`
---@type binary_t
---@param x any
---@param _ discard_t
---@return any # First argument to this function, a constant: λx.λy.x | f(x, y) -> x
M.k = function(x, _) return x end

--- Kite | `second`
---@type binary_t
---@param _ discard_t
---@param y any
---@return any # Second argument to this function, a constant: λx.λy.y | f(x, y) -> y
M.k1 = function(_, y) return y end

--- Diagonalise
---@param f binary_t
---@return unary_t # Unary function, doubling its argument, applying `f` to them: λx.f x x | f(x, x)
M.w = function(f)
  return function(x) return f(x, x) end
end

--- Curry
---@param f binary_t
---@return binary_t # Binary function, applying `f` to its, reversed, arguments
M.c = function(f)
  return function(x, y) return f(y, x) end
end

-- Convient unary/binary operations --------------------------------------------

--- Addition by x
---@type unary_t
---@param x number
---@return fun(y: number): number  # Unary function, summing its argument with `x`
M.util.add = function(x)
  return function(y) return x + y end
end

--- Multiplication by x
---@type unary_t
---@param x number
---@return fun(y: number): number # Unary function, multiplying its argument with `x`
M.util.mul = function(x)
  return function(y) return x * y end
end

--- Head | first
---@param x table
---@return any # First element of `x`
M.util.fst = function(x) return x[1] end

--- "Neck" | second
---@param x table
---@return any # Second element of `x`
M.util.snd = function(x) return x[2] end

--- Flip
---@type binary_t
---@param x any
---@param y any
---@return any, any # The two arguments, in reverse order
M.util.flip = function(x, y) return y, x end

-- Aliases: combinators --------------------------------------------------------

M.alias = {
  ["compose"] = M.b,
  ["compose1"] = M.b1,
  ["distribute"] = M.psi,
  ["fork"] = M.phi1,
  ["first"] = M.k,
  ["second"] = M.k1,
  ["diagon"] = M.w,
  ["curry"] = M.c,
  ["add"] = M.util.add,
  ["mul"] = M.util.mul,
  ["head"] = M.util.fst,
  ["neck"] = M.util.snd,
  ["flip"] = M.util.flip,
}

return M
