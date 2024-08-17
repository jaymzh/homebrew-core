class Ucommon < Formula
  desc "GNU C++ runtime library for threads, sockets, and parsing"
  homepage "https://www.gnu.org/software/commoncpp/"
  url "https://ftp.debian.org/debian/pool/main/u/ucommon/ucommon_7.0.1.orig.tar.gz"
  sha256 "99fd0e2c69f24e4ca93d01a14bc3fc4e40d69576f235f80f7a8ab37c16951f3e"
  license all_of: [
    "LGPL-3.0-or-later",
    "GPL-2.0-or-later" => { with: "mif-exception" },
  ]

  livecheck do
    url "https://ftp.debian.org/debian/pool/main/u/ucommon/"
    regex(/href=.*?ucommon[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "bdb6d02a1245b3839f3d9daacc5cf458daa04c25e152ac5e42e528ca07edee2d"
    sha256 arm64_ventura:  "1f95d42a1b7169c3aab6490ecba6ca2dbff77446f65ff197fe2cd002ab6138a5"
    sha256 arm64_monterey: "52b2e7720afe7f2a3a9de958bcfd949215a74e565b7520aa99fa94025b861b09"
    sha256 arm64_big_sur:  "1270ebc3579e74f3f044e88d7bca663efac0aa581ab214514f6345ade2a7ba16"
    sha256 sonoma:         "a6ff1edc79dc57453f394d81e74426e909ad4313230bb4a5df16776369530ffb"
    sha256 ventura:        "7501d398470b723c5cae9d4a47804069c56d620228ef547e04cb9a537a29cf47"
    sha256 monterey:       "7f4755beded307911032d7952a51e9e5e710cbf246bfcce8f67e079978f28b82"
    sha256 big_sur:        "ca1bc13b9def95eb4839a628d6936ea799a284ac4d61dd53a77e77a046d3ffe1"
    sha256 catalina:       "3040baab77d1ff69f36ff21ec9259c8512170f361119e66b446a48b86f157320"
    sha256 mojave:         "34ef3423a4f8f0de02e05e8a00a5f1cb12bd0b9790103354792c24b7613ccb80"
    sha256 high_sierra:    "650bda43b289012df676190269cde7bb3be3e1337f4f2eddc6f472ae38bbda1c"
    sha256 sierra:         "0546fbc44ac1e17d8757b41a67b2d68b15bc872b4b19fea649e5d7fe54a4d2d4"
    sha256 el_capitan:     "57756d7809936ed885ef8fc7a284498ab12a5be6cc1ad41ad148dd45074fc322"
    sha256 x86_64_linux:   "f3624d1bf63f84175560167e9887d9fa88533aad863e697894683214091acb5b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--with-sslstack=gnutls", "--with-pkg-config", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"ucommon-config", "--libs"

    (testpath/"test.cpp").write <<~EOS
      #include <commoncpp/string.h>
      #include <iostream>

      int main() {
        ucommon::String test_string("Hello, Ucommon!");
        std::cout << test_string << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lucommon"
    system "./test"
  end
end
