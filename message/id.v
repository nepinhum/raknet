module message

pub const protocol_version = u8(11)

pub const id_connected_ping = u8(0x00)
pub const id_unconnected_ping = u8(0x01)
pub const id_unconnected_ping_open_connections = u8(0x02)
pub const id_connected_pong = u8(0x03)
pub const id_detect_lost_connections = u8(0x04)
pub const id_open_connection_request_1 = u8(0x05)
pub const id_open_connection_reply_1 = u8(0x06)
pub const id_open_connection_request_2 = u8(0x07)
pub const id_open_connection_reply_2 = u8(0x08)
pub const id_connection_request = u8(0x09)
pub const id_connection_request_accepted = u8(0x10)
pub const id_new_incoming_connection = u8(0x13)
pub const id_disconnect_notification = u8(0x15)
pub const id_incompatible_protocol_version = u8(0x19)
pub const id_unconnected_pong = u8(0x1c)

pub const unconnected_message_sequence = [
	u8(0x00),
	0xff,
	0xff,
	0x00,
	0xfe,
	0xfe,
	0xfe,
	0xfe,
	0xfd,
	0xfd,
	0xfd,
	0xfd,
	0x12,
	0x34,
	0x56,
	0x78,
]
