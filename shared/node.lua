function node.S(ANode)
   return tostring(ANode)
end

function node.round(self, p)
   local o = 10^(p or 0)
   return math.floor(self:S()*o+0.5)/o
end


function node.V(ANode)
   return node.nodeValue(ANode)
end

function node.stripTrailingPipe(self,d)
   local sum=''
   local NodeType, ProtocolType = self:nodeType()
   if NodeType ~= 'message' or ProtocolType ~= 'hl7' then
      error('Expected hl7 message, got '..ProtocolType..' '..NodeType, 2)
   end
   for i = 1, #self do
      if self[i]:nodeType() == 'segment' then
         local s=self[i]:S()
         s=s:sub(1,s:len()-1) 
         sum=sum..s..'\r'     
      end
   end
   return sum   
end


function node:T(fmt) return tostring(self):T(fmt) end


function node:D(fmt) return tostring(self):D(fmt) end


function node:AD(fmt) return tostring(self):AD(fmt) end


function node:BD(fmt) return tostring(self):BD(fmt) end


function node:CD(fmt) return tostring(self):CD(fmt) end


function node:AD2DB(fmt) return tostring(self):AD2DB(fmt) end

function node:nodeValueOrNil(s)
   s = tostring(self)
	if s ~= nil and s:match("%S") ~= nil then return s else return nil end   
end