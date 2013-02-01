define users::lookupkey($ensure = present) {
    # Waiting for fix #5127
    $data = extlookup("${name}_sshkey")
    $type = array_index($data, "-3")
    $key = array_index($data, "-2")
    $comment = array_index($data, "-1")
    $rest = array_slice($data, 0, "-4")
    $options = array_length($rest) ? {
        0       => absent,
        default => $rest,
    }

    if $name =~ /(.*)::(.*)/ {
      $user_name = $2
    } else {
      $user_name = $name
    }

    ssh_authorized_key { "${name}_${comment}":
        ensure  => $ensure,
        key     => "$key",
        type    => "$type",
        user    => "$user_name",
        options => $options,
        target  => "/home/${user_name}/.ssh/authorized_keys",
        require => [ User["$user_name"], File["/home/${user_name}/.ssh"], ],
    }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
