export DisplayArray

struct DisplayRow
    size::Int
    background::Char
    context::Vector{Char}
end

function DisplayRow(len::Int; background=' ')
    (textwidth(background) != 1) && (throw("Bad background char"))

    return DisplayRow(len, background, fill(background, len))
end

Base.length(row::DisplayRow) = row.size

Base.lastindex(row::DisplayRow) = row.size

function get_element_index(row::DisplayRow, display_index::Int)
    (textwidth(join(row.context)) < display_index) && (throw(BoundsError))

    accumulate_width = index = pre = post = 0
    for c in row.context
        width = textwidth(c)
        accumulate_width += width
        index += 1
        if accumulate_width >= display_index
            pre = display_index - (accumulate_width-width) - 1
            post = accumulate_width-display_index
            break
        end
    end

    return (i=index, pre=pre, post=post)
end

function Base.deleteat!(row::DisplayRow, display_index::Int)
    index = get_element_index(row, display_index)
    deleteat!(row.context, index.i)
    for i=1:(index.pre+index.post+1)
        insert!(row.context, index.i, row.background)
    end
end

function Base.setindex!(row::DisplayRow, c::Char, display_index::Int)
    start = display_index
    stop = display_index + textwidth(c) - 1

    i1, pre, _ = get_element_index(row, start)
    i2, _, post = get_element_index(row, stop)

    deleteat!(row.context, collect(i1:i2))

    for i=1:post insert!(row.context, i1, row.background) end
    insert!(row.context, i1, c)
    for i=1:pre insert!(row.context, i1, row.background) end
end

function Base.setindex!(row::DisplayRow, str::String, display_range::UnitRange{Int64})
    start, stop = display_range.start, display_range.stop
    (stop != start + textwidth(str) - 1) && (throw(DimensionMismatch))

    i1, pre, _ = get_element_index(row, start)
    i2, _, post = get_element_index(row, stop)

    deleteat!(row.context, collect(i1:i2))

    for i=1:post insert!(row.context, i1, row.background) end
    for c in reverse(str) insert!(row.context, i1, c) end
    for i=1:pre insert!(row.context, i1, row.background) end
end

render(io::IO, row::DisplayRow) = (join(io, row.context); println(io))

struct DisplayArray
    size::Tuple{Int, Int}
    background::Char
    context::Vector{DisplayRow}
end

function DisplayArray(h, w; background=' ')
    (textwidth(background) != 1) && (throw("Bad background char"))

    context = DisplayRow[]
    for i=1:h
        push!(context, DisplayRow(w, background=background))
    end

    return DisplayArray(
        (h, w),
        background,
        context
    )
end

Base.size(array::DisplayArray) = array.size

render(io::IO, array::DisplayArray) = (for row in array.context render(io, row) end)
