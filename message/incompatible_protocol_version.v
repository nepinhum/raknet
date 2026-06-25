module message

pub struct IncompatibleProtocolVersion {
pub:
	server_protocol u8
	server_guid     i64
}

pub fn (pk IncompatibleProtocolVersion) encode() []u8 {
	mut b := []u8{len: 26}
	b[0] = id_incompatible_protocol_version
	b[1] = pk.server_protocol
	copy(mut b[2..], unconnected_message_sequence)
	put_u64(mut b, 18, u64(pk.server_guid))
	return b
}

pub fn decode_incompatible_protocol_version(data []u8) !IncompatibleProtocolVersion {
	if data.len < 25 {
		return error('unexpected eof reading incompatible protocol version')
	}
	return IncompatibleProtocolVersion{
		server_protocol: data[0]
		server_guid:     i64(read_u64(data, 17))
	}
}
