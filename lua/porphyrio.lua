local M = {}

---@alias unary_t fun(x: any)
---@alias binary_t fun(x: any, y: any)
---@alias ternary_t fun(x: any, y: any, z: any)
---@alias discard_t any

-- Combinators -----------------------------------------------------------------

--- Bluebird | `compose`
---@type binary_t
---@param f unary_t
---@param g unary_t
---@return unary_t # Unary function, composing two unary functions: (f • g)(x)
M.b = function(f, g)
  return function(x)
    return f(g(x))
  end
end

--- Blackbird | `compose`
---@type binary_t
---@param f unary_t
---@param g binary_t
---@return binary_t # Binary function, composing a unary and a binary function: (f • g)(x, y)
M.b1 = function(f, g)
  return function(x, y)
    return f(g(x, y))
  end
end

--- Ψ | `distribute`
---@type binary_t
---@param f binary_t
---@param g unary_t
---@return binary_t # Binary function, composing a binary and a unary function: (f • (g × g))(x, y)
M.psi = function(f, g)
  return function(x, y)
    return f(g(x), g(y))
  end
end

--- Φ1 | `fork`
---@type ternary_t
---@param f binary_t
---@param g binary_t
---@param h binary_t
---@return binary_t # Binary function, composing g • (f × h)(x, y) ×
M.phi1 = function(f, g, h)
  return function(x, y)
    return g(f(x, y), h(x, y))
  end
end

--- Kestrel | `true`
---@type binary_t
---@param x any
---@param _ discard_t
---@return any # First argument to this function
M.k = function(x, _)
  return x
end

--- Kite | `false`
---@type binary_t
---@param _ discard_t
---@param y any
---@return any # Second argument to this function
M.k1 = function(_, y)
  return y
end

-- Convient unary/binary operations --------------------------------------------

--- Addition by x
---@type unary_t
---@param x number
---@return fun(y: number): number  # Unary function, summing its argument with `x`
M.add = function(x)
  return function(y)
    return x + y
  end
end

--- Multiplication by x
---@type unary_t
---@param x number
---@return fun(y: number): number # Unary function, multiplying its argument with `x`
M.mul = function(x)
  return function(y)
    return x * y
  end
end

M.i1 = function(x)
  return x[1]
end

M.i2 = function(x)
  return x[2]
end

-- Aliases: combinators --------------------------------------------------------

M.alias = {
  ["compose"] = M.b,
  ["ccompose"] = M.b1,
  ["distribute"] = M.psi,
  ["fork"] = M.phi1,
  ["left"] = M.k,
  ["right"] = M.k1,
  ["head"] = M.i1,
  ["hhead"] = M.i2
}

return M
