define redact::thing (
  $param,
  $redacted,
  $replaced,
) {
  redact('redacted')
  redact('replaced', 'a replacement string')

  # In real-use, there would be no point in using redact if you then exposed
  # the unredacted parameters in other resources.
  # But we need some resources in our catalog for testing that the variables
  # are available to use un-redacted.
  notify { "${name} The value of param is ${param}":}
  notify { "${name} The value of redacted is ${redacted}":}
  notify { "${name} The value of replaced is ${replaced}":}
}
