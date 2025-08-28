#ifndef _UTILS_H_
#define _UTILS_H_

#include "types.h"

#include <algorithm>
#include <fstream>
#include <filesystem>
#include <chrono>
#include <string>
#include <format>
#include <vector>

constexpr size_t CHUNK_SIZE = 16 * 1024 * 1024;

inline std::string datetime_str()
{
	using namespace std::chrono;
	auto now = floor<seconds>(system_clock::now());
	zoned_time zt{locate_zone("Asia/Seoul"), now};
	return std::format("{:%Y%m%d_%H%M%S}", zt);
}

inline std::vector<uint8_t> read_bytes(const std::filesystem::path &path, uint64_t index, uint64_t length)
{
	std::ifstream file(path, std::ios::binary);
	if (!file)
		return {};

	uint64_t file_size = std::filesystem::file_size(path);
	if (index >= file_size)
		return {};

	if (index + length > file_size)
		length = file_size - index;

	file.seekg(index, std::ios::beg);

	std::vector<uint8_t> buffer(length);
	uint64_t remaining = length;
	uint64_t offset = 0;

	while (remaining > 0)
	{
		std::streamsize chunk = static_cast<std::streamsize>(std::min<uint64_t>(remaining, CHUNK_SIZE));
		file.read(reinterpret_cast<char *>(buffer.data() + offset), chunk);
		std::streamsize read_count = file.gcount();
		offset += read_count;
		remaining -= read_count;

		if (read_count == 0)
			break;
	}

	buffer.resize(offset);
	return buffer;
}

inline std::vector<uint8_t> read_all_bytes(const std::filesystem::path &path)
{
	uint64_t length = std::filesystem::file_size(path);
	std::ifstream file(path, std::ios::binary);
	if (!file)
		return {};

	std::vector<uint8_t> buffer(length);
	uint64_t remaining = length;
	uint64_t offset = 0;

	while (remaining > 0)
	{
		std::streamsize chunk = static_cast<std::streamsize>(std::min<uint64_t>(remaining, CHUNK_SIZE));
		file.read(reinterpret_cast<char *>(buffer.data() + offset), chunk);
		std::streamsize read_count = file.gcount();
		offset += read_count;
		remaining -= read_count;

		if (read_count == 0)
			break;
	}

	buffer.resize(offset);
	return buffer;
}

inline void write_byte_to_file(const std::filesystem::path &path, const std::vector<uint8_t> &bytes)
{
	std::ofstream output(path, std::ios::binary);
	if (!output)
		return;

	uint64_t remaining = bytes.size();
	uint64_t offset = 0;

	while (remaining > 0)
	{
		std::streamsize chunk = static_cast<std::streamsize>(std::min<uint64_t>(remaining, CHUNK_SIZE));
		output.write(reinterpret_cast<const char *>(bytes.data() + offset), chunk);
		offset += chunk;
		remaining -= chunk;
	}
}

inline std::vector<uint8_t> pad_sector_bytes(std::vector<uint8_t> &bytes)
{
	size_t remainder = bytes.size() % 2048;
	if (remainder != 0)
	{
		size_t padding_size = 2048 - remainder;
		bytes.insert(bytes.end(), padding_size, 0);
	}
	return bytes;
}

inline bool has_bytes(const std::vector<uint8_t> &data, uint64_t index, const std::vector<uint8_t> &find_bytes)
{
	bool correct = true;
	int j = 0;
	for (uint64_t i = index; i < index + static_cast<uint64_t>(find_bytes.size()); i++)
		correct &= data[i] == find_bytes[j++];
	return correct;
}

#endif
