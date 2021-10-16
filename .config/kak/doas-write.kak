# save the current buffer to its file as root using `doas`
# (optionally pass the user password to doas if not cached)

define-command -hidden doas-write-cached-password %{
    # easy case: the password was already cached, so we don't need any tricky handling
    eval -save-regs f %{
        reg f %sh{ mktemp -t kak-XXXXXX }
        write! %reg{f}
        eval %sh{
			kak-doas-write $kak_main_reg_f $kak_buffile
            if [ $? -eq 0 ]; then
                echo "edit!"
            else
                echo 'fail "Unknown failure"'
            fi
            rm -f "$kak_main_reg_f"
        }
    }
}

define-command -hidden doas-write-prompt-password %{
    prompt -password 'Password:' %{
        # eval -save-regs r %{
            # eval -draft -save-regs 'tf|"' %{
			eval -save-regs f %{
                # reg t %val{buffile}
                reg f %sh{ mktemp -t kak-XXXXXX }
                write! %reg{f}

                reg p %val{text}
                # write the password in a buffer in order to pass it through STDIN to doas
                # somewhat dangerous, but better than passing the password
                # through the shell scope's environment or interpolating it inside the shell string
                # 'exec |' is pretty much the only way to pass data over STDIN
                # edit -scratch '*doas-password-tmp*'
                # exec <a-P>
				%sh{
					kak-doas-write $kak_main_reg_f $kak_buffile $kak_main_reg_p
            		rm -f "$kak_main_reg_f"
				}
                # exec '|<ret>'
                # exec -save-regs '' '%"ry'
                # delete-buffer! '*doas-password-tmp*'
            }
            # }
            # eval %reg{r}
        # }
    }
}

# define-command doas-diretto -docstring "Write the content of the buffer using doas diretto" %{
	# eval %/usr/bin/expect{
	# 	user="lollo"
	# 	hostname="voidlollo"
	# 	password="yrr"
	# 	spawn doas -- dd if="$kak_main_reg_f" of="$kak_buffile" >/dev/null 2>&1
	# 	expect "doas ($user@$hostname) password: " {send -- "$password\r"}
	# 	expect eof
	# }
	# eval -save-regs f %{
		# reg f %sh{ mktemp -t XXXXXX }
        # write! %reg{f}
        # write! /tmp/bufferkak
		# %sh{
			# spawn doas cat "$tmpfile" \> "$kak_buffile"
			# spawn doas -- dd if="$tmpfile" of="$kak_buffile" >/dev/null 2>&1
			# tmpfile="$(mktemp -t XXXXXXXX)"
			# echo "set buffer plugin_filename '$tmpfile' write '$tmpfile'"
			# eval %sh { echo "write! '$tmpfile'" }
			# tmpfile="$kak_main_reg_f"
			# tmpfile="/tmp/bufferkak"
			# user="lollo"
			# # hostname="voidlollo"
			# kak-doas-write $tmpfile $kak_buffile $password
# 			/usr/bin/expect <<EOF
# 			spawn doas -- dd if="$tmpfile" of="$kak_buffile" >/dev/null 2>&1
# 			expect "doas ($user@$hostname) password: " {send -- "$password\r"}
# 			expect eof
# EOF
		# }
	# }
# }

define-command doas-write -docstring "Write the content of the buffer using doas" %{
    eval %sh{
        # tricky posix-way of getting the first character of a variable
        # no subprocess!
        if [ "${kak_buffile%"${kak_buffile#?}"}" != "/" ]; then
            # not entirely foolproof as a scratch buffer may start with '/', but good enough
            printf 'fail "Not a file"'
            exit
        fi
        # check if the password is cached
        if doas true > /dev/null 2>&1; then
            printf doas-write-cached-password
        else
            printf doas-write-prompt-password
        fi
    }
}

