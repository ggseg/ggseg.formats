# print_data_head / prints list-columns as compact summaries, regardless of tibble

    Code
      result <- print_data_head(df)
    Output
        label   vertices
      1     a  <int [3]>
      2     b <int [10]>

# print_data_head / notes the rows dropped beyond n

    Code
      print_data_head(as_tbl(data.frame(x = 1:5)), n = 2)
    Output
        x
      1 1
      2 2
    Message
      ... with 3 more rows

