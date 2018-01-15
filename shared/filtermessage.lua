-- ##### Filtering Messages #####
--true means message was filtered
require 'hospital_codes'
require 'logger'
local SUPPORTED_EVENTS_CODE = {'A01', 'A04', 'A05', 'A08', 'A11'}

function filterMessage(msg)
   local configured_partner_name = os.getenv("IGUANA-PARTNER-NAME")
   if msg:nodeName() ~= 'ADT' then
      log('Unexpected message type., Supporting only ADT messages', "error")
      return true
   end
   
   local message_partner_name = msg.MSH[4][1]:nodeValue()
   if (message_partner_name ~= configured_partner_name) then
      log('Unsupported partner, received:'..message_partner_name..' expecting to get:' .. configured_partner_name, "error")
      return true
	end
   
   msh_event_type = msg.MSH.Type.Event:nodeValue()
   if unsupportedEvent(msh_event_type) then
      log('Unsupported message type, received:'..msh_event_type..' expecting to get:' .. json.serialize{data=SUPPORTED_EVENTS_CODE}, "error")
      return true
	end
   
   hospital_code = msg.MSH[4][2]:nodeValue()
   if unsupportedHospitalCode(hospital_code) then
      log('Unsupported facility 3 digits code, received:'..hospital_code, "error")
      return true
	end
   
   return false --Message wasn't filter, continue to process it.
end

function unsupportedEvent(msh_event_type)
   for key, value in pairs(SUPPORTED_EVENTS_CODE) do
      if msh_event_type == value then return false end
   end
   return true
end

function unsupportedHospitalCode(hospital_code)
   local supported_hospital_codes = getHospitalCodes()
   for key, value in pairs(supported_hospital_codes) do
      if hospital_code == key then return false end
   end
   return true
end
