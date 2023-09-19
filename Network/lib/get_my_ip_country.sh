#!/bash/sh
country=$( wget -qO- -t1 -T2 ipinfo.io/$(get_ip)/country )
    printf -- "%s" "${country}"