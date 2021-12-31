"""
    format_table_value(width::Int, value)

Format the table value using the given `width` and value. 

For `val::Real`
- return a string representation that fits in the width and return "<<" if val is smaller than 0 but can't be represented or ">>" when it's bigger than 0.

For `val::Integer`
- return simply the string representation and `t.l.` if it doesn't fit

For all others:
- return simply the string representation and `t.l.` if it doesn't fit
"""
function format_table_value(width::Int, val::Real)
    s_val = fmt("<.10f", val)
    precision = 2
    s_val_split = split(s_val, ".")
    if length(s_val_split[1]) == 1 && s_val_split[1] == "0" && length(s_val_split) == 2
        while precision < 10
            if s_val_split[2][precision - 1] != '0'
                precision -= precision > 2 ? 1 : 0
                break
            end
            precision += 1
        end
    end

    prec_fmt = FormatSpec("<.$(precision)f")
    s_val = fmt(prec_fmt, val)
    while length(s_val) > width && precision > 0
        precision -= 1
        prec_fmt = FormatSpec("<.$(precision)f")
        s_val = fmt(prec_fmt, val)
    end
    if length(s_val) > width
        s_val = val > 0 ? ">>" : "<<"
    end
    return s_val
end

function format_table_value(width::Int, value::Integer)
    s_val = string(value)
    if length(s_val) > width
        s_val = "t.l."
    end
    return s_val
end

function format_table_value(width::Int, value)
    s_val = string(value)
    if length(s_val) > width
        s_val = "t.l."
    end
    return s_val
end
