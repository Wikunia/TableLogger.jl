@testset "Format real numbers" begin 
    for x in [0.1111111111111111111111111, 0.111111111f0, π, 111112.2234]
        for w in 5:15 
            s_x = TableLogger.format_table_value(w, x)
            @test s_x isa String
            @test length(s_x) <= w
        end
    end

    x = 0.12345
    w = 3
    s_x = TableLogger.format_table_value(w, x)
    @test s_x == "0.1"

    x = 0.12345
    w = 5
    s_x = TableLogger.format_table_value(w, x)
    @test s_x == "0.12"

    x = 0.12345
    w = 5
    s_x = TableLogger.format_table_value(w, x; default_precision=5)
    @test s_x == "0.123"
end