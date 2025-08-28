#ifndef _TYPES_H_
#define _TYPES_H_

#include <cstdint>

constexpr int CDROM_MDG_SIZE = 16305;
constexpr uint8_t MDG_FLAG_COMPRESSED_FILE = 0b10;
constexpr uint8_t MDG_FLAG_DUMMY_FILE = 0b01;

struct mdg
{
	uint64_t address;
	uint8_t flag;
	uint32_t padding;
};

#endif
