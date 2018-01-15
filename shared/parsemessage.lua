require 'codemap'
require 'dateparse'
require 'node'
require 'stringutil'

require 'hospital_codes'
require 'logger'

function parseMessage(msg)
   patient_details_json = nil
   patient_details = msg.PID
   msh_event_type = msg.MSH[9][2]:nodeValue()
   if ( (msh_event_type == 'A01') or (msh_event_type == 'A04') or (msh_event_type == 'A05') or (msh_event_type == 'A08')) then
      log('Starting to parse patient data, event type:' .. msh_event_type, "debug")
      patient_details_json = buildAdmissionHL7Json(msg, msh_event_type)
   else 
      log("Not supported MSH event:" .. msh_event_type, "warning")
	end
   return patient_details_json
end

sexCodeMap = codemap.map{
   M='Male',
   m='Male',
   F='Female',
   f='Female'
}

function buildAdmissionHL7Json(msg, msh_event_type)
   hl7_json = json.createObject()
   hl7_json.provider = getProviderName(msg.MSH[4][2]:nodeValue())
   hl7_json.message_type = msh_event_type
   hl7_json.message_id = iguana.messageId()
   hl7_json.message_control_id = msg.MSH[10]:nodeValue()
   hl7_json.account = buildAccountJson(msg.PID, msg.GT1)
   hl7_json.bills = buildBillsJson(msg.PV1, msg.PID, hl7_json.provider)
   hl7_json.extra_fields = setExtraFields()
   return hl7_json
end
	 
function buildAccountJson(pid_details, gt_details)
   local account_json = json.createObject()
   account_json.account_number = pid_details[2][1]:nodeValue()
   account_json.guarantor = buildGuarantorJson(gt_details)
   return account_json
end

function buildGuarantorJson(gt_details)
   local guarantor_json = json.createObject()
   guarantor_json.first_name = gt_details[1][3][1][2]:nodeValueOrNil()
   guarantor_json.last_name = gt_details[1][3][1][1][1]:nodeValueOrNil()
   guarantor_json.middle_name = gt_details[1][3][1][3]:nodeValueOrNil()
   guarantor_json.date_of_birth = gt_details[1][8]:nodeValue():D()
   guarantor_json.social_security_number = gt_details[1][12]:nodeValueOrNil()
   guarantor_json.gender = gt_details[1][9]:nodeValueOrNil()
   return guarantor_json
end

function buildBillsJson(visit_details, patient_details, provider)
   bills_array = json.createObject()
   bill_json = buildBillJson(visit_details, patient_details, provider)
   bills_array[1] = bill_json
   return bills_array
end

function buildBillJson(visit_details, pid_details, provider)
   local bill_json = json.createObject()
   bill_json.service_date =  visit_details[44]:D()
   bill_json.patient_number = pid_details[18][1]:nodeValueOrNil()
   bill_json.patient = buildPatientJson(pid_details)
   bill_json.patient_type = visit_details[18]:nodeValueOrNil()
--   bill_json.ace_master_id = pid_details[2][1]:nodeValue()
   bill_json.provider = provider
   return bill_json
end

function buildPatientJson(pid_details)
   local patient_json = json.createObject()
   patient_json.first_name = pid_details[5][1][2]:nodeValueOrNil()
   patient_json.last_name = pid_details[5][1][1][1]:nodeValueOrNil()
   patient_json.middle_name = pid_details[5][1][3]:nodeValueOrNil()
   patient_json.date_of_birth = pid_details[7][1]:D()
   patient_json.social_security_number = pid_details[19]:nodeValueOrNil()
   patient_json.gender = pid_details[8]:nodeValueOrNil()
   return patient_json
end

function getProviderName(provider_code)
   return getHospitalNameByCode(provider_code)
end

function setExtraFields()
   extra_fields_json = json.createObject()
   extra_fields_json.listener_processed_timestamp = os.ts.date('%d-%m-%Y %H:%M:%S')
   return extra_fields_json
end