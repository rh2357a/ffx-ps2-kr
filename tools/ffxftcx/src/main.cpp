#include "utils.h"

#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

// clang-format off

const std::vector<uint8_t> FTCX_HEADER{
	0x46, 0x54, 0x43, 0x58, 0xc8, 0x00, 0x14, 0x06,
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
};

// clang-format on

void print_usage()
{
	std::cout << "Usage:\n"
			  << "    ffxftcx GLYPH_COUNT IMG_HEIGHT FONT_FILE WIDTH_FILE CODE_SIZE OUTPUT\n";
}

int main(int argc, char *argv[])
{
	if (argc != 7)
	{
		print_usage();
		return -1;
	}

	int glyph_count = std::stoi(argv[1]);
	int image_height = std::stoi(argv[2]);
	int code_bytes = std::stoi(argv[5]);

	std::string font_path(argv[3]);
	auto font_bytes = read_all_bytes(font_path);

	std::string width_path(argv[4]);
	auto width_bytes = read_all_bytes(width_path);

	std::string output_path(argv[6]);
	if (std::filesystem::exists(output_path))
		std::filesystem::remove(output_path);

	std::ofstream output(output_path, std::ios::binary | std::ios::app);
	append_bytes(output, FTCX_HEADER);
	append_uint32(output, static_cast<uint32_t>(glyph_count));

	// glyph size
	append_uint16(output, 0xe);
	append_uint16(output, 0x12);
	append_zero(output, 8);

	// data address, size
	append_uint32(output, 0x40);
	append_uint32(output, static_cast<uint32_t>(code_bytes) + static_cast<uint32_t>(font_bytes.size()));

	// image size
	append_uint16(output, 0x80);
	append_uint16(output, static_cast<uint16_t>(image_height));
	append_zero(output, 4);

	// font width address, size
	append_uint32(output, 0x40 + static_cast<uint32_t>(code_bytes) + static_cast<uint32_t>(font_bytes.size()));
	append_uint32(output, static_cast<uint32_t>(glyph_count));
	append_zero(output, 8);

	append_zero(output, static_cast<size_t>(code_bytes));
	append_bytes(output, font_bytes);
	append_bytes(output, width_bytes);

	return 0;
}
