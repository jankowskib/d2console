RSpec.describe "Registry" do

  before(:all) do
    require_relative '../bindings/Storm'
  end

  it "can read a D2 directory from registry" do
    begin
      buffer = FFI::MemoryPointer.new(256)
      Storm.reg_load_string("Diablo II", "InstallPath", 0, buffer, 256)
      dir = buffer.read_string
      expect(dir.empty?).to eq(false)
      expect(File.directory?(dir)).to eq(true)
      buffer.free
    rescue
      buffer.free
    end
  end

  it "can read a resolution value from registry" do
    begin
      buffer = FFI::MemoryPointer.new(:uint32)
      Storm.reg_load_value("Diablo II", "Resolution", 0, buffer)
      val = buffer.read_uint32
      expect(val).to be >=0
      buffer.free
    rescue
      buffer.free
    end
  end

end
