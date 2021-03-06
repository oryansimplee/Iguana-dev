
function getMessagePartnerName(msg,company)
   if (company =="detroit") then
     return string.upper(msg.MSH[5][1]:nodeValue())
   elseif  (company =="pbar") then
     return string.upper(msg.MSH[4][1]:nodeValue())
   end
end

function getCompanyName(msg,company)
   if (company =="detroit") or (company =="pbar")   then
     return "CONIFER"
   end
end

function getPartnerCode(msg,company)
   if (company =="detroit") then
     return msg.MSH[6][1]:nodeValue()
   elseif  (company =="pbar") then
     return msg.MSH[4][2]:nodeValue()
   end
end

function getHospitalCodes(company)
   conifer_detroit_hospital_table = {
      ['H'] = "cn_dhr", --"DMC Harper University Hsp / Hutzel", 
      ['S'] = "cn_dsh", --"DMC Sinai-Grace Hsp", 
      ['V'] = "cn_dhv", --"DMC Huron Valley - Sinai Hsp",
      ['R'] = "cn_dra", --"DMC Rehab Institute of Michigan", 
      ['D'] = "cn_ddr", --"DMC DMC Detroit Receiving Hsp/", 
      ['C'] = "cn_dcr", --"DMC Children's Hsp of Michigan",
   }
   conifer_pbar_hospital_table = {
      ['006'] = "cn_del", --"Delray Medical Center", 
      ['009'] = "cn_lak", --"Lakewood Regional Medical Center", 
      ['012'] = "cn_mod", --"Doctors Medical Center of Modesto",
      ['018'] = "cn_ind", --"JFK Memorial Hospital",
      ['023'] = "cn_lom", --"Los Alamitos Medical Center",
      ['025'] = "cn_man", --"Doctors Hospital of Manteca",
      ['035'] = "cn_pla", --"Placentia Linda Hospital",
      ['040'] = "cn_sie", --"Sierra Medical Center",
      ['042'] = "cn_twi", --"Twin Cities Community Hospital",
      ['050'] = "cn_wbo", --"West Boca Medical Center",
      ['054'] = "cn_dhf", --"Doctors Hospital at White Rock Lake",
      ['072'] = "cn_srm", --"San Ramon Regional Medical Center",
      ['309'] = "cn_rhb", --"Resolute Health Hospital",
      ['318'] = "cn_vba", --"Valley Baptist Harlingen",
      ['317'] = "cn_vbc", --"Valley Baptist Brownsville",
      ['320'] = "cn_spw", --"THOP Transmountain Campus",
      ['324'] = "cn_ses", --"Sierra Providence East Medical Center",
      ['332'] = "cn_bar", --"Saint Francis Bartlett Hospital",
      ['333'] = "cn_frh", --"Centennial Medical Center",
      ['335'] = "cn_gsm", --"Good Samaritan Medical Center",
      ['337'] = "cn_smh", --"St. Mary's Medical Center",
      ['344'] = "cn_pbg", --"Palm Beach Gardens Medical Center",
      ['349'] = "cn_pgh", --"Palmetto General Hospital",
      ['345'] = "cn_flo", --"Florida Medical Center",
      ['346'] = "cn_cgh", --"Coral Gables Hospital",
      ['348'] = "cn_hia", --"Hialeah Hospital",
      ['351'] = "cn_nos", --"North Shore Medical Center",
      ['352'] = "cn_des", --"Desert Regional Medical Center",
      ['353'] = "cn_nmc", --"Nacogdoches Medical Center",
      ['356'] = "cn_pph", --"Park Plaza Hospital",
      ['358'] = "cn_hnm", --"Houston Northwest Medical Center",
      ['368'] = "cn_bmc", --"Brookwood Medical Center",
      ['369'] = "cn_cyf", --"Cypress Fairbanks Medical Center",
      ['372'] = "cn_sfh", --"Saint Francis Hospital",
      ['373'] = "cn_pmc", --"Piedmont Medical Center",
      ['376'] = "cn_dhw", --"Des Peres Hospital",
      ['381'] = "cn_hah", --"Hahnemann University Hospital",
      ['382'] = "cn_lpx", --"Lake Pointe Medical Center",
      ['384'] = "cn_sch", --"St. Christopher's Hospital for Children",
      ['390'] = "cn_prv", --"Providence Memorial Hospital",
      ['391'] = "cn_ech", --"East Cooper Medical Center",      
      ['410'] = "cn_ahh", --"Arizona Heart Hospital",
      ['412'] = "cn_pva", --"Abrazo Scottsdale Campus",
      ['414'] = "cn_wvh", --"Abrazo West Campus",
      ['416'] = "cn_ahd", --"Arrowhead Hospital",
      ['418'] = "cn_pba", --"Abrazo Central Campus",
      ['420'] = "cn_mhh", --"Maryvale Hospital",
      ['615'] = "cn_ccd", --"Coastal Carolina Hospital",
      ['711'] = "cn_hhh", --"Hilton Head Hospital",
      ['728'] = "cn_pph", --"Park Plaza Specialty Hospital",
      ['737'] = "cn_svm", --"Sierra Vista Regional Medical Center",
      ['778'] = "cn_fvr", --"Fountain Valley Regional Hospital"
   }
    if iguana.isTest() or os.getenv("IGUANA-DEBUG-FLAG") then 
       conifer_detroit_hospital_table["000"] = "cn_test" 
       conifer_pbar_hospital_table["000"] = "cn_test" 
    end
   
   if (company == "detroit") then
       return conifer_detroit_hospital_table
   elseif (company == "pbar") then
       return conifer_pbar_hospital_table
    end
      
end

function getHospitalNameByCode(company,code)
   return getHospitalCodes(company)[code]
end
