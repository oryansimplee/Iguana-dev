require 'logger'
function sendHttpToSimplee(patient_details)
   log("Sending request simplee Api to store data" .. json.serialize{data=patient_details, compact=true}, 'debug')   
   if iguana.isTest() then timeout = 15 else timeout = 3 end
   if iguana.isTest() then live_flag = true else live_flag = false end
   local results, code, headers = net.http.post{
	      url = os.getenv("IGUANA-SIMPLEE-API-URL") .. "/message", 
	      headers = {["Content-Type"] = "application/json"}, 
	      body = json.serialize{data=patient_details, compact=true},
         timeout = timeout, -- seconds
	      live = live_flag}
   if (code == 200) then
      log("Response from SimpleeApi, code:" .. code .. "\n Results:" .. results, "debug")
      return true
	else
      log("Error Response from SimpleeApi, code:" .. code .. "\n Results:" .. results, "error")
      return false
	end   
end