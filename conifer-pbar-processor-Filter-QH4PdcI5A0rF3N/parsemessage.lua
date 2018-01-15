require 'node'
-- #### Common Routines ####
-- This type of map will assign nil if the code is unknown
SexCodeMap = codemap.map{
   M='Male', 
   m='Male', 
   F='Female', 
   f='Female'
}
	 
function MapPatient(T, PID) 
   T.Id = PID[3][1][1]
   T.firstName = PID[5][1][1][1]:nodeValue()
   T.LastName = PID[5][1][1][1]:nodeValue():capitalize()
   T.Dob = PID[7][1]:D()
   T.Sex = SexCodeMap[PID[8]]
   return T
end

function MapNextOfKin(T, NK1, Id) 
   T.PatientId = Id
   T.LastName = NK1[2][1][1][1]
   T.FirstName = NK1[2][1][2]
   T.Relationship = NK1[3][1]
end
-- #### End of Common Routines ####

function NewUserMessage(message)

end
