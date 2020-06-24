class Mbrola < Formula
  desc "Speech synthesizer based on the concatenation of diphones"
  homepage "https://github.com/numediart/MBROLA"
  head "https://github.com/numediart/MBROLA.git"
  # TODO: Investigate build issue on MBROLA 3.3. HEAD builds fine with the
  #       `inreplace` step below.
  #       See: https://github.com/numediart/MBROLA/issues/3
  #       See: https://github.com/numediart/MBROLA/issues/9
  # url "https://github.com/numediart/MBROLA/archive/3.3.tar.gz"
  # sha256 "c01ded2c0a05667e6df2439c1c02b011a5df2bfdf49e24a524630686aea2b558"

  option "with-voices", "Download additional MBROLA voices"

  if build.with?("voices")
    resource "mbrola-voices" do
      url "https://github.com/numediart/MBROLA-voices/archive/master.zip"
      sha256 "3a62421354992aa51bb97772da0adcf4f1446117cfef03245f02e6e379879c4b"
    end
  end

  def install
    inreplace "Misc/common.h", /^void swab/, "//void swab"
    system "make"
    bin.install "Bin/mbrola"

    if build.with?("voices")
      share.mkdir
      resource("mbrola-voices").stage { mv "data", share/"mbrola" }
    end
  end

  test do
    system "mbrola"
  end
end
