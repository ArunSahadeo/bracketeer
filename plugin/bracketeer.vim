let s:affectedLines = []
let s:lineNr = 0
let s:leadingBracketRegex = '\(\w\+\)\(.*\)({)$'

function! GetAffectedLines()
    while s:lineNr < line('$')
        let s:lineNr += 1
        let s:currentLine = getline(s:lineNr)
        if len(s:currentLine) > 1 && (s:currentLine =~ "{" || s:currentLine =~ "}")
            call add(s:affectedLines, s:currentLine)
        endif
    endwhile
endfunction

function! CheckBrackets()
    let validFTs = ["css", "scss", "less"]
    if index(validFTs, &ft) == -1
        echom "Sorry, the file must end in either .css, .scss or .less"
        return
    endif
    call GetAffectedLines()
    if len(s:affectedLines) > 0
        execute "%s/\v(.*)([\{|\}])/\1\r\2/g"
    endif
endfunction

command! CheckBrackets call CheckBrackets()
