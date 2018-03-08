<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="segmentbuilder.aspx.cs" Inherits="segmentbuilder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <!-- bootstrap-daterangepicker -->
    <link href="css/daterangepicker.css" rel="stylesheet">
    <!-- bootstrap-datetimepicker -->
    <link href="css/bootstrap-datetimepicker.css" rel="stylesheet">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="right_col" role="main">
        <div class="">

            <div class="clearfix"></div>

            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="x_panel">
                        <div class="x_title">
                            <h2>
                                <asp:Literal ID="ltrTitle" runat="server" Text="Create Segment"></asp:Literal>
                                <small>Create a new segment with multiple criterias</small></h2>

                            <div class="clearfix"></div>
                        </div>
                        <div class="x_content">
                            <br />
                            <form id="form1" class="form-horizontal form-label-left" runat="server">
                                <div class="row">
                                    <div class="col-md-6 col-sm-6 col-xs-12">
                                        <div class="form-group">
                                            <label for="first-name">
                                                Name <span class="required">*</span>
                                            </label>
                                            <asp:TextBox ID="txtName" runat="server" required="required" CssClass="form-control col-md-7 col-xs-12" MaxLength="50"></asp:TextBox>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <div class="form-group">
                                            <label for="first-name">
                                                Criteria <span class="required">*</span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-10 col-sm-10 col-xs-12">
                                    <div class="criteria-items">
                                        <div class="row criteria-item-list">
                                            <div class="col-md-12 col-sm-12 col-xs-12">
                                                <div class="form-group">
                                                    <div class="col-md-2 col-sm-2 col-xs-12">
                                                        <%--<asp:DropDownList ID="ddlOperation" name="ddlOperation" runat="server" CssClass="form-control"></asp:DropDownList>--%>
                                                        <%--  <select id="ddlOperation" name="ddlOperation" class="form-control">
                                                        <option value="0">None</option>
                                                    </select>--%>
                                                    </div>
                                                    <div class="col-md-3 col-sm-3 col-xs-12">
                                                        <select id="ddlParameters_0" name="ddlParameters" onchange="PopulateCondition(0, this, 0, false);" class="form-control">
                                                            <option value="0">None</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-2 col-sm-2 col-xs-12">
                                                        <select id="ddlCondition_0" name="ddlCondition" onchange="PopulateFilterOption(0, this);" class="form-control">
                                                            <option value="0">None</option>
                                                        </select>
                                                    </div>
                                                    <div class="col-md-4 col-sm-4 col-xs-12">
                                                        <input type="hidden" name="hdnpksegmentdetail_0" value="0" />
                                                        <div id="forstring_0" style="display: block;">
                                                            <%--<asp:TextBox ID="txtStringFilterValue" name="txtStringFilterValue" runat="server" required="required" CssClass="form-control"></asp:TextBox>--%>
                                                            <input id="txtStringFilterValue_0" name="txtStringFilterValue" required="required" class="form-control" />
                                                        </div>
                                                        <div id="fordate_0" style="display: none;">
                                                            <div id="singledateselection_0" style="display: none;">
                                                                <div class="input-group date">
                                                                    <%--<asp:TextBox ID="txtDate" name="txtDate" runat="server" required="required" CssClass="form-control"></asp:TextBox>--%>
                                                                    <input id="txtDate_0" readonly="readonly" name="txtDate" required="required" class="form-control Datepicker" />
                                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                                                </div>

                                                            </div>
                                                            <div id="daterangeselection_0" style="display: none;">
                                                                <%--<asp:TextBox ID="txtStartDate" name="txtStartDate" runat="server" required="required" CssClass="form-control"></asp:TextBox>--%>
                                                                <div class="input-group date">
                                                                    <input id="txtRangeDate_0" readonly="readonly" name="txtStartDate" required="required" class="form-control DateRangepicker" />
                                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="col-md-1 col-sm-1 col-xs-12">
                                                        <a id="btnadd_0" style="cursor: pointer" class="addrow">
                                                            <i class="fa fa-plus-circle" style="font-size: 24px;margin-top:5px;"></i>
                                                        </a>
                                                        <a id="btndelete_0" class="deleteRow" style="cursor: pointer; display: none;">
                                                            <i class="fa fa-minus-circle" style="font-size: 24px;margin-top:5px;"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 col-sm-2 col-xs-12">
                                    <span id="selectedpramname" style="font-weight: bold;"></span>
                                    <select class="select2_multiple form-control" id="selectvalues" name="selectvalues" multiple="multiple" style="min-height: 220px; display: none;">
                                    </select>
                                </div>
                                <div class="clearfix"></div>

                                <br />
                                <br />
                                <br />
                                <div class="row">
                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <p><b>Tip:</b> Comma separated search values can be given. They will be interpreted as 'OR' criteria.</p>
                                        <p><b>Example</b> First Name contains Jones, Smith, West will be treated as (First Name contains Jones) OR (First Name contains Smith) OR (First Name contains West).</p>
                                    </div>
                                </div>

                                <div class="ln_solid"></div>
                                <div class="form-group">
                                    <div class="col-md-12 col-sm-12 col-xs-12">
                                        <button type="button" id="btnSubmit" class="btn btn-success">Submit</button>
                                        <a class="btn btn-primary" href="segmentlist.aspx">Cancel</a>
                                    </div>
                                </div>
                                <asp:HiddenField ID="hdfMode" runat="server" Value="add" />
                                <asp:HiddenField ID="hdnpksegment" runat="server" Value="0" />
                                <input type="hidden" id="hdnLastSelectedParaCount" value="0" />
                            </form>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <!-- bootstrap-daterangepicker -->
    <script src="js/moment.min.js"></script>
    <script src="js/daterangepicker.js"></script>
    <!-- bootstrap-datetimepicker -->
    <script src="js/bootstrap-datetimepicker.min.js"></script>
    <script src="js/jquery.validate.js" type="text/javascript"></script>
    <script type="text/javascript">

        var counter = 1;

        var datePickerOptions = {
            ignoreReadonly: true,
            allowInputToggle: true,
            format: 'MM/DD/YYYY'
        }

        $('.Datepicker').datetimepicker(
            datePickerOptions
        );

        var dateRangePickerOptions = {
            format: 'MM/DD/YYYY',
            opens: 'left'
        }

        $('.DateRangepicker').daterangepicker(
            dateRangePickerOptions
        );

        $(document).ready(function () {

            $("form").validate({ errorClass: "error_msg" });

            PopulateParameter(0);

            $(".criteria-items").on("click", ".addrow", function () {
                addNewRow(1);
            });

            $(".criteria-items").on("click", ".deleteRow", function (event) {
                var id = $(this).attr("id");
                var idd = id.split('_')[1];
                $("#criteria-item-list_" + idd).remove();
                counter -= 1
                if (counter == 1) {
                    $("#btnadd_" + (counter - 1)).show();
                    $("#btndelete_" + (counter - 1)).hide();
                }
                else {
                    $('.criteria-item-list:last').find("[id*=btnadd]").show();
                    $('.criteria-item-list:last').find("[id*=btndelete]").show();
                }
            });

            $('#selectvalues').change(function (e) {
                var currentparamRowCount = $("#hdnLastSelectedParaCount").val();
                var selectedValue = $(e.target).val();
                $("#txtStringFilterValue_" + currentparamRowCount).val(selectedValue);
            });

            $("#btnSubmit").click(function () {

                //if ($("form")[0].checkValidity()) {
                var form = $("#form1");
                if (form.valid()) {
                    NProgress.start();
                    var data = JSON.stringify(getAllSegmentCriteria());

                    var segementName = $("#<%= txtName.ClientID %>").val();
                    var pksegment = 0;
                    if ($("#<%= hdfMode.ClientID %>").val() == "edit") {
                        pksegment = parseInt($("#<%= hdnpksegment.ClientID %>").val());
                    }
                    $.ajax({
                        url: 'segmentbuilder.aspx/SaveSegment',
                        type: 'POST',
                        dataType: 'json',
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({ 'segmentname': segementName, 'segmentdata': data, 'pksegment': pksegment }),
                        success: function () {
                            NProgress.done();
                            window.location.href = "segmentlist.aspx";
                        },
                        error: function () {
                            alert("Error while inserting data");
                            NProgress.done();
                        }
                    });
                    //}
                    //else {
                    //    $("form")[0].reportValidity();
                    // }
                }


            });

        });

        function addNewRow(operationselect) {

            var rowdata = '<div class="row criteria-item-list" id="criteria-item-list_' + counter + '">';

            rowdata += '<div class="col-md-12 col-sm-12 col-xs-12">';
            rowdata += '<div class="form-group">';
            rowdata += '<div class="col-md-2 col-sm-2 col-xs-12">';
            rowdata += '<select id="ddlOperation_' + counter + '" name="ddlOperation" class="form-control"></select></div>';

            rowdata += '<div class="col-md-3 col-sm-3 col-xs-12">';
            rowdata += '<select id="ddlParameters_' + counter + '" name="ddlParameters" onchange="PopulateCondition(' + counter + ', this, 0, false);" class="form-control"></select></div>';

            rowdata += '<div class="col-md-2 col-sm-2 col-xs-12">';
            rowdata += '<select id="ddlCondition_' + counter + '" name="ddlCondition" onchange="PopulateFilterOption(' + counter + ', this);" class="form-control"></select></div>';

            rowdata += '<div class="col-md-4 col-sm-4 col-xs-12"> <input type="hidden" name="hdnpksegmentdetail_' + counter + '" value="0" />';
            rowdata += '<div id="forstring_' + counter + '" style="display: block;"><input id="txtStringFilterValue_' + counter + '" name="txtStringFilterValue" required="required" class="form-control" /></div>';
            rowdata += '<div id="fordate_' + counter + '" style="display: none;"><div id="singledateselection_' + counter + '" style="display: none;"><div class="input-group date"><input id="txtDate_' + counter + '" name="txtDate" required="required" class="form-control Datepicker" readonly="readonly" /><span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span></div ></div>';
            rowdata += '<div id="daterangeselection_' + counter + '" style="display: none;"><div class="input-group date"><input id="txtRangeDate_' + counter + '" readonly="readonly" name="txtRangeDate" required="required" class="form-control DateRangepicker" /><span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span></div ></div>';
            rowdata += '</div></div>';

            rowdata += '<div class="col-md-1 col-sm-1 col-xs-12"><a id="btnadd_' + counter + '"  style="cursor: pointer" class="addrow"><i class="fa fa-plus-circle" style="font-size: 24px;margin-top:5px;"></i></a>&nbsp;&nbsp;<a  id="btndelete_' + counter + '" class="deleteRow" style="cursor: pointer;"><i class="fa fa-minus-circle" style="font-size: 24px;margin-top:5px;"></i></a></div>';
            rowdata += '</div></div></div>';

            if (counter - 1 == 0) {
                $("#btnadd_" + (counter - 1)).hide();
                $("#btndelete_" + (counter - 1)).hide();
            }
            else {
                $("#btnadd_" + (counter - 1)).hide();
                $("#btndelete_" + (counter - 1)).show();
            }

            $(".criteria-items").append(rowdata);

            $('#ddlParameters_0 option').clone().appendTo("#ddlParameters_" + counter);
            PopulateOperation(counter, operationselect);

            $(".Datepicker").datetimepicker(datePickerOptions);
            $(".DateRangepicker").daterangepicker(dateRangePickerOptions);
            counter++;
        }

        function PopulateCondition(elementNo, param, selectvalue, IsEditLoadTime) {
            NProgress.start();
            var pkparam = $(param).val();
            $.ajax({
                type: "POST",
                url: "segmentbuilder.aspx/PopulateCondition",
                data: '{pkparam : ' + pkparam + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var ddlCondition = $("[id=ddlCondition_" + elementNo + "]");
                    ddlCondition.find("option").remove();
                    $.each(r.d, function () {
                        ddlCondition.append($("<option></option>").val(this['Text']).html(this['Value']));
                    });
                    if (selectvalue > 0) {
                        ddlCondition.val(selectvalue);
                    }
                    if (!IsEditLoadTime) {
                        PopulateParameterValues(pkparam, param);
                    }
                    else
                    {
                        NProgress.done();
                    }
                    var paramID = $(param).attr("id");
                    var param_count = paramID.split('_')[1];
                    $("#hdnLastSelectedParaCount").val(param_count);
                    ddlCondition.trigger("change");
                    
                }
            });
        }

        function PopulateParameter(elementNo) {
            $.ajax({
                type: "POST",
                url: "segmentbuilder.aspx/PopulateParameter",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var ddlParameters = $("[id=ddlParameters_" + elementNo + "]");
                    ddlParameters.empty().append('<option selected="selected" value="0">Parameter</option>');
                    $.each(r.d, function () {
                        ddlParameters.append($("<option></option>").val(this['Text']).html(this['Value']));
                    });

                    if ($("#<%= hdfMode.ClientID %>").val() == "edit") {
                        var pksegment = parseInt($("#<%= hdnpksegment.ClientID %>").val());
                        if (pksegment > 0) {
                            LoadSegment(pksegment);
                        }
                    }
                }
            });
        }

        function PopulateParameterValues(pkparam, param) {
            NProgress.start();
            $.ajax({
                type: "POST",
                url: "segmentbuilder.aspx/PopulateParameterValues",
                data: '{ pkparam : ' + pkparam + ' }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var selectvalues = $("[name=selectvalues]");
                    selectvalues.empty();
                    if (r.d.length > 0) {
                        $.each(r.d, function () {
                            selectvalues.append($("<option></option>").val(this['Text']).html(this['Value']));
                        });
                        selectvalues.show();
                        $("#selectedpramname").text($(param).find('option:selected').text());
                    }
                    else {
                        selectvalues.hide();
                        selectvalues.empty();
                        $("#selectedpramname").text("");
                    }
                    NProgress.done();
                }
            });
        }

        function PopulateOperation(elementNo, selectvalue) {
            $.ajax({
                type: "POST",
                url: "segmentbuilder.aspx/PopulateOperation",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var ddlOperation = $("[id=ddlOperation_" + elementNo + "]");
                    $.each(r.d, function () {
                        ddlOperation.append($("<option></option>").val(this['Text']).html(this['Value']));
                    });
                    ddlOperation.val(selectvalue);
                }
            });
        }

        function PopulateFilterOption(elementNo, condition) {
            var pkcondition = $(condition).val();
            var condition = $(condition).find('option:selected').text();
            $.ajax({
                type: "POST",
                url: "segmentbuilder.aspx/GetParamType",
                data: '{pkcondition : ' + pkcondition + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    if (r.d == "string") {
                        $("#forstring_" + elementNo).show();
                        $("#fordate_" + elementNo).hide();
                        var attr = $("#txtStringFilterValue_" + elementNo).attr('readonly');
                        if (typeof attr !== typeof undefined && attr !== false) {
                            $("#txtStringFilterValue_" + elementNo).removeAttr('readonly');
                            $("#txtStringFilterValue_" + elementNo).val("");
                        }
                    } else if (r.d == "date") {
                        $("#forstring_" + elementNo).hide();
                        $("#fordate_" + elementNo).show();
                        if (condition == "between") {
                            $("#daterangeselection_" + elementNo).show();
                            $("#forstring_" + elementNo).hide();
                            $("#singledateselection_" + elementNo).hide();
                        } else if (condition == "Today") {
                            $("#forstring_" + elementNo).show();
                            $("#txtStringFilterValue_" + elementNo).val("#{TODAY}");
                            $('#txtStringFilterValue_' + elementNo).attr('readonly', 'readonly');
                            $("#fordate_" + elementNo).hide();
                        }
                        else if (condition == "Last Month") {
                            $("#forstring_" + elementNo).show();
                            $("#txtStringFilterValue_" + elementNo).val("#{LASTMONTH}");
                            $('#txtStringFilterValue_' + elementNo).attr('readonly', 'readonly');
                            $("#fordate_" + elementNo).hide();
                        }
                        else if (condition == "Current Month") {
                            $("#forstring_" + elementNo).show();
                            $("#txtStringFilterValue_" + elementNo).val("#{CURRENTMONTH}");
                            $('#txtStringFilterValue_' + elementNo).attr('readonly', 'readonly');
                            $("#fordate_" + elementNo).hide();
                        }
                        else if (condition == "Last Week") {
                            $("#forstring_" + elementNo).show();
                            $("#txtStringFilterValue_" + elementNo).val("#{LASTWEEK}");
                            $('#txtStringFilterValue_' + elementNo).attr('readonly', 'readonly');
                            $("#fordate_" + elementNo).hide();
                        }
                        else if (condition == "Current Week") {
                            $("#forstring_" + elementNo).show();
                            $("#txtStringFilterValue_" + elementNo).val("#{CURRENTWEEK}");
                            $('#txtStringFilterValue_' + elementNo).attr('readonly', 'readonly');
                            $("#fordate" + elementNo).hide();
                        }
                        else {
                            $("#singledateselection_" + elementNo).show();
                            $("#daterangeselection_" + elementNo).hide();
                        }
                    }
                }
            });
        }

        function getAllSegmentCriteria() {

            var data = [];

            $('.criteria-item-list').each(function () {
                if ($(this).find('[name=ddlParameters]').length > 0) {
                    var pksegmentdetail = $(this).find('[name=pksegmentdetail]').val();
                    var param = $(this).find('[name=ddlParameters]').val();
                    var condition = $(this).find('[name=ddlCondition]').val();
                    var operation = $(this).find('[name=ddlOperation]').val();
                    var string_filter_value = $(this).find('[name=txtStringFilterValue]').val();
                    var txtDate = $(this).find('[name=txtDate]').val();
                    var txtRangeDate = $(this).find('[name=txtRangeDate]').val();

                    var segmentdata = {
                        'pksegmentdetail': pksegmentdetail,
                        'fkparam': param,
                        'fkcondition': condition,
                        'fkoperation': operation === undefined ? 1 : operation,
                        'string_filter_value': string_filter_value === undefined ? "" : string_filter_value,
                        'txtDate': txtDate === undefined ? "" : txtDate,
                        'txtRangeDate': txtRangeDate === undefined ? "" : txtRangeDate
                    }
                    data.push(segmentdata);

                }
            });

            return data;
        }

        function LoadSegment(pksegment) {
            NProgress.start();
            $.ajax({
                type: "POST",
                url: "segmentbuilder.aspx/GetSegmentDetailInJSON",
                data: '{ pksegment :' + pksegment + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    var json = jQuery.parseJSON(r.d);
                    var count = 0;

                    $.each(json, function (idx, obj) {

                        if (count > 0) {
                            //$(".addrow").trigger("click");
                            addNewRow(obj.fkoperation);
                        }

                        $("[name=hdnpksegmentdetail_" + count + "]").val(obj.pksegmentdetail);

                        $("#ddlParameters_" + count).val(obj.fkparam);
                        PopulateCondition(count, "#ddlParameters_" + count, obj.fkcondition, true);

                        if (obj.paramtype == "string") {
                            $("#forstring_" + count).show();
                            $("#fordate_" + count).hide();
                            $("#txtStringFilterValue_" + count).val(obj.filter);
                        }
                        else if (obj.paramtype == "date") {
                            if (obj.condition == "between") {
                                $("#daterangeselection_" + count).show();
                                $("#forstring_" + count).hide();
                                $("#singledateselection_" + count).hide();
                                $("#txtRangeDate_" + count).val(obj.filter);
                            } else if (obj.condition == "Today") {
                                $("#forstring_" + count).show();
                                $("#txtStringFilterValue_" + count).val("#{TODAY}");
                                $('#txtStringFilterValue_' + count).attr('readonly', 'readonly');
                                $("#fordate_" + count).hide();
                                $("#txtStringFilterValue_" + count).val(obj.filter);
                            }
                            else if (obj.condition == "Last Month") {
                                $("#forstring_" + count).show();
                                $("#txtStringFilterValue_" + count).val("#{LASTMONTH}");
                                $('#txtStringFilterValue_' + count).attr('readonly', 'readonly');
                                $("#fordate_" + count).hide();
                                $("#txtStringFilterValue_" + count).val(obj.filter);
                            }
                            else if (obj.condition == "Current Month") {
                                $("#forstring_" + count).show();
                                $("#txtStringFilterValue_" + count).val("#{CURRENTMONTH}");
                                $('#txtStringFilterValue_' + count).attr('readonly', 'readonly');
                                $("#fordate_" + count).hide();
                                $("#txtStringFilterValue_" + count).val(obj.filter);
                            }
                            else if (obj.condition == "Last Week") {
                                $("#forstring_" + count).show();
                                $("#txtStringFilterValue_" + count).val("#{LASTWEEK}");
                                $('#txtStringFilterValue_' + count).attr('readonly', 'readonly');
                                $("#fordate_" + count).hide();
                                $("#txtStringFilterValue_" + count).val(obj.filter);
                            }
                            else if (obj.condition == "Current Week") {
                                $("#forstring_" + count).show();
                                $("#txtStringFilterValue_" + count).val("#{CURRENTWEEK}");
                                $('#txtStringFilterValue_' + count).attr('readonly', 'readonly');
                                $("#fordate_" + count).hide();
                                $("#txtStringFilterValue_" + count).val(obj.filter);
                            }
                            else {
                                $("#singledateselection_" + count).show();
                                $("#daterangeselection_" + count).hide();
                                $("#txtDate_" + count).val(obj.filter);
                            }

                        }
                        count++;
                    });
                    NProgress.done();
                }
            });

        }

    </script>
</asp:Content>

