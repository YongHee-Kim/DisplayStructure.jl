@testset "DisplayRow" begin

    io = IOBuffer()

    row = DS.DisplayRow(40, background='.')
    @test lastindex(row) == length(row)
    @test textwidth(join(row.context)) == length(row)
    DS.render(io, row)
    @test String(take!(io)) ==
        "........................................\n"

    row[10] = '字'
    DS.render(io, row)
    @test String(take!(io)) ==
        ".........字.............................\n"

    @test DS.get_element_index(row, 10) == (i=10, pre=0, post=1)


    row[3:7] = "兩bit"
    DS.render(io, row)
    @test String(take!(io)) ==
        "..兩bit..字.............................\n"

    @test DS.get_element_index(row, 4) == (i=3, pre=1, post=0)
    @test textwidth(join(row.context)) == length(row)

    deleteat!(row, 5) # 'b'
    @test DS.get_element_index(row, 30) == (i=28, pre=0, post=0)
    @test textwidth(join(row.context)) == length(row)
    DS.render(io, row)
    @test String(take!(io)) ==
        "..兩.it..字.............................\n"

    deleteat!(row, 4) # '兩'
    @test DS.get_element_index(row, 30) == (i=29, pre=0, post=0)
    @test textwidth(join(row.context)) == length(row)
    DS.render(io, row)
    @test String(take!(io)) ==
        ".....it..字.............................\n"

end
