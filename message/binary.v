module message

import encoding.binary

fn put_u16(mut b []u8, offset int, v u16) {
	binary.big_endian_put_u16_at(mut b, v, offset)
}

fn put_u32(mut b []u8, offset int, v u32) {
	binary.big_endian_put_u32_at(mut b, v, offset)
}

fn put_u64(mut b []u8, offset int, v u64) {
	binary.big_endian_put_u64_at(mut b, v, offset)
}

fn put_little_u16(mut b []u8, offset int, v u16) {
	binary.little_endian_put_u16_at(mut b, v, offset)
}

fn read_u16(b []u8, offset int) u16 {
	return binary.big_endian_u16_at(b, offset)
}

fn read_u32(b []u8, offset int) u32 {
	return binary.big_endian_u32_at(b, offset)
}

fn read_u64(b []u8, offset int) u64 {
	return binary.big_endian_u64_at(b, offset)
}
