D2DIR = "D:/Gry/Diablo II (1.13d org)"

RSpec.describe "MPQ" do

  before(:all) do
    SCRIPT_DIR = Dir.pwd
    Dir.chdir D2DIR
    expect(Dir.pwd).to eq(D2DIR)
    require_relative '../bindings/Storm'
    require_relative '../bindings/D2Win'
  end

  after(:all) do
    Dir.chdir(SCRIPT_DIR)
  end

  describe "#load_mpqs" do
    it "loads the basic mpqs" do
      expect(D2Win.load_mpqs).to eq(1)
    end

    it "loads the media mpqs" do
      expect(D2Win.load_media_mpqs(nil, nil, 0, nil)).to eq(1)
    end

    it "can read a file from MPQ" do
      require_relative '../bindings/D2Lang'
      expect(D2Win.load_mpqs).to eq(1)
      expect(D2Lang.get_used_language).to eq(0)
    end

    after(:each) do
      D2Win.unload_mpqs
    end

  end
end
