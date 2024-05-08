class Atomsk < Formula
  desc "Atomsk: A tool for manipulating and converting atomic data files"
  homepage "https://atomsk.univ-lille.fr"
  url "https://atomsk.univ-lille.fr/code/atomsk_b0.13.1.tar.gz"
  version "b0.13.1"
  sha256 "e41cea3cafc0111101d4171c9431189b4140c75921570e0c9daa19bbc97d05e5"
  license "GPL-3.0"

  # brew install --build-bottle xxx && brew bottle --json xxx
  # bottle do
  #   sha256 cellar: :any, arm64_sonoma: "f1d7ddaae37f8de5fb0d7191b549309784eb423f5f80ab986dcbb59ca332457a"
  # end

  # depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran

  def install
    ENV["FORTRAN"] = "gfortran"
    ENV["FFLAGS"] = "-O2 -fno-backslash -I..$(SEP)$(OBJ) -J..$(SEP)$(OBJ)"
    cd "src" do
      system "make", "atomsk"
    end
    bin.install "./src/atomsk"
  end

  test do
    system "#{bin}/atomsk", "-h"
  end
end
