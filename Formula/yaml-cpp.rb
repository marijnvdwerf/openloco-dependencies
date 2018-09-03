class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.6.2.tar.gz"
  sha256 "e4d8560e163c3d875fd5d9e5542b5fd5bec810febdcba61481fe5fc4e6b1fd05"

  bottle do
    root_url "https://github.com/marijnvdwerf/openloco-dependencies/releases/download/v2/"
    cellar :any
    rebuild 1
    sha256 "5ef251085c0e4ecea0df686ee707a0f3ed81bcf9220929850c71e687647d5bf9" => :sierra
    sha256 "c6d699fa73637bcd2974ac369a55a470d0d0d94106c750290eb358ff15f6162f" => :high_sierra
  end

  option :universal
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.universal_binary if build.universal?
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
