<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="segmentlist.aspx.cs" Inherits="segmentlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="right_col" role="main">
        <div class="">

            <div class="clearfix"></div>

            <div class="col-md-12 col-sm-12 col-xs-12">
                <div class="x_panel">
                    <div class="x_title">
                        <h2>Segment Lists<small></small></h2>

                        <div class="clearfix"></div>
                    </div>
                    <div class="x_content">
                        <form id="form1" class="form-horizontal form-label-left" runat="server">
                            <div class="row">
                                <div class="col-md-12 col-sm-12 col-xs-12 segment-lists">
                                    <asp:Repeater ID="rptSegemnLists" runat="server" OnItemDataBound="rptSegemnLists_OnItemDataBound" OnItemCommand="rptSegemnLists_OnItemCommand">
                                        <ItemTemplate>
                                            <div class="row segmentlist">
                                                <div class="col-md-12 col-sm-12 col-xs-12 segment-item">

                                                    <div class="col-md-1 col-sm-1 col-xs-2 vcenter">
                                                        <i class="fa fa-angle-right" style="cursor: pointer;" name="angledirection" id='segemntitem_<%# Eval("pksegment") %>' onclick="showcriteria('<%# Eval("pksegment") %>', '#segemntitem_<%# Eval("pksegment") %>')"></i>
                                                    </div>
                                                    <div class="col-md-8 col-sm-8 col-xs-10 vcenter">
                                                        <div>
                                                            <a onclick="showcriteria('<%# Eval("pksegment") %>', '#segemntitem_<%# Eval("pksegment") %>')" style="cursor: pointer;" class="title"><%# Eval("segmentname") %> <span>(<asp:Label ID="lblPersonCount" runat="server" Text="0"></asp:Label></span>)</a>
                                                        </div>
                                                        <div>
                                                            <span class="subtitle">Created on - <%# Eval("createdon") %></span>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-3-nonefloat col-sm-3-nonefloat col-xs-12 vcenter text-right">
                                                        <a href="#"><i class="fa fa-users"></i></a>
                                                        <a href='segmentbuilder.aspx?id=<%# Eval("pksegment") %>'><i class="fa fa-edit" style="margin-left: 10px;"></i></a>
                                                        <asp:LinkButton ID="lnkDeleteOrganization" Style="margin-left: 10px;" runat="server" CommandName="delete"
                                                            CommandArgument='<%# Eval("pksegment")%>' OnClientClick="return confirm('Are you sure you want to delete this record?');"><i
                                                class="fa fa-trash"></i></asp:LinkButton>

                                                    </div>

                                                </div>
                                                <div class="criteriapanel" name="segment_<%# Eval("pksegment") %>" style="display: none;">
                                                    <asp:Repeater ID="rptcriteria" runat="server">
                                                        <ItemTemplate>
                                                            <div class="row">
                                                                <div class="col-md-12 col-sm-12 col-xs-12">
                                                                    <div class="col-md-3 col-sm-3 col-xs-12 criterioperation">
                                                                        <span style='<%# Convert.ToInt32(Eval("sortkey")) == 1 ? "display:none": "display:block" %>'><%# Eval("operation") %></span>
                                                                    </div>
                                                                    <div class="col-md-9 col-sm-9 col-xs-12 critericondition">
                                                                        <span><%# Eval("paramname") %> <%# Eval("conditionalias") %> '<%# Eval("filter") %>'</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:Repeater>
                                                </div>
                                            </div>
                                            <asp:HiddenField ID="hdnSegemntId" runat="server" Value='<%# Eval("pksegment") %>' />
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

            </div>

        </div>
    </div>
    <script type="text/javascript">
        function showcriteria(pksegment, elementClick) {

            if ($("[name=segment_" + pksegment + "]").length > 0) {
                if ($("[name=segment_" + pksegment + "]").is(":visible")) {
                    $("[name=segment_" + pksegment + "]").slideUp();
                    $(elementClick).attr("class", "fa fa-angle-right");
                }
                else {
                    var iconclass = $(elementClick).attr("class");
                    if (iconclass == "fa fa-angle-right") {
                        closeOpenCriteri();
                        $("[name=segment_" + pksegment + "]").slideDown("slow");
                        $(elementClick).attr("class", "fa fa-angle-down");
                    }
                }
            }

        }

        function closeOpenCriteri() {
            $("[name*=segment_]").slideUp();
            $("[name*=angledirection]").attr("class", "fa fa-angle-right");
        }

    </script>

</asp:Content>

