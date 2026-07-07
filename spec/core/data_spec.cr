# spec/core/data_spec.cr
require "../spec_helper"

describe "LibNL data" do
  it "allocates and frees data" do
    data = Bytes[1, 2, 3, 4, 5]
    d = LibNL.nl_data_alloc(data.to_unsafe, 5)
    d.should_not be_nil
    LibNL.nl_data_free(d)
  end

  it "gets data size" do
    data = Bytes[1, 2, 3, 4, 5]
    d = LibNL.nl_data_alloc(data.to_unsafe, 5)
    d.should_not be_nil
    LibNL.nl_data_get_size(d).should eq(5)
    # nl_data_get_pointer is not exported; we cannot test it.
    # The functionality is available via nl_data_get_pointer in C, but not here.
    LibNL.nl_data_free(d)
  end

  it "appends data" do
    d = LibNL.nl_data_alloc(Pointer(Void).null, 0)
    d.should_not be_nil
    extra = Bytes[10, 20, 30]
    LibNL.nl_data_append(d, extra.to_unsafe, 3).should eq(0)
    LibNL.nl_data_get_size(d).should eq(3)
    # We cannot verify the pointer contents, but the size is correct.
    LibNL.nl_data_free(d)
  end
end
