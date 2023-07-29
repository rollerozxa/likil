-- (c) 2009-2011 John MacFarlane.  Released under MIT license.
-- See the file LICENSE in the source for details.

--- Copyright &copy; 2009-2011 John MacFarlane.
--
-- Released under the MIT license (see LICENSE in the source for details).

local G = {}

setmetatable(G,{ __index = function(t,name)
                             local mod = require("lunamark." .. name)
                             rawset(t,name,mod)
                             return t[name]
                            end })

return G
