--Filtering messages, returning true if message was filtered and false if we wish to continue with the message
--shared requires
require 'filtermessage'
require 'parsemessage'
require 'http'


function processData(data, company)
   iguana.stopOnError(false)
   filterData(data, company)   
end

function filterData(data,company)
   local msg,name = hl7.parse{vmd='example/demo.vmd', data=data}
   if filterMessage(msg, company) then
       parseData(msg, company) 
	else
      return false  
	end
end

function parseData(msg, company)
   local parsed_data = parseMessage(msg, company)
   if parsed_data then
      data=json.serialize{data=parsed_data, compact = true}
      sendDataToSimplee(data)
	else
      return false
	end
end

function sendDataToSimplee(data)
   local patient_details = json.parse{data=data}
   return sendHttpToSimplee(patient_details)
end