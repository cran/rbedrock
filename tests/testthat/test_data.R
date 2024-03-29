dbpath <- rbedrock_example_world("example1.mcworld")
db <- bedrockdb(dbpath)

test_that("get_keys returns all keys", {
    keys <- get_keys(db)
    expect_equal(length(keys), 1136L)
})

test_that("get_keys returns all keys with a prefix", {
    keys <- get_keys(db)
    pre_str <- get_keys(db, "plain:VILLAGE")
    expect_equal(pre_str, grep("^plain:VILLAGE", keys, value = TRUE))
    pre_chunk <- get_keys(db, "chunk:37:6:0")
    expect_equal(pre_chunk, grep("^chunk:37:6:0", keys, value = TRUE))
})

test_that("get_value returns a single, raw value", {
    expect_equal(get_value(db, "chunk:31:6:0:44"), as.raw(0x15))
    expect_equal(get_value(db, "plain:Overworld"), as.raw(c(
        0x0a, 0x00, 0x00, 0x0a, 0x04, 0x00, 0x64, 0x61,
        0x74, 0x61, 0x09, 0x0d, 0x00, 0x4c, 0x69, 0x6d,
        0x62, 0x6f, 0x45, 0x6e, 0x74, 0x69, 0x74, 0x69,
        0x65, 0x73, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00
    )))
    expect_null(get_value(db, "plain:MissingKey"))
})

test_that("get_value requires a scalar character argument", {
    expect_error(get_value(db, NULL), class = "vctrs_error_scalar_type")
    expect_error(get_value(db, 1L), class = "vctrs_error_assert_ptype")
    expect_error(get_value(db, as.raw(1L)), class = "vctrs_error_assert_ptype")
    expect_error(get_value(db, c("hello", "world")),
        class = "vctrs_error_assert_size"
    )
})

test_that("get_values returns a list of raw values", {
    expect_equal(
        get_values(db, c(
            "chunk:31:6:0:44", "plain:Overworld",
            "plain:NotFound"
        )),
        list("chunk:31:6:0:44" = as.raw(0x15), "plain:Overworld" = as.raw(c(
            0x0a, 0x00, 0x00, 0x0a, 0x04, 0x00, 0x64, 0x61,
            0x74, 0x61, 0x09, 0x0d, 0x00, 0x4c, 0x69, 0x6d,
            0x62, 0x6f, 0x45, 0x6e, 0x74, 0x69, 0x74, 0x69,
            0x65, 0x73, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
            0x00
        )), "plain:NotFound" = NULL)
    )
})

test_that("get_values returns all keys with a prefix", {
    keys <- get_keys(db)
    pre_str <- get_values(db, starts_with = "plain:VILLAGE")
    expect_equal(names(pre_str), grep("^plain:VILLAGE", keys, value = TRUE))
    pre_chunk <- get_values(db, starts_with = "chunk:37:6:0")
    expect_equal(names(pre_chunk), grep("^chunk:37:6:0", keys, value = TRUE))
    pre_chunk <- get_values(db, starts_with = "chunk:37:6:0:47")
    expect_equal(names(pre_chunk), grep("^chunk:37:6:0:47", keys, value = TRUE))
})

test_that("has_values returns a logical vector", {
    expect_equal(
        has_values(db, c(
            "chunk:31:6:0:44", "plain:Overworld",
            "plain:NotFound"
        )),
        c(
            "chunk:31:6:0:44" = TRUE, "plain:Overworld" = TRUE,
            "plain:NotFound" = FALSE
        )
    )
})

test_that("put_value writes data into the db", {
    put_value(db, "plain:Test%01", charToRaw("Hello World"))
    put_result <- get_value(db, "plain:Test%01")
    expect_equal(put_result, charToRaw("Hello World"))
    put_value(db, "chunk:0:0:0:44", as.raw(15))
    put_result <- get_value(db, "chunk:0:0:0:44")
    expect_equal(put_result, as.raw(15))
    put_value(db, "plain:Test%01", charToRaw("Hello New World"))
    put_result <- get_value(db, "plain:Test%01")
    expect_equal(put_result, charToRaw("Hello New World"))
})

test_that("put_value throws errors are incorrect arguments", {
    expect_error(put_value(db, NULL, raw(1L)),
        class = "vctrs_error_scalar_type"
    )
    expect_error(put_value(db, 1L, raw(1L)),
        class = "vctrs_error_assert_ptype"
    )
    expect_error(put_value(db, as.raw(1L), raw(1L)),
        class = "vctrs_error_assert_ptype"
    )
    expect_error(put_value(db, c("plain:hello", "plain:world"), raw(1L)),
        class = "vctrs_error_assert_size"
    )

    expect_error(put_value(db, "plain:Test%02", "hello Error"), "expected raw")
})

test_that("put_values writes data into the db", {
    put_values(
        db, c("plain:Test%01", "plain:Test%02"),
        list(as.raw(0x1), as.raw(0x2))
    )
    put_result <- get_values(db, c("plain:Test%01", "plain:Test%02"))
    expect_equal(put_result, list(
        "plain:Test%01" = as.raw(0x1),
        "plain:Test%02" = as.raw(0x2)
    ))
})

test_that("put_data writes data into the db", {
    put_data(db, list(
        "plain:Test%01" = as.raw(0x1),
        "plain:Test%02" = as.raw(0x2)
    ))
    put_result <- get_values(db, c("plain:Test%01", "plain:Test%02"))
    expect_equal(put_result, list(
        "plain:Test%01" = as.raw(0x1),
        "plain:Test%02" = as.raw(0x2)
    ))
})

test_that("delete_values removes data from the db", {
    put_data(db, list(
        "plain:Test%01" = as.raw(0x1),
        "plain:Test%02" = as.raw(0x2)
    ))
    delete_ret <- delete_values(db, c("plain:Test%01", "plain:Test%02"))
    expect_null(delete_ret)
    delete_result <- get_values(db, c("plain:Test%01", "plain:Test%02"))
    expect_equal(delete_result, list(
        "plain:Test%01" = NULL,
        "plain:Test%02" = NULL
    ))
    put_data(db, list(
        "plain:Test%01" = as.raw(0x1),
        "plain:Test%02" = as.raw(0x2)
    ))
    delete_ret <- delete_values(db, c(
        "plain:Test%01", "plain:Test%03",
        "plain:Test%02"
    ), report = TRUE)
    expect_equal(delete_ret, c(TRUE, FALSE, TRUE))
})

# clean up
close(db)
fs::dir_delete(dbpath)
