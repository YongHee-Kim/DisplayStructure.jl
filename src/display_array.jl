export DisplayArray, render

struct DisplayArray
    size::Tuple{Int, Int}
    background::Char
    content::Vector{DisplayRow}
end

function DisplayArray(h, w; background=' ')
    (textwidth(background) != 1) && (throw(
        "Invalid background character. " *
        "Text width of background character must be 1."
    ))

    content = Array{DisplayRow}(undef, h)
    foreach(i->content[i]=DisplayRow(w, background=background), 1:h)

    return DisplayArray(
        (h, w),
        background,
        content
    )
end

Base.size(array::DisplayArray) = array.size

Base.lastindex(array::DisplayArray, d::Int) = size(array)[d]

function Base.setindex!(
    array::DisplayArray,
    c::Char,
    display_row::Int, display_col::Int
)
    array.content[display_row][display_col] = c
end

function Base.setindex!(
    array::DisplayArray,
    str::String,
    display_row_range::UnitRange{Int64}, display_col_range::UnitRange{Int64}
)
    split_str = split(str, '\n')
    length(split_str) == length(display_row_range) || throw(DimensionMismatch)
    (display_row_range.stop > size(array)[1]) && (throw(BoundsError))

    width = length(display_col_range)
    for (i, s) in zip(display_row_range, split_str)
        s = padding(s, width, background=array.background)
        array.content[i][display_col_range] = s
    end
end

function render(io::IO, array::DisplayArray; style=Symbol[], color=(-1, -1, -1))
    foreach(row->render(io, row, style=style, color=color), array.content)
end
