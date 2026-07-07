# spec/core/object_spec.cr
require "../spec_helper"

describe "LibNL object" do
  it "allocates and frees an object (if route/link ops available)" do
    ops = LibNL.nl_cache_ops_lookup("route/link")
    if !ops.null?
      link = LibNLRoute.rtnl_link_alloc
      link.should_not be_nil
      obj = link.as(Pointer(LibNL::NL_Object))
      LibNL.nl_object_get(obj)
      LibNL.nl_object_put(obj)
      LibNL.nl_object_put(obj) # should free
      LibNL.nl_cache_ops_put(ops)
    end
  end

  it "marks and checks marks" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    obj = link.as(Pointer(LibNL::NL_Object))
    LibNL.nl_object_mark(obj)
    LibNL.nl_object_is_marked(obj).should eq(1)
    LibNL.nl_object_unmark(obj)
    LibNL.nl_object_is_marked(obj).should eq(0)
    LibNL.nl_object_put(obj)
  end

  it "clones an object" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    obj = link.as(Pointer(LibNL::NL_Object))
    cloned = LibNL.nl_object_clone(obj)
    cloned.should_not be_nil
    LibNL.nl_object_put(cloned)
    LibNL.nl_object_put(obj)
  end

  it "dumps object to buffer" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    obj = link.as(Pointer(LibNL::NL_Object))
    buf = Bytes.new(1024)
    buf_ptr = buf.to_unsafe.as(LibC::Char*)
    # Should not crash
    LibNL.nl_object_dump_buf(obj, buf_ptr, 1024_u64)
    # Optionally check that buffer contains something (may be empty)
    str = String.new(buf_ptr)
    # No assertion required; we just ensure no crash
    LibNL.nl_object_put(obj)
  end
end
