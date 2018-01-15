-- ##### Filtering Messages #####
--true means no errors
require 'hospital_codes'
require 'logger'
local SUPPORTED_EVENTS_CODE = {'A01', 'A04', 'A05', 'A08', 'A11'}

function filterMessage(msg, company)
   local configured_partner_name = "CONIFER" --os.getenv("IGUANA-PARTNER-NAME")

   if msg:nodeName() ~= 'ADT' then
      log('Unexpected message type., Supporting only ADT messages', "error")
      return false
   end
   
   local message_partner_name = getPartnerName(msg,company)
 
   if (message_partner_name ~= configured_partner_name) then
      log('Unsupported partner, received:'..message_partner_name..' expecting to get:' .. configured_partner_name, "error")
      return false
	end
   
   msh_event_type = msg.MSH.Type.Event:nodeValue()
   if unsupportedEvent(msh_event_type) then
      log('Unsupported message type, received:'..msh_event_type..' expecting to get:' .. json.serialize{data=SUPPORTED_EVENTS_CODE}, "error")
      return false
	end
   
   hospital_code = getProviderCode(msg,company)
  
   if unsupportedHospitalCode(hospital_code, company) then
      log('Unsupported facility 3 digits code, received:'..hospital_code, "error")
      return false
	end
   
   return true --Message wasn't filter, continue to process it.
end

function unsupportedEvent(msh_event_type)
   for key, value in pairs(SUPPORTED_EVENTS_CODE) do
      if msh_event_type == value then return false end
   end
   return true
end

function getPartnerName(msg,company)
   if (company =="detroit") then
     return string.upper(msg.MSH[5][1]:nodeValue())
   elseif  (company =="pbar") then
     return string.upper(msg.MSH[4][1]:nodeValue())
   end
end
function getProviderCode(msg,compnay)
   if (company =="detroit") then
     return msg.MSH[6][1]:nodeValue()
   elseif  (company =="pbar") then
     hospital_code = msg.MSH[4][2]:nodeValue()
   end
end

function unsupportedHospitalCode(hospital_code, company)
   local supported_hospital_codes = getHospitalCodes(company)
   for key, value in pairs(supported_hospital_codes) do
      if hospital_code == key then return false end
   end
   return true
end
