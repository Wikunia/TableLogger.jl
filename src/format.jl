function format_table_value(width::Int, value)
    s_val = string(value)
    if length(s_val) > width+2
        s_val = "t.l"
    end
    return s_val
end