#!/bin/csh -f

unsetenv LM_LICENSE_FILE
source /ASIC/usr/cadman/env/voltus_19.13_s079.env
source ~cadman/env/lsf.env

#sed -i '/\*/d' *pwl

## add END into trigger.txt 
set tri_list = `ls -l --color=never *_trigger.txt | awk '{print $(NF)}'`

foreach temp1 ($tri_list)
	grep -q '^END$\|^END[[:blank:]$]' $temp1
	if ($status == 0 ) then
    	continue
    else 
    	echo "END" >> $temp1
    endif
end

## voltus command
set aaa = `ls -l --color=never *dpgv.cmd | awk '{print $(NF)}'`
foreach temp ($aaa)
	bsub -Is -n 4 -q FTV_PI voltus -nowin -init $temp -log $temp.log -wait 1000
end
