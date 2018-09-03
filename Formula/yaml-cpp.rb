class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz"
  sha256 "e4d8560e163c3d875fd5d9e5542b5fd5bec810febdcba61481fe5fc4e6b1fd05"

  bottle do
    root_url "https://github.com/marijnvdwerf/openloco-dependencies/releases/download/v3/"
    cellar :any
    rebuild 2
    sha256 "39fde1a9783ef78ec72a537a8e731118a91cfa6d8c0d6f3b8005674527af1d0a" => :sierra
    sha256 "df45bdb39df1979e3d6daa2335ac6e0d505383aa61d997ca375fac7417ac6ef4" => :high_sierra
  end

  option :universal
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.universal_binary
    args = std_cmake_args
    if build.with? "static-lib"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
