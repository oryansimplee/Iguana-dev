--Filtering messages, returning true if message was filtered and false if we wish to continue with the message
--shared requires
require 'filtermessage'

function main(data)
   iguana.stopOnError(false)
   local msg,name = hl7.parse{vmd='example/demo.vmd', data=data}
   if filterMessage(msg) then
      return false
	else
      queue.push(data)   
      return true
	end
end