@testset "init_log_table vectors" begin 
    table = init_log_table(
        [:open_nodes],
        ["#Open"],
        [20],
        [:center]
    )
    @test table.setup.ids == [:open_nodes]
end

@testset "init_log_table list of columns everything specified" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open", width=20, alignment=:center),
        (id=:closed_nodes, name="#Closed", width=30, alignment=:left),
    )
    @test table.setup.ids == [:open_nodes, :closed_nodes]
    @test table.setup.names == ["#Open", "#Closed"]
    @test table.setup.widths == [20,30]
    @test table.setup.alignments == [:center,:left]
end

@testset "init_log_table list use defaults" begin 
    table = init_log_table(
        (id=:open_nodes, name="#Open", width=20, alignment=:center),
        (id=:closed_nodes, name="#Closed");
        width = 30,
        alignment = :left
    )
    @test table.setup.ids == [:open_nodes, :closed_nodes]
    @test table.setup.names == ["#Open", "#Closed"]
    @test table.setup.widths == [20,30]
    @test table.setup.alignments == [:center,:left]
end
