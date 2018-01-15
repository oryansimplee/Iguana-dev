function log(log_string, log_level)
   if iguana.isTest() then log_output=log_string else log_output = iguana.messageId().."-"..log_string end
	if log_level == 'info' then
      iguana.logInfo(log_output)
	elseif log_level == 'debug' then
      iguana.logDebug(log_output)         
	elseif log_level == 'error' then
      iguana.logError(log_output)            
	elseif log_level == 'warning' then
      iguana.logWarning(log_output)
	end
end