# print methods / prints ggseg_data_cortical with sf and vertices

    Code
      print(data)
    Message
      
      -- ggseg_data_cortical --
      
      2D (ggseg): 1 labels, views: lateral
      3D (ggseg3d): vertex indices
    Output
      # A tibble: 1 x 2
        label      vertices 
        <chr>      <list>   
      1 lh_frontal <int [3]>

# print methods / prints ggseg_data_subcortical with sf and meshes

    Code
      print(data)
    Message
      
      -- ggseg_data_subcortical --
      
      2D (ggseg): 1 labels, views: axial
      3D (ggseg3d): meshes
    Output
      # A tibble: 1 x 3
        label       vertices faces
        <chr>          <int> <int>
      1 hippocampus       10     3

# print methods / prints ggseg_data_tract with centerlines

    Code
      print(data)
    Message
      
      -- ggseg_data_tract --
      
      3D (ggseg3d): 1 centerlines (10 points)
      Tube params: radius = 5, segments = 8

# print methods / prints ggseg_data_cortical without sf

    Code
      print(data)
    Message
      
      -- ggseg_data_cortical --
      
      3D (ggseg3d): vertex indices
    Output
      # A tibble: 1 x 2
        label      vertices 
        <chr>      <list>   
      1 lh_frontal <int [3]>

# print methods / prints ggseg_data_subcortical without sf

    Code
      print(data)
    Message
      
      -- ggseg_data_subcortical --
      
      3D (ggseg3d): meshes
    Output
      # A tibble: 1 x 3
        label       vertices faces
        <chr>          <int> <int>
      1 hippocampus       10     3

