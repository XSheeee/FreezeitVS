_fv1path=$(mount -t cgroup | awk '/freezer/ {print $3}')
while true
do
    _memp=$(awk '/some/ {print $2}' /proc/pressure/memory)
    _memp=${_memp:6}
    _memp=${_memp%???}
    if [ _memp -gt 10 ]
    then
        _pid=$(cat "$_fv1path"/frozen/cgroup.procs)
        if [ -n "$_pid" ]
        then
          echo THAWED > "$_fv1path"/frozen/freezer.state
          sleep 10   
             echo FROZEN > "$_fv1path"/frozen/freezer.state
          
       fi
    fi
    sleep 3
done