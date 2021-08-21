class Mbrola < Formula
  desc "Speech synthesizer based on the concatenation of diphones"
  homepage "https://github.com/numediart/MBROLA"
  head "https://github.com/numediart/MBROLA.git"
  # For some reason, compilation only seems to work in verbose mode.

  option "with-voices", "Download additional MBROLA voices"

  if build.with?("voices")
    resource "mbrola-voices" do
      url "https://github.com/numediart/MBROLA-voices/archive/master.zip"
      sha256 "3a62421354992aa51bb97772da0adcf4f1446117cfef03245f02e6e379879c4b"
    end
  end

  def install
    inreplace "Makefile", "#CFLAGS += -DTARGET_OS_MAC", "CFLAGS += -DTARGET_OS_MAC"
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
