define redact::thing (
  $param,
  $redacted,
  $replaced,
) {
  notice("The value of param is ${param}")
  notice("The value of redacted is ${redacted}")
  notice("The value of replaced is ${replaced}")

  redact('redacted')
  redact('replaced', 'a replacement string')
}
