//
// Created by Patrick on 2024/4/21.
//

#include <filesystem>
#include <random>
#include <string>
#include <sstream>

#include <cryptopp/modes.h>
#include <cryptopp/files.h>
#include <cryptopp/osrng.h>

#include <concert/internal/aes.h>

namespace concert::aes {
int Sha256(const std::string &text, CryptoPP::byte *digest) {
  using namespace CryptoPP;
  SHA256 hash;
  hash.Update((const byte *) text.c_str(), text.size());
  hash.Final(digest);
  return 0;
}

unsigned int RandomChar() {
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_int_distribution<> dis(0, 255);
  return dis(gen);
}

std::string GenerateHex(const unsigned int len) {
  std::stringstream ss;
  for (auto i = 0; i < len; i++) {
    const auto rc = RandomChar();
    std::stringstream hexstream;
    hexstream << std::hex << rc;
    auto hex = hexstream.str();
    ss << (hex.length() < 2 ? '0' + hex : hex);
  }
  return ss.str();
}

int Encrypt(const std::string &input_file_path,
            std::string output_file_path,
            const std::string &password) {
  using namespace CryptoPP;

  setlocale(LC_ALL, "zh_CN.utf8");

  try {
    if (!std::filesystem::exists(input_file_path)) {
      return CONCERT_AES_INPUT_FILE_NOT_EXISTS;
    }

    if (password.empty()) {
      return CONCERT_AES_EMPTY_PASSWORD;
    }

    // 用与判断是否使用了临时文件
    // 如果为false, 则说明指定了output_file_path, 会将加密后的数据写入output_file_path
    // 如果为true, 则说明未指定output_file_path, 此时会将加密后的数据写入一个临时文件, 再将临时文件的名称更改为input_file_path, 即将加密后的数据写入同一个文件
    bool use_temp_file = false;

    AutoSeededRandomPool prng;

    // 如果输出路径为空, 则将output_file_path更改为一个临时文件路径, 并将use_temp_file置为true
    if (output_file_path.empty()) {
      output_file_path.assign(
          std::filesystem::path(input_file_path).parent_path().string() + "/" + "tmp" + GenerateHex(16));
      use_temp_file = true;
    }

    std::ofstream ofs{output_file_path, std::ios::binary | std::ios::app};

    if (!ofs.is_open()) {
      return CONCERT_AES_CAN_NOT_OPEN_OUTPUT_FILE;
    }

    SecByteBlock iv(AES::BLOCKSIZE);
    SecByteBlock key(AES::MAX_KEYLENGTH);

    // 生成随机初始向量iv
    prng.GenerateBlock(iv, iv.size());

    // 对password使用SHA256生成一个Hash值, 并将其设置为key
    byte digest[AES::MAX_KEYLENGTH];
    Sha256(password, digest);
    key.Assign(digest, AES::MAX_KEYLENGTH);

    // 设置key和iv
    CBC_Mode<AES>::Encryption enc;
    enc.SetKeyWithIV(key, key.size(), iv);

    // 加密文件
    auto *file_sink = new FileSink{output_file_path.c_str(), true};
    auto *file_source = new FileSource(input_file_path.c_str(),
                                       true,
                                       new StreamTransformationFilter(enc,
                                                                      new Redirector(*file_sink),
                                                                      StreamTransformationFilter::PKCS_PADDING));

    // 解除对文件的占用. 如果不解除对文件的占用, 则无法对文件进行写入
    delete file_sink;
    delete file_source;

    // 将初始向量iv写入到文件末尾, 用于解密
    ofs.write((const char *) (iv.BytePtr()), iv.size());
    ofs.close();

    // 如果use_temp_file为true, 那么将临时文件的名称更改为input_file_path
    if (use_temp_file) {
      std::filesystem::remove(input_file_path);
      std::filesystem::rename(output_file_path, input_file_path);
    }
  } catch (const Exception &e) {
    if (std::filesystem::exists(output_file_path)) {
      std::filesystem::remove(output_file_path);
    }

    std::cerr << e.GetWhat() << std::endl;
    return e.GetErrorType();
  }

  return 0;
}

int Decrypt(const std::string &input_file_path,
            std::string output_file_path,
            const std::string &password) {
  using namespace CryptoPP;

  setlocale(LC_ALL, "zh_CN.utf8");

  std::ifstream ifs{input_file_path, std::ios::binary};
  std::ofstream ofs{input_file_path, std::ios::binary | std::ios::app};

  SecByteBlock iv(AES::BLOCKSIZE);
  SecByteBlock key(AES::MAX_KEYLENGTH);

  try {
    if (!std::filesystem::exists(input_file_path)) {
      return CONCERT_AES_INPUT_FILE_NOT_EXISTS;
    }

    if (password.empty()) {
      return CONCERT_AES_EMPTY_PASSWORD;
    }

    // 用与判断是否使用临时文件
    // 如果为false, 则说明指定了output_file_path, 会将解密后的数据写入output_file_path
    // 如果为true, 则说明未指定output_file_path, 此时会将解密后的数据写入一个临时文件, 再将临时文件的名称更改为input_file_path, 即将加密后的数据写入同一个文件
    bool use_temp_file = false;

    AutoSeededRandomPool prng;

    // 如果输出路径为空, 则将output_file_path更改为一个临时文件路径, 并将use_temp_file置为true
    if (output_file_path.empty()) {
      output_file_path.assign(
          std::filesystem::path(input_file_path).parent_path().string() + "/" + "tmp" + GenerateHex(16));
      use_temp_file = true;
    }

    if (!ifs.is_open()) {
      return CONCERT_AES_CAN_NOT_OPEN_INPUT_FILE;
    }

    if (!ofs.is_open()) {
      return CONCERT_AES_CAN_NOT_OPEN_OUTPUT_FILE;
    }

    auto input_file_size = std::filesystem::file_size(input_file_path);

    // 加密后的文件大小>=32 bytes, 如果input_file_size < 32, 则返回
    if (input_file_size < 32) {
      return CONCERT_AES_INPUT_FILE_LESS_THAN_32BYTES;
    }

    // 从文件末尾读取初始向量iv
    ifs.seekg(input_file_size - AES::BLOCKSIZE, std::ios::beg);
    ifs.read((char *) (iv.BytePtr()), iv.size());
    ifs.seekg(0, std::ios::beg);

    // 临时截断文件, 使得文件不包含初始向量iv, 在加密完成后再写入回去, 用于下一次解密
    std::filesystem::resize_file(input_file_path, input_file_size - AES::BLOCKSIZE);

    // 对password使用SHA256生成一个Hash值, 并将其设置为key
    byte digest[AES::MAX_KEYLENGTH];
    Sha256(password, digest);
    key.Assign(digest, AES::MAX_KEYLENGTH);

    // 设置key和iv
    CBC_Mode<AES>::Decryption dec;
    dec.SetKeyWithIV(key, key.size(), iv);

    // 解密文件
    {
      auto *file_sink = new FileSink{output_file_path.c_str(), true};
      new FileSource(input_file_path.c_str(),
                     true,
                     new StreamTransformationFilter(dec,
                                                    new Redirector(*file_sink),
                                                    StreamTransformationFilter::PKCS_PADDING));
    }

    // 解除对文件的占用. 如果不解除对文件的占用, 则无法对文件进行写入

    // 写入向量iv, 用于下一次解密
    ofs.write((const char *) (iv.BytePtr()), iv.size());

    // 关闭文件流
    ifs.close();
    ofs.close();

    // 如果use_temp_file为true, 那么将临时文件的名称更改为input_file_path
    if (use_temp_file) {
      std::filesystem::remove(input_file_path);
      std::filesystem::rename(output_file_path, input_file_path);
    }
  } catch (const Exception &e) {
    if (std::filesystem::exists(output_file_path)) {
      std::filesystem::remove(output_file_path);
    }
    ofs.write((const char *) (iv.BytePtr()), iv.size());

    std::cerr << e.GetWhat() << std::endl;
    return e.GetErrorType();
  }
  return 0;
}
}

