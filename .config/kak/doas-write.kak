# save the current buffer to its file as root using 'doas'

define-command doas-write -docstring "write the content of the buffer as root using doas" %{
	nop %sh{
        # tricky posix-way of getting the first character of a variable
        # no subprocess!
        if [ "${kak_buffile%"${kak_buffile#?}"}" != "/" ]; then
            # not entirely foolproof as a scratch buffer may start with '/', but good enough
            printf 'fail "Not a file"'
            exit
        fi
	}
    prompt -password 'Password:' %{
		reg f %sh{ mktemp -t kak-XXXXXX }
		write! %reg{f}

		reg p %val{text}

		nop %sh{
			kak-doas-write $kak_main_reg_f $kak_buffile $kak_main_reg_p
			rm -f "$kak_main_reg_f"
		}
    }
}
