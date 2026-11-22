SELECT assembly_id,part,sha256(json_array(cast(assembly_id AS INTEGER),part)) hash_key,crc32(json_array(cast(assembly_id AS INTEGER),part)) checksum_key
FROM t1;
