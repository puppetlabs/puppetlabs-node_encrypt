function node_encrypt::secret(String $data) >> Deferred {
  Deferred("node_decrypt", [node_encrypt($data)])
}
