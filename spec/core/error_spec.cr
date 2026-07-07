# spec/core/error_spec.cr
require "../spec_helper"

describe "LibNL errors" do
  it "defines all error codes" do
    codes = {
      LibNL::NLE_SUCCESS      => 0,
      LibNL::NLE_FAILURE      => 1,
      LibNL::NLE_INTR         => 2,
      LibNL::NLE_BAD_SOCK     => 3,
      LibNL::NLE_AGAIN        => 4,
      LibNL::NLE_NOMEM        => 5,
      LibNL::NLE_EXIST        => 6,
      LibNL::NLE_INVAL        => 7,
      LibNL::NLE_RANGE        => 8,
      LibNL::NLE_MSGSIZE      => 9,
      LibNL::NLE_OPNOTSUPP    => 10,
      LibNL::NLE_AF_NOSUPPORT => 11,
      LibNL::NLE_OBJ_NOTFOUND => 12,
      LibNL::NLE_NOATTR       => 13,
      LibNL::NLE_MISSING_ATTR => 14,
      LibNL::NLE_OUTOF_RANGE  => 15,
      LibNL::NLE_BADMSG       => 16,
      LibNL::NLE_BADFUNC      => 17,
      LibNL::NLE_ROUND_ERR    => 18,
      LibNL::NLE_NOADDR       => 19,
      LibNL::NLE_MULTIPLE     => 20,
      LibNL::NLE_NODEV        => 21,
      LibNL::NLE_NO_CACHE     => 22,
      LibNL::NLE_SRCADDR      => 23,
      LibNL::NLE_UNSPEC       => 24,
      LibNL::NLE_INVAL_SOCK   => 25,
      LibNL::NLE_INVAL_CACHE  => 26,
      LibNL::NLE_INVAL_ATTR   => 27,
      LibNL::NLE_NOMEM_RX     => 28,
      LibNL::NLE_NO_FILE      => 29,
      LibNL::NLE_ALIGN        => 30,
      LibNL::NLE_PERM         => 31,
    }
    codes.each do |const, val|
      const.should eq(val)
    end
  end

  it "returns error message for known error" do
    msg = LibNL.nl_geterror(LibNL::NLE_INVAL)
    msg.should_not be_nil
    str = String.new(msg)
    str.should contain("Invalid")
  end

  it "returns error message for unknown error" do
    msg = LibNL.nl_geterror(999)
    msg.should_not be_nil
    String.new(msg) # Should not crash
  end
end
