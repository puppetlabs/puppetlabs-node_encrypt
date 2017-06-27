class redact (
  $param,
  $redacted,
  $replaced,
) {
  notice("The value of param is ${param}")
  notice("The value of redacted is ${redacted}")
  notice("The value of replaced is ${replaced}")

  redact('redacted')
  redact('replaced', 'a replacement string')

  redact::thing { 'one':
    param    => 'a param',
    redacted => 'to be redacted',
    replaced => 'to be replaced',
  }
  redact::thing { 'two':
    param    => 'a param',
    redacted => 'to be redacted',
    replaced => 'to be replaced',
  }

}
