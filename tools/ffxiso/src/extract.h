#ifndef _EXTRACT_H_
#define _EXTRACT_H_

#include <filesystem>

bool extract(std::filesystem::path iso_path, std::filesystem::path output_dir);

#endif
