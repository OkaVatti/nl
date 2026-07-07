# spec/route/tc_spec.cr
require "../spec_helper"

describe "LibNLRoute TC" do
  it "allocates and frees a qdisc" do
    qdisc = LibNLRoute.rtnl_qdisc_alloc
    qdisc.should_not be_nil
    LibNLRoute.rtnl_qdisc_put(qdisc)
  end

  it "allocates and frees a class" do
    cls = LibNLRoute.rtnl_class_alloc
    cls.should_not be_nil
    LibNLRoute.rtnl_class_put(cls)
  end

  # rtnl_filter_alloc/put are not exported; skip this test
  # it "allocates and frees a filter" do
  #   filter = LibNLRoute.rtnl_filter_alloc
  #   filter.should_not be_nil
  #   LibNLRoute.rtnl_filter_put(filter)
  # end

  it "allocates and frees an action" do
    act = LibNLRoute.rtnl_act_alloc
    act.should_not be_nil
    LibNLRoute.rtnl_act_put(act)
  end

  it "sets and gets qdisc kind" do
    qdisc = LibNLRoute.rtnl_qdisc_alloc
    qdisc.should_not be_nil
    kind = "htb"
    LibNLRoute.rtnl_tc_set_kind(qdisc.as(Pointer(LibNLRoute::Rtnl_Tc)), kind).should eq(0)
    get_kind = LibNLRoute.rtnl_tc_get_kind(qdisc.as(Pointer(LibNLRoute::Rtnl_Tc)))
    get_kind.should_not be_nil
    String.new(get_kind).should eq(kind)
    LibNLRoute.rtnl_qdisc_put(qdisc)
  end

  it "sets and gets qdisc handle" do
    qdisc = LibNLRoute.rtnl_qdisc_alloc
    qdisc.should_not be_nil
    handle = 0x10000_u32
    LibNLRoute.rtnl_tc_set_handle(qdisc.as(Pointer(LibNLRoute::Rtnl_Tc)), handle)
    LibNLRoute.rtnl_tc_get_handle(qdisc.as(Pointer(LibNLRoute::Rtnl_Tc))).should eq(handle)
    LibNLRoute.rtnl_qdisc_put(qdisc)
  end

  # The following tests are omitted because they depend on internal data
  # that is only initialized after the qdisc is added to the kernel,
  # and they are not safe to call on a freshly allocated object.
  #
  # it "sets HTB rate" do ... end
  # it "sets SFQ quantum" do ... end
  # it "sets TBF rate" do ... end
  # it "sets u32 filter handle" do ... end
end
