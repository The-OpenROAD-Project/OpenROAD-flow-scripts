#!/bin/tcsh
sleep 10
set log="$argv.log"
set json="$argv.json"
set job_id=`lsof $json | tail -n1 | awk '{print $2}'`
set parent_job_id=`ps -f $job_id | tail -n1 | awk '{print $3}'`
echo "Job id:$job_id Parent Job id:$parent_job_id"

set terminate_hours="0.5"
set maxIter="65" 
set timeConstraint=`echo "${terminate_hours}*3600" | bc`
set expected_runtime="0"
set currIter="0"
set minIter="5"

set isfile_exists=`readlink -f $log  | wc -l`
set count="0"
while (`echo "$isfile_exists==0 && $count < 30" |bc`)
    sleep 10
    set isfile_exists=`readlink -f $log  | wc -l`
    set count=`echo "$count + 1" | bc`
end

set isgr_failed=`grep 'ERROR GRT-0118' $log | wc -l`

if (`echo "$isgr_failed==1" | bc`) then
    echo "Global Route Failed exiting"
    kill -9 "$$" 
endif

set isdr_finished=`grep 'INFO DRT-0199' $log  | wc -l`
set count="0"
while (`echo "$isdr_finished==0 && $count < 60" |bc`)
    sleep 10
    set isdr_finished=`grep 'INFO DRT-0199' $log  | wc -l`
    set count=`echo "$count + 1" | bc`
end

echo "Waiting for job to finish"
while ( `echo "$expected_runtime <= $timeConstraint && $currIter < $maxIter" | bc` )
    set currIter=`grep 'INFO DRT-0195' $log | tail -n1 | awk '{print $4}' | grep -o '[0-9]*'`
    
    set last_cycle_hours=`grep 'INFO DRT-0267' $log | tail -n1 | awk '{print $10}' | sed 's@,@@' | cut -d: -f1`
    set last_cycle_mins=`grep 'INFO DRT-0267' $log | tail -n1 | awk '{print $10}' | sed 's@,@@' | cut -d: -f2`
    set last_cycle_secs=`grep 'INFO DRT-0267' $log | tail -n1 | awk '{print $10}' | sed 's@,@@' | cut -d: -f3`
    set total_time=`echo "$last_cycle_hours*3600 + $last_cycle_mins*60 + $last_cycle_secs" | bc`
    echo "Run time of last cycle:$total_time"
    
    set nth_count=`grep 'INFO DRT-0199' $log | tail -n1 | awk '{print $NF}' | sed 's@.$@@'`
    set n1th_count=`grep 'INFO DRT-0199' $log | tail -n2 | head -n1 | awk '{print $NF}' | sed 's@.$@@'`
    echo "Violation count: $nth_count $n1th_count"
    
    set fixed_count=`echo "$n1th_count - $nth_count" | bc`
    if ( `echo "$fixed_count > 0 && $currIter > $minIter" | bc` ) then
        set expected_runtime=`echo "$nth_count*($total_time/$fixed_count*1.0)" | bc -l | sed 's@\.[0-9]*$@@'`
    else
        set expected_runtime="$timeConstraint"
    endif
    
    echo "Expected Runtime:$expected_runtime seconds Current Opt Cycle:$currIter"
    set is_finished=`grep 'INFO DRT-0198' $log | wc -l`
    if ( `echo "$is_finished==1" | bc` ) then
        echo "DR Finished"
        exit 0
        #kill -9 "$$" 
    endif
    #sleep 60
    sleep 5
end

sleep 5
#kill -9 $parent_job_id
kill -9 $job_id
