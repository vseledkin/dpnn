local Container = nn.Container

-- multi-add
function Container:extend(...)
   for i,module in ipairs{...} do
      self:add(module)
   end
   return self
end

-- overriden to handle sparse parameters
function Container:parameters()
    local params = {}
    local gradParams = {}
    local scales = {}
    local size = 0
    for i=1,#self.modules do
        local mParams, mGradParams, mScales, mSize = self.modules[i]:parameters()
        if mParams then
            for k,param in pairs(mParams) do
               assert(torch.type(param) ~= 'table')
               params[size+k] = param
               gradParams[size+k] = mGradParams[k]
               scales[size+k] = mScales and mScales[k]
            end
            size = size + (mSize or #params)
        end
    end
    return params, gradParams, scales, size
end