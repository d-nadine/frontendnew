Radium.Url = do ->
  resolve = (url) ->
    if /([A-Za-z]{3,9}:(?:\/\/)?)/.test(url)
      url
    else
      "//#{url}"

  resolve: resolve
