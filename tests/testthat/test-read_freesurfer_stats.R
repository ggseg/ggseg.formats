describe("read_freesurfer_stats()", {
  it("reads aseg.stats file with renamed columns", {
    aseg_file <- test_path("data/bert/stats/aseg.stats")
    aseg_stats <- read_freesurfer_stats(aseg_file)

    expect_equal(
      names(aseg_stats),
      c(
        "Index",
        "SegId",
        "NVoxels",
        "Volume_mm3",
        "label",
        "normMean",
        "normStdDev",
        "normMin",
        "normMax",
        "normRange"
      )
    )
    expect_equal(nrow(aseg_stats), 45)
  })

  it("reads aseg.stats file without renaming when rename = FALSE", {
    aseg_file <- test_path("data/bert/stats/aseg.stats")
    expect_equal(
      names(read_freesurfer_stats(aseg_file, FALSE)),
      c(
        "Index",
        "SegId",
        "NVoxels",
        "Volume_mm3",
        "StructName",
        "normMean",
        "normStdDev",
        "normMin",
        "normMax",
        "normRange"
      )
    )
  })

  it("reads aparc.stats file with renamed columns", {
    dkt_file <- test_path("data/bert/stats/lh.aparc.stats")
    dkt_stats <- read_freesurfer_stats(dkt_file)

    expect_equal(
      names(dkt_stats),
      c(
        "label",
        "NumVert",
        "SurfArea",
        "GrayVol",
        "ThickAvg",
        "ThickStd",
        "MeanCurv",
        "GausCurv",
        "FoldInd",
        "CurvInd"
      )
    )
    expect_equal(nrow(dkt_stats), 34)
  })

  it("reads aparc.stats file without renaming when rename = FALSE", {
    dkt_file <- test_path("data/bert/stats/lh.aparc.stats")
    expect_equal(
      names(read_freesurfer_stats(dkt_file, FALSE)),
      c(
        "StructName",
        "NumVert",
        "SurfArea",
        "GrayVol",
        "ThickAvg",
        "ThickStd",
        "MeanCurv",
        "GausCurv",
        "FoldInd",
        "CurvInd"
      )
    )
  })
})

describe("read_atlas_files()", {
  it("reads all aparc stats files from subjects directory", {
    dat <- read_atlas_files(test_path("data"), "aparc")

    expect_equal(
      names(dat),
      c(
        "subject",
        "label",
        "NumVert",
        "SurfArea",
        "GrayVol",
        "ThickAvg",
        "ThickStd",
        "MeanCurv",
        "GausCurv",
        "FoldInd",
        "CurvInd"
      )
    )
    expect_equal(nrow(dat), 68)
  })

  it("combines hemispheres with correct label prefixes", {
    dat <- read_atlas_files(test_path("data"), "aparc")
    expect_equal(
      unique(dat$label)[1:10],
      c(
        "lh_bankssts",
        "lh_caudalanteriorcingulate",
        "lh_caudalmiddlefrontal",
        "lh_cuneus",
        "lh_entorhinal",
        "lh_fusiform",
        "lh_inferiorparietal",
        "lh_inferiortemporal",
        "lh_isthmuscingulate",
        "lh_lateraloccipital"
      )
    )
  })
})

describe("read_freesurfer_table()", {
  it("reads table file with default column names", {
    file <- test_path("data/aparc.volume.table")
    dat <- read_freesurfer_table(file)

    expect_equal(names(dat), c("subject", "label", "value"))
    expect_equal(nrow(dat), 36)
    expect_true(any(grepl("volume$", dat$label)))
  })

  it("strips measure suffix from labels when measure is specified", {
    file <- test_path("data/aparc.volume.table")
    dat <- read_freesurfer_table(file, measure = "volume")

    expect_equal(names(dat), c("subject", "label", "volume"))
    expect_false(any(grepl("volume$", dat$label)))
  })

  it("replaces dots with hyphens in labels", {
    tmp <- tempfile(fileext = ".table")
    writeLines(
      c(
        "subject\troi.one\troi.two",
        "bert\t1.5\t2.5"
      ),
      tmp
    )

    dat <- read_freesurfer_table(tmp)

    expect_false(any(grepl("\\.", dat$label)))
    expect_true(all(grepl("-", dat$label)))
    expect_equal(dat$label, c("roi-one", "roi-two"))

    unlink(tmp)
  })
})


describe("read_atlas_files() with aseg", {
  it("reads aseg stats files without hemisphere prefixes", {
    dat <- read_atlas_files(test_path("data"), "aseg.stats")

    expect_true("subject" %in% names(dat))
    expect_true("label" %in% names(dat))
    expect_false("hemi" %in% names(dat))
    expect_equal(unique(dat$subject), "bert")
  })
})


describe("find_subject_fromdir", {
  it("extracts subject from path", {
    result <- ggseg.formats:::find_subject_fromdir("/bert/stats/aseg.stats")
    expect_equal(result, "bert")
  })
})


describe("find_hemi_fromfile", {
  it("extracts hemisphere from lh file", {
    result <- ggseg.formats:::find_hemi_fromfile("/path/to/lh.aparc.stats")
    expect_equal(result, "lh")
  })

  it("extracts hemisphere from rh file", {
    result <- ggseg.formats:::find_hemi_fromfile("/path/to/rh.aparc.stats")
    expect_equal(result, "rh")
  })

  it("extracts first element for non-hemispheric files", {
    result <- ggseg.formats:::find_hemi_fromfile("/path/to/aseg.stats")
    expect_equal(result, "aseg")
  })
})
