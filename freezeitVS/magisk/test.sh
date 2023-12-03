_fv1path=$(mount -t cgroup | awk '/freezer/ {print $3}')
watch -n 1 "cat "$_fv1path"/frozen/freezer.state;cat /proc/pressure/memory;cat "$_fv1path"/frozen/freezer.killable"