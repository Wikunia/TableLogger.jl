"""
    format_table_value(width::Int, value)

Format the table value using the given `width` and value. 
The string representation of `value` is returned if there can be at least 1 space on either side of it.
Otherwise `"t.l."` is returned. You can dispatch on `value` to change this behavior. 
In that case you should check yourself that the length of the returned string is smaller or equal to `width-2`.
"""
function format_table_value(width::Int, value)
    s_val = string(value)
    if length(s_val) > width+2
        s_val = "t.l."
    end
    return s_val
end